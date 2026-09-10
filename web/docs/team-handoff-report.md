# Spanner web app - team handoff report

Written for the whole group, not just whoever touches the web app - enough
to follow code discussions, suggest changes, or explain any part of this in
the presentation/defence. Assumes no prior ASP.NET or Supabase experience.

## 1. What this is, in one paragraph

The `web/` folder is a small ASP.NET Core website for front-desk/admin staff
at Riese Auto-Clinic. It talks to the same Supabase database the Flutter
mobile app (`mobile/`) uses. Staff log in, book vehicles in, add jobs and
parts to a booking, record labour, and download an invoice PDF - all backed
by real data in the shared Supabase project, not mock/local data.

## 2. The stack, and why

| Piece | What | Why this, not the obvious alternative |
|---|---|---|
| ASP.NET Core 10, **Razor Pages** | The web framework | Not MVC or Blazor - Razor Pages keeps one screen = one file pair (`Foo.cshtml` + `Foo.cshtml.cs`), which fits an app this size (a handful of screens) without extra layers. |
| **Supabase C# client** (NuGet `Supabase`) | Talks to the database | Not Entity Framework/raw SQL - it's the same REST-over-Postgres model the Flutter app already uses, so both apps go through the same Auth and Row Level Security rules instead of two different data-access systems. |
| **QuestPDF** | Generates invoice PDFs | Free "Community" license for student projects - see `questpdf.com/license`. |
| **Bootstrap 5** | Page styling | Already bundled by the ASP.NET project template; no reason to add anything else for a handful of simple forms/tables. |

## 3. How a page actually works (read this once, it explains every screen)

Every screen is a **Razor Page**: two files with the same name.

- `Foo.cshtml` - the HTML template (what the browser renders). Uses Razor
  syntax (`@Model.SomeProperty`, `@foreach`, etc.) to mix C# into HTML.
- `Foo.cshtml.cs` - the "code-behind". A C# class with methods like
  `OnGetAsync()` (runs when the page loads) and `OnPostAsync()` /
  `OnPostSomeNameAsync()` (runs when a form on that page is submitted -
  `asp-page-handler="SomeName"` in the HTML picks which one).

Example: `Pages/Bookings/Details.cshtml.cs` has `OnGetAsync` (loads the
booking), `OnPostAddJobAsync` (the "Add job" form), and `OnPostAddPartAsync`
(the "Add part" form) - all on the same page, because HTML has three
different `<form>` tags pointing at three different handlers.

Every query to Supabase looks like:
```csharp
var booking = await supabase.From<Booking>()
    .Filter("id", Constants.Operator.Equals, id.ToString())
    .Single();
```
`Booking` here is a C# class in `Models/` whose properties are mapped to
real database columns via `[Column("...")]` attributes (see section 5).

## 4. Where things live (file map)

```
web/
  Program.cs                  - app startup: registers services, wires auth,
                                 sets the Supabase client up, starts Realtime
  Configuration/
    SupabaseSettings.cs        - just holds the Url/AnonKey read from secrets
  Models/                      - one class per database table (see section 5)
  Auth/
    SupabaseSessionFilter.cs   - runs before every page; loads the logged-in
                                 staff member's Supabase session onto the
                                 per-request client (see section 6)
  Services/
    VehicleImageService.cs     - Wikimedia Commons image lookup (FR-13)
    BookingInvoiceDocument.cs  - builds the invoice PDF layout
    RealtimeChangeNotifier.cs  - background listener for live DB changes
  Pages/
    Account/                   - Login, Logout
    Bookings/                  - Create, Details (jobs+parts+totals), Invoice
    Jobs/                      - Details (labour capture, mark complete)
    Stock/                     - Index (list), Create (add a part)
    Vehicles/                  - Search (history + reference image)
    Realtime/                  - Stream (the live-update connection)
    Index.cshtml                - the dashboard (first page after login)
    Shared/_Layout.cshtml       - the page frame (nav bar, footer) every
                                 page renders inside
  docs/
    team-handoff-report.md      - this file
    demo-script.md              - the presentation walkthrough
```

## 5. The real database schema (important - read this before changing anything)

The build plan's original proposed schema (a `jobs` table, a `customers`
table, a `parts` table, etc.) **does not match what's actually live in
Supabase**. Nobody had seen the real schema when that plan was written. The
actual tables, confirmed directly against the live project:

