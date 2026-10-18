-- 0011 - Only an admin can finalize or reopen a booking, enforced by the
-- database, not just by hiding the buttons.
--
-- STATUS: NEW - Gary to run on the live project (SQL editor). Safe to re-run.
--
-- Why: FR-17 says only an Admin can finalize, delete or reopen a booking.
-- Delete is already checked in the database (0007). Finalize and reopen are
-- plain updates of bookings.status, so today the only thing stopping a
-- mechanic is that both apps hide the buttons. The Unit 4 notes (Activity
-- 4.4, Step 5) ask groups to "check that the database permissions support
-- the intended access rules, rather than relying only on hiding buttons or
-- pages".
--
-- How: a trigger that refuses any change to bookings.status (checked_in <->
-- closed) unless the signed-in user is an admin in profiles - the same check
-- 0007 uses. Phase changes, parts and labour don't touch status, so
-- mechanics keep doing those. The dashboard and service-role tools (where
-- auth.uid() is null) are not affected.
--
-- [CHECK] Same as 0007: every web admin (AdminEmails in web/appsettings.json)
-- must have a profiles row with role = 'admin', or the web's Finalize will be
-- refused for them too.

create or replace function public.enforce_admin_status_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status is distinct from old.status
     and auth.uid() is not null
     and not exists (select 1 from public.profiles where id = auth.uid() and role = 'admin') then
    raise exception 'Only an admin can finalize or reopen a booking' using errcode = '42501';
  end if;
  return new;
end;
$$;

drop trigger if exists bookings_admin_status_change on public.bookings;
create trigger bookings_admin_status_change
  before update of status on public.bookings
  for each row execute function public.enforce_admin_status_change();
