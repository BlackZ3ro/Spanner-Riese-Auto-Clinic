-- 0006 - RECORD of the schema Gary built in the Supabase dashboard (Sept 2026)
-- for mobile login, booking phases, the customer reference-code lookup and
-- push notifications.
--
-- STATUS: ALREADY LIVE on the Spanner project. Do NOT run this against it.
-- This file exists so the repo (and the ERD, and the markers) show the real
-- schema. It was RECONSTRUCTED from the mobile code on main (models,
-- repositories, RPC calls and the send-phase-notification edge function),
-- because the dashboard SQL was never committed.
--
-- Gary: please check it against the live project and fix anything that
-- differs - easiest is `supabase db pull` from mobile/ and paste the real
-- definitions over the reconstructed ones below. Items marked [CHECK] are
-- guesses about details the app code can't reveal.
--
-- Everything is idempotent (if not exists / or replace), so running it on a
-- FRESH project gives a working copy.

-- 1. Staff profiles: one row per auth user, role drives admin-only actions in
--    the mobile app (features/auth/providers/auth_provider.dart).
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('admin', 'mechanic')),
  full_name text,
  created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
-- [CHECK] policy: each signed-in user reads their own profile.
drop policy if exists "profiles: read own" on public.profiles;
create policy "profiles: read own" on public.profiles
  for select to authenticated using (id = auth.uid());

-- 2. Booking phase + customer reference code.
--    Phases match features/bookings/models/booking_phase.dart.
alter table public.bookings
  add column if not exists phase text not null default 'booked_in';
alter table public.bookings drop constraint if exists bookings_phase_check;
alter table public.bookings add constraint bookings_phase_check
  check (phase in ('booked_in', 'labor_in_progress', 'reassembly', 'ready_for_pickup', 'finalized'));

-- [CHECK] generator: 8 characters from an alphabet without look-alikes
-- (no 0/O, 1/I). Real codes seen so far look like this (e.g. CY45KLGP).
-- Must be random, not sequential, or customers can guess each other's codes.
create or replace function public.generate_reference_code()
returns text
language plpgsql
volatile
as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  code text;
begin
  loop
    code := '';
    for i in 1..8 loop
      code := code || substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1);
    end loop;
    exit when not exists (select 1 from public.bookings where reference_code = code);
  end loop;
  return code;
end;
$$;

alter table public.bookings
  add column if not exists reference_code text unique default public.generate_reference_code();
update public.bookings set reference_code = public.generate_reference_code() where reference_code is null;
alter table public.bookings alter column reference_code set not null;

-- 3. Staff move a booking between phases (mobile: vehicle_booking_repository
--    updatePhase). 'finalized' is only ever set by closing the booking.
create or replace function public.update_booking_phase(p_booking_id uuid, p_phase text)
returns json
language plpgsql
as $$
declare
  result json;
begin
  if p_phase = 'finalized' then
    raise exception 'finalized is set when a booking is closed, not directly';
  end if;
  update public.bookings
     set phase = p_phase
   where id = p_booking_id and status <> 'closed'
  returning row_to_json(bookings.*) into result;
  if result is null then
    raise exception 'booking not found or already closed';
  end if;
  return result;
end;
$$;
grant execute on function public.update_booking_phase(uuid, text) to authenticated;

-- 4. Customer lookup by reference code, no login (customer_booking_repository).
--    security definer + a narrow return shape, so anon never gets direct
--    SELECT on bookings. Shape matches customer_booking_view.dart.
create or replace function public.get_booking_by_reference_code(p_code text)
returns json
language sql
stable
security definer
set search_path = public
as $$
  select json_build_object(
    'reference_code', b.reference_code,
    'invoice_number', b.invoice_number,
    'brand', b.brand,
    'model', b.model,
    'year', b.year,
    'registration', b.registration,
    'image_url', b.image_url,
    'phase', b.phase,
    'status', b.status,
    'created_at', b.created_at,
    'closed_at', b.closed_at,
    'parts', coalesce((
      select json_agg(json_build_object('name', s.name, 'quantity', p.quantity))
      from public.booking_parts p join public.stock_items s on s.id = p.stock_item_id
      where p.booking_id = b.id), '[]'::json),
    'labor', coalesce((
      select json_agg(json_build_object('description', l.description, 'hours', l.hours))
      from public.booking_labor l
      where l.booking_id = b.id), '[]'::json)
  )
  from public.bookings b
  where b.reference_code = upper(trim(p_code))
  limit 1;
$$;
revoke all on function public.get_booking_by_reference_code(text) from public;
grant execute on function public.get_booking_by_reference_code(text) to anon, authenticated;

-- 5. Push tokens: a customer's phone subscribes to one booking's updates
--    (push_notification_service.dart). Read by the send-phase-notification
--    edge function with the service role.
create table if not exists public.booking_push_tokens (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null references public.bookings(id) on delete cascade,
  fcm_token text not null,
  created_at timestamptz not null default now(),
  unique (booking_id, fcm_token)
);
alter table public.booking_push_tokens enable row level security;
-- No policies on purpose: only the security-definer function below and the
-- service-role edge function touch this table.

create or replace function public.register_push_token(p_reference_code text, p_token text)
returns void
language plpgsql
security definer
set search_path = public
as $
declare
  v_booking_id uuid;
begin
  -- Live behaviour confirmed 7 Oct 2026: an unknown code raises
  -- "No booking found for that reference code" (HTTP 400) rather than
  -- silently doing nothing.
  select id into v_booking_id from public.bookings where reference_code = upper(trim(p_reference_code));
  if v_booking_id is null then
    raise exception 'No booking found for that reference code';
  end if;
  insert into public.booking_push_tokens (booking_id, fcm_token)
  values (v_booking_id, p_token)
  on conflict (booking_id, fcm_token) do nothing;
end;
$;
revoke all on function public.register_push_token(text, text) from public;
grant execute on function public.register_push_token(text, text) to anon, authenticated;

-- 6. Not SQL: a Database Webhook (Dashboard -> Database -> Webhooks) on
--    bookings UPDATE calls the send-phase-notification edge function with
--    `Authorization: Bearer <WEBHOOK_SECRET>`. Edge function secrets:
--    SUPABASE_SERVICE_ROLE_KEY, FIREBASE_PROJECT_ID,
--    FIREBASE_SERVICE_ACCOUNT_B64, WEBHOOK_SECRET.
