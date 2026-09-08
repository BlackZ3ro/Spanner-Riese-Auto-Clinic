-- M2 (FR-02): a booking can have one or more jobs (units of work) attached to it.
-- This table does not exist yet in the live project - run this in the Supabase
-- SQL editor (or via the CLI) after review. It's purely additive: a new table with
-- a foreign key to the existing `bookings` table, no existing table/column is
-- touched, so it can't break anything mobile or web already does.
--
-- RLS below only allows the `authenticated` role (i.e. logged-in staff) to read/
-- write jobs, matching FR-12's "restrict access to authenticated staff" intent.
-- Loosen/adjust if that's not how RLS is set up on `bookings`/`stock_items`.

create table if not exists public.jobs (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null references public.bookings(id) on delete cascade,
  job_type text not null,
  status text not null default 'pending',
  labour_hours numeric(6, 2),
  labour_rate numeric(8, 2),
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

alter table public.jobs enable row level security;

create policy "Authenticated staff can view jobs"
  on public.jobs for select
  to authenticated
  using (true);

create policy "Authenticated staff can add jobs"
  on public.jobs for insert
  to authenticated
  with check (true);

create policy "Authenticated staff can update jobs"
  on public.jobs for update
  to authenticated
  using (true);
