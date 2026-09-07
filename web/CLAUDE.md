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

- `/mobile/lib` and `/supabase/migrations`, `/supabase/seed` are still empty
  stubs in this repo (placeholder `.gitkeep` files only) - there is no
  mobile app code or committed migrations to check, despite earlier planning
  documents assuming the mobile app was further along. Re-check this note
  before M2/M6 (which assume `/mobile` exists) and update it once mobile
  work lands.
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

Verified live: unauthenticated redirect to login works; wrong credentials
are rejected cleanly (no crash). A successful login + full dashboard load
has not yet been verified end-to-end - no confirmed staff account existed
in Auth to test with, and this project's built-in email sender is rate
limited. See git log for how that was resolved.
