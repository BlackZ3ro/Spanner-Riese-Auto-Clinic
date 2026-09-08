# Spanner - web app (ASP.NET)

Spanner is a workshop booking, stock and invoicing system for Riese Auto-Clinic,
a real single-location auto workshop. This folder is the ASP.NET web app - the
front-desk/admin-facing counterpart to the Flutter mobile app already built in
/mobile, sharing one Supabase backend (PostgreSQL + Auth + Realtime + Storage).

Stack:
- ASP.NET Core 10 (LTS), Razor Pages
- Supabase C# client (NuGet package "Supabase") for database access, auth and
  realtime - not Entity Framework/Npgsql, so data access works the same way
  and respects the same Row Level Security policies as the mobile app
- QuestPDF for invoice PDF generation (free under its Community license for
  student/educational use - keep it that way, don't add paid tiers)

Ground rules:
- Direct users are shop staff (mechanics, front-desk/admin), not customers.
  There is no customer-facing login or portal - see the SRS, Out of Scope.
- Keep the interface simple (NFR-01) - this is for people with limited
  software experience, not a technical audience.
- All data access goes through Supabase Auth + Row Level Security. Never
  hardcode a service-role key into a page or check it into git.
- Reuse the field names and validation Gary already used in the mobile app's
  Supabase queries wherever the two overlap - don't invent parallel logic
  for the same data. Check /mobile first.
- Keep code readable and commented where the logic isn't obvious - every
  group member may be asked to explain any part of this project.
- The SRS (docs/) is the source of truth for requirements (FR-01 to FR-13,
  NFR-01 to NFR-07). If a prompt conflicts with the SRS, the SRS wins - flag
  the conflict instead of guessing.

## Status as of M1

- `/mobile/lib` landed (Gary pushed it straight to `main` mid-M1). It
  confirms the real schema below field-for-field (`vehicle_booking.dart`,
  `stock_item.dart`, etc. match exactly). But **mobile has no real
  authentication at all** - `main.dart` goes straight to `HomeScreen()`,
  and `features/auth/` is just a local, unauthenticated
  `StateProvider<UserRole?>` (admin/mechanic) that isn't backed by Supabase
  Auth or persisted anywhere; there are zero `Auth.signIn*`/`signUp*` calls
  in `/mobile/lib`. So "check /mobile's auth setup so staff use identical
  credentials" (per the original build plan) doesn't apply yet - this web
  app's Supabase Auth login is the first real FR-12 implementation in this
  project. Worth a heads-up to the team: mobile still has no access control.
- Mobile's `VehicleBooking` model is also behind the live DB schema - its
  `status` field is commented out entirely (`booking_status.dart` is a
  fully commented-out stub) and so is `createdAt`, even though both columns
  exist in Supabase. Don't assume mobile is reading/writing everything the
  DB has.
- `/supabase/migrations`, `/supabase/seed` are still empty stubs - the real
  schema was built directly in the Supabase dashboard, not via migrations
  committed to this repo.
- Supabase `Url`/`AnonKey` **are** configured (as local user-secrets, not
  committed) and the live connection is confirmed working.

### Real schema (M0's reconciliation, done directly against the live project)

The proposed schema in the ASP.NET build plan does **not** match what's
actually built in Supabase. The real schema, discovered by probing the
PostgREST API with the anon key (no dashboard/admin access was available):

| Table | Columns |
|---|---|
| `bookings` | id, brand, model, year, engine_size, transmission_type, registration, kilometers, engine_code, image_url, status, created_at, closed_at |
| `stock_items` | id, sku, name, category_id (fk categories), supplier_id (fk suppliers), cost_price, sell_price, quantity_on_hand, reorder_level, created_at |
| `categories` | id, name, created_at |
| `suppliers` | id, name, contact_info, created_at |
| `booking_parts` | exists but empty - columns unconfirmed (probably booking_id/stock_item_id/quantity, but verify before building M3) |

Notably **missing** versus both the plan and the SRS (FR-02, FR-05, FR-07):
no `jobs`, no `customers` (`bookings` has vehicle fields directly on it, no
customer name/contact at all), no `labour`/`invoices` tables. `bookings` has
one `status` column that appears to carry the job-lifecycle concept itself
(only "checked_in" seen in data so far) - there's no separate job entity
with type/assigned_to/labour_hours/labour_rate.

**This means M2 onward needs real schema/migration work, not just app code**
- confirm with Gary (or whoever owns Supabase) how they intend to model
  jobs, labour and invoicing before building against guessed table names.

### M1 (staff login + read-only dashboard)

Built against the real schema above: `Pages/Account/Login.cshtml(.cs)` for
Supabase Auth email/password login (cookie-based ASP.NET session, backed by
a per-request-scoped `Supabase.Client` that restores that user's access
token via `Auth/SupabaseSessionFilter.cs`, so RLS applies per staff member
rather than sharing one session). `Pages/Index.cshtml(.cs)` is the dashboard
- open bookings and stock levels, live from Supabase.

Verified live, end-to-end, in a browser: unauthenticated redirect to
login; wrong credentials rejected cleanly (no crash); successful login
with a confirmed staff account redirects to the dashboard and shows real
bookings/stock data matching Supabase directly; logout redirects back to
login. M1's acceptance criteria are met.

### M2 (bookings and jobs)

`Pages/Bookings/Create` books in a vehicle (FR-01), reusing mobile's exact
fields and validation (brand, model, year, transmission, engine
size/code, registration, kilometers - see `book_in_screen.dart`). New
bookings insert with `status = "checked_in"` explicitly, because
`bookings.status` has a DB check constraint and mobile doesn't set a
default either (its `BookingStatus` enum is commented out).

`Pages/Bookings/Details` shows a booking plus its jobs, and can add a job
type to it (FR-02) - but only once the `jobs` table exists. It doesn't yet:
see `supabase/migrations/0001_create_jobs_table.sql`, a proposed additive
migration (new table + FK to bookings, RLS restricted to `authenticated`)
that needs someone with Supabase dashboard access (Gary) to review and run.
Until then, the Jobs section shows a clean "table not found" message rather
than crashing - verified live.

**Bug found and fixed during testing**: `Booking`/`Job`'s `CreatedAt`
property needed `[Column("created_at", ignoreOnInsert: true)]` - without
it, C#'s default `DateTime` (0001-01-01) gets sent explicitly on insert and
silently overrides Postgres's `created_at default now()`. Caught by
actually creating a booking through the browser and checking the result,
not just by the build succeeding.

Gary ran the jobs migration mid-M3 - `jobs` is now live, and job assignment
(FR-02) is fully working and verified end-to-end (previously only degraded
gracefully).

### M3 (stock and linking parts)

Reused the *real* live tables directly, not the plan's proposed ones:
`Pages/Stock/Index` lists `stock_items` (joined with `categories`/
`suppliers` for display names, low-stock rows highlighted - FR-10) and
`Pages/Stock/Create` adds one (FR-03), matching `stock_item_repository.dart`
field-for-field.

Parts-to-booking linking (FR-04) uses the `booking_parts` table that
already existed live (booking_id, stock_item_id, quantity, unit_price) -
no schema change needed, unlike jobs. Adding a part on
`Pages/Bookings/Details`: inserts a `booking_parts` row (unit_price
snapshotted from the stock item's current sell_price), decrements
`stock_items.quantity_on_hand`, and inserts a `stock_movements` "out" row
(reusing mobile's exact movement-ledger pattern from
`stock_movement_repository.dart` - cost_at_time, reference set to the
booking's registration, user_id from the logged-in staff member's Supabase
id) for the same audit trail mobile already writes to. Blocks against
over-allocating (checks quantity_on_hand before inserting).

Also fixed while building this: `StockItem.CreatedAt` had the same
ignoreOnInsert bug as Booking/Job. And set the app's default culture to
en-ZA in Program.cs so `ToString("C")` renders Rand, not the server OS's
default currency.

Verified live end-to-end: added a job, added a part (stock correctly
dropped 9→7, stock_movements row correct with the real staff user_id and
booking registration as reference), added a new stock item via the Stock
page (category/supplier dropdowns populated from real data). All test data
cleaned up afterward.
