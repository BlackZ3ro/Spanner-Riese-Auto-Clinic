# Web Application (ASP.NET)

This folder contains the ASP.NET web application for Spanner - the front-desk/
admin-facing counterpart to the Flutter mobile app in `/mobile`, sharing one
Supabase backend.

## Owner
Gary (see repo `CONTRIBUTORS.md`) - other group members are welcome to help,
per the ASP.NET build plan's M0-M8 milestone sequence.

## Stack
ASP.NET Core 10 (LTS), Razor Pages, the `Supabase` NuGet package for data
access/auth/realtime. See `CLAUDE.md` for the full context and ground rules.

## Setup

1. Install the [.NET 10 SDK](https://dotnet.microsoft.com/download).
2. Restore packages:
   ```bash
   cd web
   dotnet restore
   ```
3. Configure Supabase credentials with user secrets (never commit these,
   never use the `service_role` key here - anon/public key only):
   ```bash
   dotnet user-secrets set "Supabase:Url" "https://<project-ref>.supabase.co"
   dotnet user-secrets set "Supabase:AnonKey" "<anon-public-key>"
   ```
4. Run the application:
   ```bash
   dotnet run
   ```
   On startup, the console prints whether the Supabase connection succeeded.
   Without credentials configured, it still starts (read-only pages that need
   Supabase just won't have data yet).

## Status

- M0 (project setup, Supabase client wiring): done. Live connection confirmed.
- M1 (staff login + read-only dashboard): done. Verified end-to-end in a
  browser against the real Supabase project - login, dashboard with live
  bookings/stock data, and logout all work. See `CLAUDE.md` for the real
  schema (it differs from the original plan) and a note that mobile has no
  real authentication yet.
- M2 (bookings and jobs): done. Booking creation and job assignment both
  verified end-to-end (Gary ran the jobs migration mid-M3).
- M3 (stock and linking parts): done. Add/view stock, and link parts to a
  booking (reduces stock, writes a stock_movements audit row matching
  mobile's pattern) - all verified live, test data cleaned up.
- M4 (labour and cost calculation): done. Record labour hours/rate per job,
  mark complete, automatic cost math verified by hand (2.5h @ R450 = R1,125;
  + a R4,500 part = R5,625 booking total). Note: the total is booking-wide,
  not per-job - see CLAUDE.md for why (booking_parts has no job_id).
- M5 (invoice PDF): done. "Download invoice (PDF)" on a booking's page
  generates a QuestPDF invoice (Community license) with the same
  parts/labour/total breakdown as M4 - verified live, a real PDF downloads
  correctly and the route is auth-protected like every other page.
- M6 (vehicle history + reference image): done. Search by registration
  (no VIN column exists - see CLAUDE.md) shows every matching booking with
  its job history. Vehicle reference image is a direct port of mobile's
  Wikimedia lookup - fixed a real bug found by testing (not just building):
  .NET's HttpClient sends no User-Agent by default, so Wikimedia was
  returning 403 on every request, silently swallowed and indistinguishable
  from a genuine "no match" until checked against curl directly.
