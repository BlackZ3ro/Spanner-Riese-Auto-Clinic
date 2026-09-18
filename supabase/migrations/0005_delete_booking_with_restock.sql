-- Everything in this file was checked directly against the live database
-- before being written, not guessed from the C# models - the lesson from
-- 0004 needing two live fixes after being applied blind.
--
-- Confirmed live: bookings had no DELETE policy, same bug class as jobs
-- before 0003 - a DELETE returned 204 but the row was still there on the
-- next authenticated read. Fixed the same way jobs was.
create policy "Authenticated staff can delete bookings"
  on public.bookings for delete
  to authenticated
  using (true);

-- Confirmed live and unaffected (no new policy needed): authenticated can
-- already DELETE booking_parts, UPDATE stock_items.quantity_on_hand, and
-- INSERT stock_movements - all proven working elsewhere in this app already
-- (the last two are exactly what 0004's add_booking_part does in reverse).
--
-- Deleting a booking restocks every part used on it (adds the quantity back
-- to stock_items.quantity_on_hand, with a matching stock_movements 'in' row
-- for the audit trail - same ledger pattern every other stock change already
-- uses), removes every job (labour) on the booking, then removes the parts
-- and the booking itself. One function call so a Postgres function's
-- implicit transaction covers all of it - same reasoning as 0004: a failure
-- partway through must roll back everything, not leave stock restocked with
-- the booking still present or vice versa.
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
  delete from public.booking_parts where booking_id = p_booking_id;
  delete from public.bookings where id = p_booking_id;
end;
$$;

grant execute on function public.delete_booking_and_restock(uuid, uuid) to authenticated;
