# Phase 2 Progress Tracker (Unit 3 — System Architecture and Design)

Mirror this into the official Progress Tracker / Microsoft Project — this
file is the GitHub-visible copy so individual contribution shows up in
commit history too, not just in an external tool.

**Phase 1 result:** 80% (Planning, Requirements and Feasibility).
**Group as of 2026-09-17:** added Ofentse Rammutla (223056856) and Breyton
Rossouw (222069744) — Kia and Kumo confirmed as existing members (see
CONTRIBUTORS.md).

## Meeting log

| Date | Attendees | Location | What was covered |
|---|---|---|---|
| 2026-09-18 (approx. — confirm exact date) | Wisani, Kia, Kumo, Gary | On campus | Worked through Phase 2 design/dev work together |
| 2026-09-22, 12:00 (upcoming) | All (Group Y's slot) | With Ms Mbele | Phase 2 consultation — see `consultation-prep-2026-09-22.md` |

## Task list

| # | Task | Owner | Status | Started | Target |
|---|---|---|---|---|---|
| 1 | Draft system architecture (grounded in real code) | Wisani | Done | 2026-09-19 | 2026-09-19 |
| 2 | Redraw architecture diagram in a proper tool | Ofentse | Not started | — | 2026-09-21 |
| 3 | Draft use case diagram (actors + use cases) | Wisani | Done | 2026-09-19 | 2026-09-19 |
| 4 | Redraw use case diagram + both sequence diagrams in a proper tool ("the UML diagrams") | **Ofentse and Breyton, paired** | Not started | — | 2026-09-21 |
| 5 | Sequence diagram — Flutter (add a job), draft | Wisani (draft) / Gary (verify) | Draft done, needs mobile sign-off | 2026-09-19 | 2026-09-21 |
| 6 | Sequence diagram — ASP.NET (finalize booking), draft | Wisani | Done | 2026-09-19 | 2026-09-19 |
| 7 | ERD from live schema | Wisani | Done | 2026-09-19 | 2026-09-19 |
| 8 | ERD sanity-check against mobile's actual columns | Gary | Not started | — | 2026-09-21 |
| 9 | Flutter interface wireframes (from real screens) | Gary | Not started | — | 2026-09-23 |
| 10 | ASP.NET interface wireframes (from real screens) | Kia or Kumo (to confirm) | Not started | — | 2026-09-23 |
| 11 | Navigation flow diagram | Kia or Kumo (to confirm) | Not started | — | 2026-09-23 |
| 12 | Consultation with Ms Mbele | All (attend) | Scheduled | — | 2026-09-22 12:00 |
| 13 | Apply consultation feedback, finalize design baseline | All | Not started | — | 2026-09-25 |
| 14 | Update Microsoft Project with Unit 3 tasks | Wisani | Not started | — | 2026-09-20 |
| 15 | Update official Progress Tracker | Wisani | Done (this file) | 2026-09-19 | 2026-09-19 |

*Task 4 was originally two separate one-each tasks (architecture diagram to
Ofentse, use case diagram to Breyton); revised 2026-09-19 to pair Ofentse
and Breyton on the use case + sequence diagrams together, since we don't
yet know either of their individual skill levels — see
`roles-and-assignments.md` revision history. Tasks 10–11 were reassigned
off Breyton for the same reason and need a confirmed owner from Kia/Kumo.*

## Known open items carried over from web build (not Phase 2 blockers, but relevant to design accuracy)

- Migrations `0004` (atomic stock decrement) and `0005` (bookings delete +
  restock) still need to be applied to Supabase by whoever has dashboard
  access — see `web/README.md` "Still pending".
- Mobile vs web have two different labour-total calculations
  (`booking_labor` vs `jobs.labour_hours × labour_rate`) — needs a team
  decision, flagged in `uml-and-erd.md`.
- Mobile has no admin/mechanic distinction yet (web does) — worth deciding
  whether that's in scope before the Phase 2 design is called final.
