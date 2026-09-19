# Change Log

Dated log of real changes/decisions — web app, Supabase, and Phase 2 docs.
Kept here so there's one place showing what actually happened and why,
separate from the Progress Tracker's task/owner view.

## 2026-09-19

**Phase 2 design docs**
- Created `project-docs/phase-2/` — system architecture diagram, use case
  diagram, 2 sequence diagrams, ERD, all drafted directly from the live
  Supabase schema and real app behaviour rather than designed from scratch
  (web dev was already ahead of the design docs going into Unit 3).
- Added Ofentse Rammutla and Breyton Rossouw to `CONTRIBUTORS.md` with
  their student numbers.
- Assigned Phase 2 tasks to the new members so their GitHub activity shows
  real individual contribution.
- **Revised same day**: moved the use case + sequence diagrams from a
  one-each split to a paired task for Ofentse and Breyton, since we don't
  yet know either of their skill levels and Breyton had already offered to
  take it on solo. ASP.NET wireframes and navigation-flow tasks reassigned
  off Breyton to Kea and Khumo.
- **Revised again**: roster corrected against the group's actual official
  Phase 1 submission (`Group Y - ITC327W Progress Checker.xlsx`, from
  `Group Y Phase 1_2.zip`). Two names in earlier drafts of these docs were
  wrong — "Kia" and "Kumo" were phonetic mis-transcriptions of
  **Keamogetse Ogone Kgosi (Kea)** and **Moremi KE (Khumo)** — and
  **Mathye MD (Denny)** was missing entirely. Denny is now assigned the
  stakeholder-reconfirmation task, which matches the group's own stated
  top priority for Phase 2 from the Phase 1 Group Reflection. The official
  Progress Checker workbook was continued (not replaced) as
  `Group Y - ITC327W Progress Checker (Phase 2 update).xlsx`, same sheet
  structure as the submitted original, Phase 1 rows preserved verbatim.

**Web app — admin/mechanic access control (post-M8)**
- Added a config-based admin/mechanic distinction (`web/Auth/AdminAccess.cs`,
  an email allowlist in `appsettings.json`) — no new database table, kept
  deliberately simple after two consecutive live-discovered migration bugs
  this week made a bigger schema change too risky to rush.
- **Finalize & close** a booking: now admin-only, enforced both by hiding
  the button and by rejecting a direct POST server-side.
- **Delete booking** (new): admin-only, asks "are you sure" first, restocks
  every part used, removes all labour/jobs, then removes the booking — one
  atomic Postgres function call (`delete_booking_and_restock`,
  `supabase/migrations/0005_delete_booking_with_restock.sql`) so a partial
  failure can't leave stock restocked with the booking still there.
- **Reopen a closed booking**: re-verifies the logged-in staff member's own
  password before undoing a finalize (mobile has no reopen concept at all —
  this is web-only, deliberately).

**Supabase migrations**
- `0004_atomic_stock_decrement.sql` (rewritten as `add_booking_part`): two
  real bugs found via live testing against the actual database, not just
  code review — (1) an ambiguous column reference caused by the function's
  `RETURNS TABLE` column colliding with a bare column name inside it, and
  (2) a parameter declared `text` that should have been `uuid` to match the
  real `stock_movements.user_id` column. Both required re-sending the fixed
  SQL to Gary to re-run, since he's the one with Supabase dashboard access.
- `0005_delete_booking_with_restock.sql` (new): adds the missing `bookings`
  DELETE policy (same bug class found earlier on `jobs` — RLS allowing a
  204 response while silently not deleting anything) plus the atomic
  restock function above. Every column type and permission used in it was
  verified live before writing, not assumed from the C# models — a
  deliberate change in approach after the 0004 bugs, to stop costing the
  team re-run cycles.

**Documentation sent to the group**
- `gary-update.pdf`/`.docx`, `pending-migrations.pdf`/`.docx` — SQL and bug
  summary sent to Gary to apply.
- `group-test-guide.pdf`/`.docx` — admin/mechanic login details and a full
  testing checklist sent to the group (not committed to git — has real
  passwords in it).
- `group-progress-report.pdf` — general progress update.

## Known open items (carried forward, not yet resolved)

- Migrations `0004` and `0005` still need to be confirmed applied and
  re-verified live (Gary applied earlier versions; the final fixed versions
  need a fresh live check).
- Mobile totals invoice labour from `booking_labor`; web still totals from
  `jobs.labour_hours × labour_rate` — two disconnected ledgers on the same
  live bookings, flagged for a team decision, not fixed yet.
- Mobile has no admin/mechanic distinction (web does) and no Realtime
  subscriptions (web does) — both known asymmetries between the two apps.
- A leftover test booking (`DELTEST`) is still in the live database from
  permission testing — needs cleanup once the `bookings` DELETE policy is
  confirmed applied.
