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

### M4 (labour capture and cost calculation)

`Pages/Jobs/Details` (FR-05): record labour hours + hourly rate on a job,
"Save hours" (no status change) or "Mark job complete" (sets
status='completed', completed_at=now). Labour cost = hours × rate, shown
immediately once both are entered - doesn't require completion first, so
staff can see the running number before finalizing.

FR-06 says "job cost = parts + labour", but **parts aren't scoped to
individual jobs in this schema** - `booking_parts` has no `job_id`, only
`booking_id` (confirmed in M3). So there's no such thing as "this job's
parts" to sum. Instead: `Pages/Bookings/Details` shows a booking-wide total
= sum of every part used on the booking + labour for every job on it that
has both hours and rate recorded (regardless of completion status - see
`DetailsModel.PartsTotal`/`LabourTotal`/`GrandTotal`). This is a deliberate
scope call given the real schema, not an oversight - flag it if the team
wants per-job parts tracking instead (would need a `job_id` column added to
`booking_parts`, another schema change to coordinate).

Verified live end-to-end, checked by hand: labour 2.5h × R450/h = R1,125.00
on the job page; adding a R4,500.00 part brought the booking total to
R5,625.00 (R4,500 + R1,125), both matching manual calculation exactly. Test
data cleaned up afterward.

### M5 (invoice PDF)

`Services/BookingInvoiceDocument` (QuestPDF, Community license - set via
`QuestPDF.Settings.License` in Program.cs, confirm this project still
qualifies at questpdf.com/license before relying on it long-term) renders
the same booking-wide total from M4 as a PDF: labour lines per job, parts
lines, parts/labour/grand totals. `Pages/Bookings/Invoice` (FR-08: a plain
authenticated download link, no native share sheet needed for a web app)
generates it on request and returns it as a file download - nothing is
persisted, since no `invoices` table exists in this schema either.

Verified live: valid PDF (`%PDF-1.4` header), correct
`content-type`/`content-disposition`, generated without error from real
booking/job/part data. Also confirmed the download route is protected by
auth like every other page (an unauthenticated request gets redirected to
login, not a PDF). Test data cleaned up afterward.

### M6 (vehicle history search + reference image)

