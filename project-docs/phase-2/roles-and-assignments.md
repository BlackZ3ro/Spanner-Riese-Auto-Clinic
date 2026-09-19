# Phase 2 Roles and Assignments

**Group Y — ITC327W — Spanner (Riese Auto-Clinic)**
Updated: 2026-09-19 (revision 2 — see "Revision history" at the bottom)

Two new members were added to the group on 2026-09-17 at Ms Mbele's
request: **Ofentse Rammutla** (223056856) and **Breyton Rossouw**
(222069744). This document gives them real, scoped, checkable Phase 2 work
— not busywork — so their GitHub activity and Progress Tracker entries show
genuine contribution from day one, per the module's individual-participation
rules.

> Fill in/correct names below if this doesn't match who's actually on the
> group — this is a first draft based on what's confirmed in chat and email.

## Assignment table

| Deliverable (Unit 3) | Owner | Reviewer | Notes |
|---|---|---|---|
| Activity 3.1 — System Architecture Diagram | **Ofentse Rammutla** | Wisani | Draft is already in `system-architecture.md` (Mermaid, grounded in real code) — Ofentse's job is to turn it into a proper diagram (draw.io / Lucidchart / Figma export), check it against the video's requirements, and present it at the consultation. Good onboarding task: low risk, high learning value. |
| Activity 3.2, Part 1 & 2 — Use Case Diagram + Sequence Diagrams ("the UML diagrams") | **Ofentse Rammutla and Breyton Rossouw, working together** | Wisani | **Changed 2026-09-19**: originally split one-each, now a paired task instead. We don't have a read yet on either of their skill levels, so rather than have Breyton (who'd already offered to take "the UML diagrams" since he had no other task yet) do it solo, both of them work through it together — draw case diagram + both sequence diagrams as a pair, both push commits, both can be assessed on it. Drafts for both are already in `uml-and-erd.md` Parts 1 & 2 to work from; Gary should confirm the Flutter-side sequence diagram matches mobile's actual code path. |
| Activity 3.2, Part 3 — ERD | **Wisani** | Gary | Drafted directly from the live Postgres schema (`web/Models/*.cs` + migrations) — Gary should sanity-check nothing's missing (e.g. any mobile-only columns not yet reflected on web). |
| Activity 3.3 — Flutter interface wireframes | **Gary** | Ofentse or Breyton | Screens already exist and are live — this is "wireframe the existing screens", not design-from-scratch. Export a few real screenshots + label them, or trace them in Figma per the required video. |
| Activity 3.3 — ASP.NET interface wireframes | **Kia or Kumo** (to confirm) | Wisani | Same idea on the web side — Pages/Bookings, Pages/Stock, Pages/Vehicles screenshots, labelled and tied back to the use cases they satisfy. Reassigned off Breyton now that he's paired with Ofentse on the UML diagrams — needs an owner from Kia/Kumo, confirm at the next meeting. |
| Activity 3.3 — Navigation flow | **Kia or Kumo** (to confirm) | Wisani | How a staff member moves between dashboard -> booking -> add job/part -> invoice/finalize, and admin-only branches (delete, reopen). Same reassignment note as above. |
| Stakeholder design feedback | **Wisani** | — | Coordinating with Riese Auto-Clinic; will capture feedback in `project-docs/meeting-notes/`. |
| Microsoft Project update | **Wisani** | — | Add Unit 3 tasks/owners from this table; mark M0–M8 (dev) as already complete since it finished ahead of design docs. |
| GitHub evidence | **All** | — | Everyone commits their own piece under `project-docs/phase-2/` on a `phase2/design-docs` branch — don't have one person commit for everyone, that's exactly what individual GitHub activity tracking is meant to catch. For the paired UML task, both Ofentse and Breyton should have commits on it, not just one. |
| Progress Tracker | **Wisani** | — | Log each person's Phase 2 task against their name with today's date as the start. |

## Revision history

- **2026-09-19 (rev 2)**: Moved the use case + sequence diagrams from a
  one-each split (Ofentse / Breyton) to a joint paired task for both of
  them. Reason: unknown skill level for two members who just joined, and
  Breyton had already offered to take "the UML diagrams" solo since he had
  no other task yet — pairing reduces the risk of one person getting stuck
  alone on unfamiliar UML notation. Freed up the ASP.NET wireframes and
  navigation-flow tasks, provisionally reassigned to Kia/Kumo pending
  confirmation at the next meeting.
- **2026-09-19 (rev 1)**: Initial draft, one task each for Ofentse and
  Breyton.

## Suggested sequence for the next few days

1. **Now – 21 Sept**: Ofentse and Breyton read `system-architecture.md` and
   `uml-and-erd.md`, turn the Mermaid drafts into proper diagram-tool
   exports, and each push their own commit.
2. **22 Sept, 12:00**: Consultation with Ms Mbele (Group Y's slot) — bring
   the architecture diagram, use case diagram, and progress tracker per the
   Unit 3 Group Progress Checkpoint (`6.pdf`).
3. **After feedback**: adjust diagrams, do the wireframes (Activity 3.3),
   finalize the design baseline.
