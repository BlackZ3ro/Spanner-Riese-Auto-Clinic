-- 0007 - Make delete_booking_and_restock work for BOTH apps, and admin-only
-- in the database itself.
--
-- STATUS: NEW - Gary to run this on the live project (SQL editor).
--
-- Why:
-- 1. 0005 only removed web labour (`jobs`). Mobile records labour in
--    `booking_labor`, so deleting a mobile booking through this function
--    would fail on the booking_labor -> bookings foreign key (or leave
--    orphans). Now clears booking_labor too. booking_push_tokens cascade.
-- 2. Mobile deleted bookings with several separate calls (restock each part,
--    then delete), so a failure halfway left stock and bookings out of sync.
--    Mobile now calls this one function instead - a single transaction.
-- 3. Agreed 23 Sept: only Admin can delete a booking. Both apps hide the
--    button, but anyone signed in could call this function directly. It now
--    checks the caller's role in `profiles` (0006).
--    [CHECK] Every web admin (AdminEmails in web/appsettings.json) must have
--    a profiles row with role = 'admin', or web delete will be refused.

create or replace function public.delete_booking_and_restock(
  p_booking_id uuid,
  p_user_id uuid
)
returns void
language plpgsql
as $$
declare
  r record;
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and role = 'admin') then
    raise exception 'Only an admin can delete a booking' using errcode = '42501';
  end if;

  for r in
    select stock_item_id, quantity
    from public.booking_parts
    where booking_id = p_booking_id
  loop
    update public.stock_items
    set quantity_on_hand = stock_items.quantity_on_hand + r.quantity
    where id = r.stock_item_id;

    insert into public.stock_movements (item_id, type, quantity, cost_at_time, reference, user_id)
    select r.stock_item_id, 'in', r.quantity, stock_items.cost_price, 'Booking deleted - restocked', p_user_id
    from public.stock_items
    where id = r.stock_item_id;
  end loop;

  delete from public.jobs where booking_id = p_booking_id;
  delete from public.booking_labor where booking_id = p_booking_id;
  delete from public.booking_parts where booking_id = p_booking_id;
  delete from public.bookings where id = p_booking_id;
end;
$$;

grant execute on function public.delete_booking_and_restock(uuid, uuid) to authenticated;
