-- Bug found during a code review (not by testing, since we have no
-- authenticated dashboard access to run a concurrency test): Pages/Bookings/
-- Details.cshtml.cs used to read quantity_on_hand, check it client-side, then
-- write back a client-computed absolute value. Two staff adding the same part
-- to different bookings at the same time could both read the same starting
-- quantity, both pass the check, and both write - the second write clobbers
-- the first, oversubscribing stock with no error to either staff member.
--
-- A first version of this migration fixed only the decrement itself with a
-- self-checking WHERE clause, leaving the app to make 3 separate calls
-- (decrement, insert booking_parts, insert stock_movements). A second review
-- pass (before this was ever applied - safe to replace outright) found that
-- split was itself a bug: if the decrement succeeded but either insert then
-- failed (network blip, RLS hiccup), stock was permanently decremented with
-- no booking_parts/stock_movements row to explain it - inventory silently
-- drifts with zero audit trail. This version does all three writes in one
-- function call, so a Postgres function's implicit transaction covers all of
-- them - any failure rolls back everything, not just the decrement.
--
-- Also returns the CURRENT quantity_on_hand on a failed/declined attempt
-- (rather than the app reusing the stale pre-check value it already had) -
-- another review finding: the old two-step version's "only N left" error
-- message quoted the number from before the race, which could already be
-- wrong by the time it was shown.
--
-- security invoker (the default) - runs under the calling staff member's own
-- role/RLS, same as every other write this app already makes to these tables.
create or replace function public.add_booking_part(
  p_booking_id uuid,
  p_stock_item_id uuid,
  p_qty integer,
  p_unit_price numeric,
  p_user_id text,
  p_reference text
)
returns table (ok boolean, quantity_on_hand integer)
language plpgsql
as $$
declare
  v_affected integer;
  v_remaining integer;
  v_cost_price numeric;
begin
  update public.stock_items
  set quantity_on_hand = quantity_on_hand - p_qty
  where id = p_stock_item_id and quantity_on_hand >= p_qty;

  get diagnostics v_affected = row_count;

  select stock_items.quantity_on_hand, stock_items.cost_price
    into v_remaining, v_cost_price
  from public.stock_items
  where id = p_stock_item_id;

  if v_affected = 0 then
    return query select false, v_remaining;
    return;
  end if;

  insert into public.booking_parts (booking_id, stock_item_id, quantity, unit_price)
  values (p_booking_id, p_stock_item_id, p_qty, p_unit_price);

  insert into public.stock_movements (item_id, type, quantity, cost_at_time, reference, user_id)
  values (p_stock_item_id, 'out', p_qty, v_cost_price, p_reference, p_user_id);

  return query select true, v_remaining;
end;
$$;

grant execute on function public.add_booking_part(uuid, uuid, integer, numeric, text, text) to authenticated;
