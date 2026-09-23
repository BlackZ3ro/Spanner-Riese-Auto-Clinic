# Change Log

## 2026-09-23 — Diagram review against the real code, final permissions

- Reviewed Ofentse & Breyton's `SpannerUML.pdf` and `Spanner System Sequence
  Diagram V2.pdf` against the web code and the mobile code on `origin/main`.
  Findings and fixes in `diagram-review-2026-09-23.md`; corrected reference
  diagrams in `diagrams/`.
- **Use case diagram redrawn**: Admin left / Mechanic right, shared ovals connect
  to both, admin-only ovals only to Admin, Dashboard is one separate include from
  Login, Login includes "Validate with Supabase Auth", Customer unchanged.
- **Sequence diagrams**: Login first, then working with the system; `Alt` not
  `Loop`; Flutter diagram is now "book in a vehicle" (mobile writes
  `booking_labor`, not `jobs`); no "Check IsAdmin" call to Supabase (web checks the
  `AdminEmails` allowlist in-app); web book-in and Reopen diagrams added; mobile
  book-in validated through Supabase.
- **Permissions agreed** (Wisani, 23 Sept): only Admin can finalize, delete, reopen
  a closed booking and remove jobs; both roles can restock parts and do the rest.
  This changes the earlier "Reopen is shared" finding (20 Sept). New tasks: U3-22
  mobile Supabase login, U3-23 apply the permissions in code. Zealots Tracker
  updated.

## 2026-09-22 — Ms Mbele consultation (Lab 226)

- **Use case diagram restructured** per direct feedback: fewer, more
  concise base use cases (`Manage Bookings`, `Manage Stock`) each fanning
  out to `«extend»` points instead of one oval per action; `View
  dashboard` folded into `Login` as an extension instead of standing
  alone; `Filter open/closed jobs` added (wasn't modelled before); the
  Admin-only extension points now label the authentication requirement
  directly. Full before/after mapping of each consultation note to what
  changed is in `uml-and-erd.md`, "Consultation outcomes."
- **New requirement confirmed:** a customer-facing repair-status lookup —
  enter a reference code, see the vehicle's phase, no login. Deliberately
  narrower than the real-time tracking excluded from scope in Phase 1 (see
  SRS Requirements Change Log) — a single lookup, not push updates or an
  account. New `Customer` actor added to the use case diagram; new
  unauthenticated route flagged in `system-architecture.md`. **Not yet
  assigned an owner** — the group's own target is end of day 23 Sept.
  Open implementation question: what the reference code actually is
  (reuse `invoice_number` vs. a new dedicated column) — needs Gary.
- `consultation-prep-2026-09-22.md` updated with the actual meeting notes
  in place of the pre-meeting question list.

## 2026-09-20 (later still)

- Everything now lives in one artifact:
  [Spanner Design Backups](https://claude.ai/artifact/4j8EwFJ9KL3tC9GujFSBov)
  — architecture, use case (corrected), sequence diagrams, web wireframes
  (mockup + real screenshots), a new mobile wireframe mockup mirroring
  Gary's real flow, Gary's real Flutter screenshots embedded directly, and
  a full Status & Checklist dashboard (every Phase 2 task, grouped by
  activity, with owner/status/notes and a "behind the scenes" section
  covering the roster fix, the UML pairing, the load rebalance and the
  Reopen finding).
- Gary's Individual Contributions entry updated to note the mobile
  wireframe backup exists alongside his real work — his Obsidian Canvas
  flow is still the deliverable that counts for Activity 3.3.

## 2026-09-20 (later)

- **ASP.NET wireframes checked off** at Wisani's explicit instruction —
  real screenshots (login, admin/mechanic dashboards, booking details,
  stock, add a part, book in a vehicle, closed bookings, a real invoice
  PDF) plus the earlier wireframe flow, both in
  [Spanner Design Backups](https://claude.ai/artifact/4j8EwFJ9KL3tC9GujFSBov).
  Produced by Wisani, not Kea (the assigned owner) — flagged in
  `progress-tracker.md` in case individual-contribution evidence matters.
- **Use case diagram corrected against the live app**: `Reopen booking`
  is not actually admin-gated in the code (`OnPostReopenAsync` never
  checks `IsAdmin` — confirmed live with a mechanic login) and `View
  closed bookings` is on the shared nav for both roles. Both moved from
  the admin-only cluster to shared Mechanic use cases in
  `uml-and-erd.md` and the backups artifact. Only Finalize & close and
  Delete booking are genuinely admin-gated. Worth a team decision on
  whether Reopen should be locked down too, for consistency.
- Architecture diagram reviewed against the live app and the real
  screenshots — no structural change needed.

Dated log of real changes/decisions — web app, Supabase, and Phase 2 docs.
Kept here so there's one place showing what actually happened and why,
separate from the Progress Tracker's task/owner view.

## 2026-09-20

**Shared Phase 2 tracker**
- Published [Zealots Tracker](https://claude.ai/artifact/3TeRkof9dpEMUGjAiz2iDo) —
  a live, shared task board + updates feed for the group, seeded with the
  real 20-task Phase 2 checklist. Two separate design-plan documents
  written alongside it: `tracker/team-guide.md` (for the group) and
  `tracker/build-spec.md` (internal, for maintaining the artifact's code).
- Built [Spanner Design Backups](https://claude.ai/artifact/4j8EwFJ9KL3tC9GujFSBov) —
  worked examples of the architecture diagram and the UML diagrams (use
  case + both sequence diagrams), initially kept private as a personal
  safety net. **Later shared with the group as reference examples** — not
  the submission; Ofentse, Breyton and Gary still produce and share-link
  their own versions.

**Load check and rebalance**
- Wisani was the owner on ~10 active Phase 2 items plus reviewer on most
  others — the same solo-overload pattern as her Phase 1 SRS/tracker/
  reflection load. Moved the ERD redraw to Gary (merged with his existing
  sanity-check task), the navigation flow diagram to Kea (pairs with her
  ASP.NET wireframes), and the design-alignment table to Denny (matches
  his Phase 1 content-support role); dropped her as co-owner of the
  stakeholder reconfirmation (Denny now sole owner, she stays informed).
  She keeps the SRS merge and tracker top-up. Logged as a real Challenges
  & Actions entry in the official tracker, not just noted here.

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
