# Phase 2 Roles and Assignments

**Group Y ("The Zealots") — ITC327W — Spanner (Riese Auto-Clinic)**
Updated: 2026-09-19 (revision 3 — see "Revision history" at the bottom)

Roster corrected against the official Phase 1 submission
(`Group Y - ITC327W Progress Checker.xlsx`) — earlier drafts of this
document had two names wrong (transcribed as "Kia"/"Kumo" instead of
Kea/Khumo) and were missing Denny entirely. See `CONTRIBUTORS.md` for the
full roster with student numbers.

Two new members were added to the group on 2026-09-17 at Ms Mbele's
request: **Ofentse Rammutla** (223056856) and **Breyton Rossouw**
(222069744). This document gives them real, scoped, checkable Phase 2 work
— not busywork — so their GitHub activity and Progress Tracker entries show
genuine contribution from day one, per the module's individual-participation
rules.

## Assignment table

| Deliverable (Unit 3) | Owner | Reviewer | Notes |
|---|---|---|---|
| Activity 3.1 — System Architecture Diagram | **Ofentse Rammutla** | Wisani | Draft is already in `system-architecture.md` (Mermaid, grounded in real code) — Ofentse's job is to turn it into a proper diagram (draw.io / Lucidchart / Figma export), check it against the video's requirements, and present it at the consultation. Good onboarding task: low risk, high learning value. |
| Activity 3.2, Part 1 & 2 — Use Case Diagram + Sequence Diagrams ("the UML diagrams") | **Ofentse Rammutla and Breyton Rossouw, working together** | Wisani | Originally split one-each, changed to a paired task instead. We don't have a read yet on either of their skill levels, so rather than have Breyton (who'd already offered to take "the UML diagrams" solo since he had no other task yet) do it alone, both of them work through it together — draw the use case diagram + both sequence diagrams as a pair, both push commits, both can be assessed on it. Drafts for both are already in `uml-and-erd.md` Parts 1 & 2 to work from; Gary should confirm the Flutter-side sequence diagram matches mobile's actual code path. |
| Activity 3.2, Part 3 — ERD | **Wisani** | Gary van Wyk | Drafted directly from the live Postgres schema (`web/Models/*.cs` + migrations) — Gary should sanity-check nothing's missing (e.g. any mobile-only columns not yet reflected on web). |
| Activity 3.3 — Flutter interface wireframes | **Gary van Wyk** | Kea or Khumo | Screens already exist and are live — this is "wireframe the existing screens", not design-from-scratch. Export a few real screenshots + label them, or trace them in Figma per the required video. |
| Activity 3.3 — ASP.NET interface wireframes | **Keamogetse Ogone Kgosi (Kea)** | Wisani | Same idea on the web side — Pages/Bookings, Pages/Stock, Pages/Vehicles screenshots, labelled and tied back to the use cases they satisfy. Reassigned off Breyton now that he's paired with Ofentse on the UML diagrams. |
| Activity 3.3 — Navigation flow | **Moremi KE (Khumo)** | Wisani | How a staff member moves between dashboard → booking → add job/part → invoice/finalize, and admin-only branches (delete, reopen). Reassigned off Breyton for the same reason as above — a good fit for Khumo given her Phase 1 role coordinating and distributing shared work across the group. |
| Reconfirm requirements with the stakeholder before finalizing the design | **Mathye MD (Denny)**, with Wisani | — | This is literally the group's own stated priority for Phase 2 from the Phase 1 Group Reflection ("confirm the requirements directly with Michael Riese before starting UML, ERD and interface design"). Good fit for Denny given his Phase 1 strength — he's the one who chased down and secured the Ms Mbele consultation after email stalled. |
| Stakeholder design feedback | **Wisani** | — | Coordinating with Riese Auto-Clinic; will capture feedback in `project-docs/meeting-notes/`. |
| Microsoft Project update | **Wisani** | — | Add Unit 3 tasks/owners from this table; mark M0–M8 (dev) as already complete since it finished ahead of design docs. |
| GitHub evidence | **All** | — | Everyone commits their own piece under `project-docs/phase-2/` on a `phase2/design-docs` branch — don't have one person commit for everyone, that's exactly what individual GitHub activity tracking is meant to catch. For the paired UML task, both Ofentse and Breyton should have commits on it, not just one. |
| Progress Tracker | **Wisani** | — | Official workbook continued as `Group Y - ITC327W Progress Checker (Phase 2 update).xlsx`, same structure as the Phase 1 submission. |

## Revision history

- **2026-09-19 (rev 3)**: Corrected the roster against the actual Phase 1
  submission workbook. "Kia" → **Keamogetse Ogone Kgosi (Kea)**, "Kumo" →
  **Moremi KE (Khumo)** — both were phonetic mis-transcriptions from a
  voice message, not real names. Added **Mathye MD (Denny)**, who was
  missing from earlier drafts entirely, and gave him the stakeholder
  reconfirmation task — which the group had already identified as its own
  top Phase 2 priority at the end of Phase 1, and which plays to his
  demonstrated strength (securing the Ms Mbele consultation in Phase 1).
  Gary's surname (van Wyk) and student number added.
- **2026-09-19 (rev 2)**: Moved the use case + sequence diagrams from a
  one-each split (Ofentse / Breyton) to a joint paired task for both of
  them, since we don't yet know either of their skill levels.
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
   Denny reconfirms requirements with Michael Riese, finalize the design
   baseline.
