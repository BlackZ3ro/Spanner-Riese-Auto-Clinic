-- 0010 - Record which staff member booked a vehicle in (bookings.created_by).
--
-- STATUS: NEW - Gary to run on the live project (SQL editor). Safe to re-run.
--
-- Why: at the Phase 2 presentation (16 Oct 2026) Ms Mbele asked where the
-- mechanic is in the ERD: "who is the one logged into the system doing this?"
-- and "how do they say that the admin is the one who will populate that
-- table?". Nothing in the schema linked a booking to the staff member who
-- captured it. This adds that link, so the ERD can show
-- auth.users (staff) --records--> bookings.
--
-- No app changes needed: the column defaults to auth.uid(), the signed-in
-- staff member whose JWT made the insert. Neither the web app (Booking.cs)
-- nor the mobile app sends created_by, so the default always applies.
-- Older bookings stay null (who booked them in was never recorded), which is
-- why the column is nullable and the ERD shows "zero or one" on the staff end.
-- References auth.users (not profiles) so a staff account without a profiles
-- row can still book in.

alter table public.bookings
  add column if not exists created_by uuid default auth.uid()
    references auth.users(id) on delete set null;

comment on column public.bookings.created_by is
  'Staff member (auth.users.id) who booked the vehicle in. Set by default from auth.uid().';
