-- M2 (FR-02): a booking can have one or more jobs (units of work) attached to it.
-- Applied live by Gary (2026-09-08). Kept here as the record of what was run and
-- reviewed, and so a fresh local Supabase instance can be brought up to match.
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
