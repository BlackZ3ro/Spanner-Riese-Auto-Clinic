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
4. Optional, once the site is online: set the public address so the
   **Send on WhatsApp** message can link customers to the tracking page
   (leave it blank while the app only runs on a staff computer - the message
   then tells the customer to use the app's "I'm a customer" screen):
   ```bash
   dotnet user-secrets set "PublicSiteUrl" "https://<your-public-address>"
   ```
5. Run the application:
   ```bash
   dotnet run
   ```
   On startup, the console prints whether the Supabase connection succeeded.
   Without credentials configured, it still starts (read-only pages that need
   Supabase just won't have data yet).

## Run it online (Vercel)

The app runs on Vercel as a container (`Dockerfile.vercel`, Vercel's Container
Runtime). Vercel project: **riese-auto-clinic** (root directory `web`,
framework "Container"). Public address once deployed:
`https://riese-auto-clinic.vercel.app` (check the exact address Vercel gives
after the first deploy and update `PublicSiteUrl` if it differs).

1. In the Vercel project's **Settings > Environment Variables** (Production),
   add `Supabase__Url` and `Supabase__AnonKey` (the same values as the user
   secrets; anon/public key only, never the service-role key).
   `PublicSiteUrl` is already set.
2. Deploy from the repo root on any computer with Node.js:
   ```bash
   npx vercel link --project riese-auto-clinic
   npx vercel deploy --prod
   ```
   Or connect the GitHub repo in the Vercel project (Settings > Git) so every
   push to `main` deploys by itself.
3. Open `/Track` and log in as staff to check.

Notes: the container sleeps after 5 minutes without visitors, so the first
page after a quiet spell takes a few seconds (open it before a demo). After it
wakes up, staff may need to log in again. Tested locally with Docker:
`docker build -f Dockerfile.vercel -t spanner-web .` then
`docker run -p 8080:80 -e Supabase__Url=... -e Supabase__AnonKey=... spanner-web`.

 (new since M8 - quick checklist for anyone testing)

Needs migrations `0004` and `0005` applied first for the "Add part" and
"Delete booking" steps below to fully work (see "Still pending" at the end of
this file) - everything else works without them.

There are now two kinds of login: an **admin** account and a **mechanic**
account (ask whoever's coordinating the group for the current credentials -
not written down here on purpose). Log in as each to see the difference:

1. Log in, click **Book in a vehicle**. Fill in a customer name - if it
   matches (or nearly matches) someone already booked in before, phone/email/
   company auto-fill. Save the booking.
2. On the booking's page, add a job and link a part - stock drops
   automatically. Try leaving the job type blank and submitting: you get
   "Enter a job type." right there, not a silent no-op.
3. As the **mechanic** account: open a booking and confirm there's no
   **Finalize & close** or **Delete booking** button - just the normal
   add-job/add-part forms.
4. As the **admin** account: same booking now shows both buttons. Click
   **Finalize & close** - the booking becomes read-only and drops off the
   dashboard's open list.
5. Go to **Closed bookings** (nav bar) to find it again. Open it and try
   **Reopen** with the wrong password (rejected, stays closed) then the right
   one (booking reopens, editable again).
6. As **admin**, on an open booking with a part linked, click **Delete
   booking** (asks "are you sure" first). Confirms: the part's quantity is
   back on the Stock page, any labour/jobs are gone, and the booking itself
   is gone from the dashboard.
7. Go to **Vehicle history** and search by a customer's name or phone instead
   of the registration plate.
8. Go to **Stock > Add a part** and type a brand-new category or supplier
   name instead of picking one from the dropdown.
9. **Send on WhatsApp** (new 16 Oct 2026, Mr G's feedback): book in a vehicle
   using your own phone number as the customer's. On the booking page, under
   the invoice number, the **Customer reference code** box has a **Send on
   WhatsApp** button. It opens WhatsApp with the code already typed in; tap
   Send and check it arrives. Change the phase (e.g. *Finished - ready for
   pickup*) and the same button now sends that status update; after
   **Finalize & close** it sends a thank-you with the invoice number.

## Status

- M0 (project setup, Supabase client wiring): done. Live connection confirmed.
- M1 (staff login + read-only dashboard): done. Verified end-to-end in a
  browser against the real Supabase project - login, dashboard with live
  bookings/stock data, and logout all work. See `CLAUDE.md` for the real
  schema (it differs from the original plan) and a note that mobile has no
  real authentication yet.
- M2 (bookings and jobs): done. Booking creation and job assignment both
  verified end-to-end (Gary ran the jobs migration mid-M3). **Correction
  (found in M8)**: the jobs table's RLS never had a DELETE policy - every
  "test job cleaned up" note from M2-M5 was wrong, deletes silently did
  nothing. Third migration sent to Gary to fix it - see CLAUDE.md.
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
- M7 (Realtime + NFR polish): the web half is done - the dashboard
  live-reloads on bookings/stock_items changes via Server-Sent Events, but
  it's currently a no-op because Realtime isn't enabled for those tables in
  Supabase yet (new migration sent to Gary). **The mobile half of FR-09
  can't be verified - mobile has zero Realtime subscriptions**, so "sync
  between the two apps" isn't something either app fully does yet. NFR-02
  (speed) and NFR-03 (Supabase down) were actually tested, not just
  reviewed in code, and both pass. NFR-06 (cross-browser): only tested in
  Chromium here - someone needs to check Firefox/Safari before the demo.
- M8 (testing, bug fixes, demo prep): done. Fixed 2 build warnings
  (obsolete Realtime API attempt reverted after it broke subscriptions -
  see CLAUDE.md; a nullable-reference warning on the invoice filename).
  Full first-time-user walkthrough with no dead ends: login through
  invoice download through vehicle search, all verified live. Demo script
  at `docs/demo-script.md`, built around a real booking (Volkswagen Polo,
  `CY 45 KL GP`) that's deliberately left in the database as sample data.

## Milestones M0-M8

All done - see `CLAUDE.md` for the full build log, and `docs/demo-script.md`
for the demo walkthrough. Every milestone landed on its own feature branch
with its own PR; none have been merged to `main` yet as of M8.

## Post-M8: schema reconciliation + new features (Sept 2026)

Mobile's latest build added real customer/invoice-number support directly to
the live schema without a heads-up - reconciled on web's side too, plus a few
features added to close the resulting gaps (customer capture/lookup,
finalize/reopen, multi-column vehicle search, inline category/supplier
creation). Full detail in `CLAUDE.md`'s "Schema drift" section; the checklist
above is the fast way to see it working.

Also added: an **admin** vs **mechanic** distinction (config-based email
allowlist, see `web/Auth/AdminAccess.cs` - no roles table exists in the
schema, so this doesn't touch the database). Only an admin sees **Finalize &
close** or **Delete booking** on a booking's page, and both are rejected
server-side too if posted directly, not just hidden in the UI. Deleting a
booking restocks every part it used, removes its jobs/labour, then removes
the booking - one atomic database call (`0005` migration) so a failure
partway through can't leave stock restocked with the booking still there.

**Still pending** - migrations `0002` (Realtime) and `0003` (jobs DELETE
policy) are applied. `0004` (atomic stock decrement) and `0005` (bookings
DELETE policy + delete-and-restock) still need someone with Supabase
dashboard access to run them. Until then, linking a part or deleting a
booking shows a clean error instead of crashing - that's expected, not a bug.

**Flagged, not fixed - needs a team decision**: mobile's invoice now totals
`parts + booking_labor`; web's still totals `parts + jobs.labour_hours ×
labour_rate`. Two disconnected labour ledgers on the same live bookings - see
CLAUDE.md before this is used for more real invoices.
