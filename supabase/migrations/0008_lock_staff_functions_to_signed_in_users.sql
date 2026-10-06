-- 0008 - Staff-only database functions must not be callable without login.
--
-- STATUS: NEW - Gary to run on the live project (SQL editor). Safe to re-run.
--
-- Found 7 Oct 2026 with the public (anon) key that ships inside the APK:
--   update_booking_phase  -> ran for an anonymous caller (HTTP 200). Anyone
--                            with a booking's id could change its phase,
--                            which also pushes a notification to the customer,
--                            and the function returns the whole booking row
--                            (customer name, phone, email).
--   delete_booking_and_restock -> correctly refused ("Only an admin can delete
--                            a booking"), so 0007 is applied.
--
-- Cause: Postgres grants EXECUTE on new functions to PUBLIC (which includes
-- the anon role) unless it is revoked. This migration revokes it for every
-- staff function and grants it back to signed-in users only. Function bodies
-- are NOT changed.
--
-- Deliberately left public (the customer screens need them, no login):
--   get_booking_by_reference_code, register_push_token

do $$
declare
  f record;
begin
  for f in
    select p.oid::regprocedure as sig
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in ('update_booking_phase', 'delete_booking_and_restock', 'add_booking_part', 'generate_reference_code')
  loop
    execute format('revoke execute on function %s from public, anon', f.sig);
    execute format('grant execute on function %s to authenticated', f.sig);
  end loop;
end $$;

-- Check afterwards (should list only authenticated / postgres / service_role):
-- select routine_name, grantee from information_schema.routine_privileges
-- where routine_schema = 'public'
--   and routine_name in ('update_booking_phase', 'delete_booking_and_restock', 'add_booking_part');
