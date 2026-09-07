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

## Status as of M0

- `/mobile/lib` and `/supabase/migrations`, `/supabase/seed` are still empty
  stubs in this repo (placeholder `.gitkeep` files only) - there is no
  existing mobile auth pattern or live schema to reconcile against yet,
  despite earlier planning documents assuming the mobile app was further
  along. Re-check this note before M1/M2/M6 (which assume `/mobile` exists)
  and update it once mobile work lands.
- Supabase `Url`/`AnonKey` are not yet configured - see README.md for how to
  set them with `dotnet user-secrets` once they're available. Until then the
  app runs fine but skips the live connection check at startup.
- The proposed schema from the ASP.NET build plan has not been reconciled
  against the real Supabase project (no credentials yet, and no migrations
  committed to check against either). Do this before building M1's dashboard
  queries.