No VIN column exists anywhere in this schema (see the real-schema section
above), so FR-11's "search by VIN or licence plate" searches
`bookings.registration` instead (`ILike`, partial match) - the closest
thing this schema has to a persistent vehicle identity across repeat
visits, since there's no separate `vehicles` table either. `Pages/Vehicles/
Search` shows every matching booking with its job history.

`Services/VehicleImageService` (FR-13) is a direct C# port of mobile's
`vehicle_image_service.dart` - same Wikimedia Commons search endpoint,
same query shape, same retry-without-trailing-year fallback. One reference
image is shown per search (from the most recent matching booking's brand/
model/year), falling back to plain text when there's no match - never
treated as an error, per the SRS/risk R-13 framing.

**Bug found and fixed during testing, not just by building**: every
Wikimedia lookup was silently returning "no image" - .NET's `HttpClient`
sends no `User-Agent` header by default, and Wikimedia's API returns 403
("please set a user-agent") without one. The try/catch around the search
was swallowing that 403 and looking exactly like an expected "no match".
Fixed by setting a descriptive User-Agent on the typed `HttpClient` in
Program.cs. Confirmed the fix against a real request (a correctly-spelled
"Toyota Corolla 2008" now returns a real Commons image url) - testing
against curl directly (which sends its own default User-Agent) is what
surfaced this; it would never have shown up from the build succeeding or
from a quick glance at the fallback UI, since the fallback renders
identically whether Wikimedia genuinely has no match or the request never
actually reached it.

Verified live: registration search across two bookings sharing the same
plate correctly returns both, each with its own job history; a
correctly-spelled query finds and displays a real Wikimedia image; a
misspelled one ("Corrola") still found a reasonable fuzzy match (expected -
FR-13 doesn't require authoritative accuracy). Test bookings cleaned up
afterward.

### M7 (Realtime sync check, NFR polish)

**Mobile has no Realtime subscriptions at all** (`grep -rl "realtime\|
channel\|stream(" mobile/lib` - zero matches). It's one-shot fetches only,
same as its missing auth (see M1's note). So FR-09 as literally scoped -
"confirm a change appears on the mobile app without a manual refresh, and
vice versa" - **cannot be verified**, because only one side could possibly
implement it right now. What I could and did build: `Services/
RealtimeChangeNotifier` (a singleton `IHostedService` holding one long-lived
Supabase Realtime subscription - separate from the per-request scoped
client used everywhere else, since Realtime needs a persistent connection)
fans out `bookings`/`stock_items` changes to every open browser tab via
Server-Sent Events (`Pages/Realtime/Stream`), and the dashboard
live-reloads on any such event. That's the web half of FR-09, real and
working. The mobile half is Gary's to build whenever he's ready
(`.stream()` subscriptions in the repositories) - flagged to the team, not
something I built into `/mobile` myself, since it's outside this app's
folder and outside what was asked.

**Second schema-adjacent gap found by testing, not by reading the plan**:
subscribing failed outright with an explicit Supabase error - "Please
check Realtime is enabled for the given connect parameters" - because
Realtime isn't enabled for these tables in this project's publication yet.
Not a code bug (confirmed by first ruling out my own channel-topic mistake,
which gave a different, clearly client-side "unmatched topic" error before
the fix). Wrote `supabase/migrations/0002_enable_realtime.sql` for Gary,
same pattern as the jobs table. Until it's applied, the dashboard works
exactly as before, just without live-reload - `RealtimeChangeNotifier`
catches the subscribe failure and logs a warning instead of crashing
startup.

**Bug found while testing NFR-03, fixed same pass**: M0's startup
"[Supabase] Connected successfully" log was actually meaningless -
`InitializeAsync()` only sets up local client state and succeeds even
against a nonexistent host. Caught by deliberately pointing the app at a
bad URL to test connection-loss handling, and noticing the log still
claimed success. Fixed by adding a real lightweight query
(`From<Booking>().Limit(1).Get()`) after `InitializeAsync()` before
declaring success.

**NFR-02** (core actions complete within a few seconds): measured, not
assumed - login page ~0.35s, vehicle history search (the slowest page -
does N+1 job queries per matching booking, plus an external Wikimedia
call) ~2.0s, invoice PDF generation ~1.7s. All well within "a few
seconds". The N+1 pattern on vehicle search is a real thing to revisit if
search results ever get large, not urgent at this data volume.

**NFR-03** (behaves reasonably when Supabase is briefly unreachable):
actually tested by pointing the app at a nonexistent Supabase host, not
just inspected in code - dashboard shows "Couldn't load live data from
Supabase: No such host is known" and still renders (empty-state tables,
no crash, no 500); login shows the same style of clean error instead of
throwing. Both already worked because of the try/catch pattern used
consistently since M0 - this pass proved it holds under a real failure,
not just in theory.

**NFR-06** (basic cross-browser check): only Chromium-based browsers were
available in this environment (the sandboxed Browser pane; no Firefox/
Safari/WebKit). Everything used - Bootstrap 5, `fetch`, `EventSource`,
standard form posts - is broadly supported across evergreen browsers, so
risk is low, but this is a real gap: someone on the team should open the
app in Firefox (and ideally Safari) before the M8 demo. Don't report this
as "done" without actually doing it.

### M8 (testing, bug fixes, demo prep)

Also fixed two build warnings found while running the app for this pass
(`dotnet build` had been checked for errors throughout M0-M7, but warnings
weren't being read closely): `RealtimeChangeNotifier`'s subscription used
an obsolete Supabase Realtime API. Tried migrating to the non-obsolete
`OnPostgresChange()` - it silently built the wrong subscription topic
(confirmed against the real server: "unmatched topic"), so reverted to the
obsolete-but-actually-correct `Register()`/`AddPostgresChangeHandler()`
pair with a `#pragma warning disable CS0618` and a comment explaining why.
Also fixed a real nullable-reference warning on `Invoice.cshtml.cs`
(`booking.Registration` is nullable; the invoice filename now falls back
to the booking id). Build is 0 warnings, 0 errors.

Full walkthrough done as a first-time staff member, start to end, no dead
ends found: logged out and back in, booked in a real vehicle (Volkswagen
Polo, `CY 45 KL GP`), added a job, linked a part (stock correctly dropped
9→8), entered labour and marked the job complete (1.5h × R480 = R720,
verified by hand), confirmed the booking total (R4,500 + R720 = R5,220),
downloaded the invoice PDF, found the booking via vehicle history search
(with a Wikimedia reference image), and confirmed the stock page and
dashboard both reflect the change. **This booking was deliberately kept**,
not cleaned up like every other milestone's test data - it's now the demo
dataset. See `web/docs/demo-script.md`.

No mobile demo script or sample-data convention existed to align with
(checked `/mobile` and `/project-docs` directly) - the demo script notes
this so whoever eventually scripts mobile's side points at the same
Volkswagen Polo booking instead of inventing separate data.

### Correction: "test data cleaned up" was wrong for `jobs`, M2 onward

Every "test job cleaned up afterward" claim above (M2, M3, M4, M5) is
**false for the `jobs` table specifically**. `0001_create_jobs_table.sql`
granted `authenticated` staff SELECT/INSERT/UPDATE but never DELETE. With
RLS enabled and no matching policy, every `DELETE` against `jobs` since M2
has silently affected zero rows - PostgREST returns 204 either way, so
this went unnoticed through several rounds of manual cleanup that looked
successful but weren't. Confirmed directly during M8 demo-data reset: a
delete returns 204, the row is still there on the very next authenticated
read. (Reads and deletes on `bookings`, `stock_items`, `booking_parts` and
`stock_movements` were never affected - only `jobs` was missing the
policy.) Fixed in `supabase/migrations/0003_add_jobs_delete_policy.sql` -
another one for Gary to run. Until it's applied, test/junk rows accumulate
in `jobs` and can't be removed by the app or by curl, only from the
Supabase dashboard directly (which uses `service_role`, bypassing RLS).