| Table | Columns | Notes |
|---|---|---|
| `bookings` | id, brand, model, year, engine_size, transmission_type, registration, kilometers, engine_code, image_url, status, created_at, closed_at | One row per vehicle visit. No separate `vehicles` or `customers` table - no customer name/phone/email is stored anywhere. `status` starts as `"checked_in"`. |
| `jobs` | id, booking_id, job_type, status, labour_hours, labour_rate, created_at, completed_at | **Added by us mid-project** (see `supabase/migrations/0001_create_jobs_table.sql`) - didn't exist originally. `status` is `"pending"` then `"completed"`. |
| `stock_items` | id, sku, name, category_id, supplier_id, cost_price, sell_price, quantity_on_hand, reorder_level, created_at | The parts catalogue. |
| `categories` | id, name, created_at | Part categories (Brakes, Suspension, etc.) |
| `suppliers` | id, name, contact_info, created_at | |
| `booking_parts` | id, booking_id, stock_item_id, quantity, unit_price, created_at | Links a part to a **booking**, not to a specific job - see the "parts aren't per-job" note below. |
| `stock_movements` | id, item_id, type ("in"/"out"), quantity, cost_at_time, reference, user_id, timestamp | An audit ledger mobile already writes to when stock changes; the web app writes to it the same way. |

**Important gap**: `booking_parts` has no `job_id` column. A booking can
have several jobs and several parts, but there's no way to say "this part
belongs to that specific job" - only "this part was used on this booking".
That's why invoice/cost totals in this app are **per-booking, not per-job**.
If the team wants true per-job costing, that needs a schema change (adding
`job_id` to `booking_parts`) - it's a real decision to make as a group, not
something to just build around silently.

## 6. How login and permissions work

Staff log in with email/password through **Supabase Auth** (the same
account system mobile will eventually use, though it doesn't yet - see
section 8). On success, the app stores that session in a browser cookie.
On every later request, `Auth/SupabaseSessionFilter.cs` reads that cookie
and re-attaches the session to that request's database client, so every
query runs "as" that staff member and respects Row Level Security (RLS) -
the same permission rules the database itself enforces, not just something
the app promises to check.

Every page requires login except the login page itself (`Program.cs`:
`options.Conventions.AuthorizeFolder("/")` + one exception for
`/Account/Login`).

## 7. Running it locally

```bash
cd web
dotnet restore
dotnet user-secrets set "Supabase:Url" "https://hzreemeqeixpxdftlnyo.supabase.co"
dotnet user-secrets set "Supabase:AnonKey" "<ask for the anon/publishable key>"
dotnet run
```
Never put real credentials in a file that gets committed - `user-secrets`
keeps them local to your machine only. Never use the `service_role` key
here at all (client apps should only ever hold the anon/publishable key).

## 8. What's still open / needs the group's attention

1. **Two Supabase migrations pending review** in `supabase/migrations/`:
   - `0001_create_jobs_table.sql` - already applied live (thanks Gary).
   - `0002_enable_realtime.sql` - **not yet applied**. Without it, live
     updates (section 9) silently do nothing; everything else works fine.
2. **Mobile has no real login yet.** `mobile/lib`'s "role select" screen is
   a local, unauthenticated toggle, not tied to Supabase Auth. Anyone with
   the app can currently do anything. This web app's login is the first
   real access-control in the project.
3. **Mobile's data models are behind the live schema** - e.g. its booking
   model doesn't read/write `status` or `created_at` even though both exist
   in the database. See the companion doc in `mobile/docs/` for specifics.
4. **Nine feature branches, no merges yet** (`feature/web-m0-setup` through
   `feature/web-m8-testing-demo`). Each milestone's own PR is open on
   GitHub. These need review and merging into `main` - the longer that
   waits, the more chance of the live database drifting out from under
   whichever branch gets merged last.
5. **Cross-browser testing is incomplete** - only tested in Chromium so
   far. Someone should open the app in Firefox before the presentation.
6. **The current demo data has drifted** from a clean state (extra test
   parts/jobs added during manual testing). Before presenting, either walk
   through `docs/demo-script.md` fresh, or reset the Volkswagen Polo
   booking's jobs/parts to match the script.

## 9. Live updates (Realtime) - how it works, once enabled

`Services/RealtimeChangeNotifier.cs` opens one long-lived connection to
Supabase and listens for any change to `bookings` or `stock_items`. When
something changes, it tells every open browser tab (via a technique called
Server-Sent Events - a one-way live connection from server to browser), and
the dashboard automatically reloads. This only works for the **web app's**
side - mobile doesn't listen for live changes yet, so "make a change on
mobile and watch it appear on web" isn't something either app fully does
today. That's flagged, not silently glossed over.

## 10. Common gotcha the whole team should know about

If you add a new database-backed model class and give it a `CreatedAt`
property mapped to a `created_at` column that has a database default, you
**must** mark it like this:
```csharp
[Column("created_at", ignoreOnInsert: true)]
public DateTime CreatedAt { get; set; }
```
Without `ignoreOnInsert: true`, C#'s default value for an unset `DateTime`
(the year 0001) gets sent to the database on insert and silently overwrites
the database's own `default now()`. This bit `Booking`, `Job`, and
`StockItem` before being caught - each time, only by actually creating a
record through the browser and checking the result, not by the code
compiling successfully. If you add a similar model, copy this pattern.
