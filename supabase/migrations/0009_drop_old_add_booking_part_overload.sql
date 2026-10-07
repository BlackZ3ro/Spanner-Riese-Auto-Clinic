-- 0009 - Adding a part on the web fails with:
--   column "user_id" is of type uuid but expression is of type text  (42804)
--
-- STATUS: NEW - Gary to run on the live project (SQL editor). Safe to re-run.
--
-- Cause: 0004's first version declared p_user_id as TEXT. The fixed version
-- (p_user_id UUID, in this repo since 19 Sept) was applied with
-- `create or replace`, but a different parameter type does not REPLACE a
-- function in Postgres: it adds a second overload. The old text version is
-- still there and is the one being called (reported again 8 Oct 2026).
--
-- Fix: drop every add_booking_part overload whose p_user_id is text, then
-- re-run the CURRENT 0004 (the uuid version) to be sure it exists, then
-- re-apply 0008's grant so the function stays signed-in only.

do $$
declare
  f record;
begin
  for f in
    select p.oid::regprocedure as sig
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname = 'add_booking_part'
      and pg_get_function_identity_arguments(p.oid) like '%p_user_id text%'
  loop
    execute format('drop function %s', f.sig);
    raise notice 'dropped %', f.sig;
  end loop;
end $$;

-- ORDER: 1) run this file, 2) run 0004_atomic_stock_decrement.sql again (it is
-- idempotent and creates the uuid version), 3) run 0008 again (re-locks it to
-- signed-in users).

-- Check: exactly one row, with p_user_id uuid.
-- select pg_get_function_identity_arguments(oid) from pg_proc where proname = 'add_booking_part';
