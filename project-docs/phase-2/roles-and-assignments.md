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

**Wisani's load was checked and rebalanced 2026-09-20** — she was carrying
~10 active items (architecture, ERD, navigation flow, alignment table,
stakeholder reconfirmation, SRS merge, tracker, plus reviewing everyone
else) — the same overload pattern as Phase 1, where she alone compiled
the SRS, tracker, contribution records and reflection. Fixed by moving
execution of three items to people with spare capacity, while she stays
the *reviewer* on them (keeps oversight without being the bottleneck).

| Deliverable (Unit 3) | Owner | Reviewer | Notes |
|---|---|---|---|
| Activity 3.1 — System Architecture Diagram | **Ofentse Rammutla** | Gary van Wyk | Draft is already in `system-architecture.md` (Mermaid, grounded in real code) — Ofentse's job is to turn it into a proper diagram (draw.io / Lucidchart / Figma export), check it against the video's requirements, and present it at the consultation. Good onboarding task: low risk, high learning value. A private example (see below) is available to check against, not to copy. |
| Activity 3.2, Part 1 & 2 — Use Case Diagram + Sequence Diagrams ("the UML diagrams") | **Ofentse Rammutla and Breyton Rossouw, working together** | Wisani + Gary van Wyk | Originally split one-each, changed to a paired task instead. We don't have a read yet on either of their skill levels, so rather than have Breyton (who'd already offered to take "the UML diagrams" solo since he had no other task yet) do it alone, both of them work through it together — draw the use case diagram + both sequence diagrams as a pair, both push commits, both can be assessed on it. Drafts for both are already in `uml-and-erd.md` Parts 1 & 2 to work from; Gary should confirm the Flutter-side sequence diagram matches mobile's actual code path. |
| Activity 3.2, Part 3 — ERD: redraw in a proper tool + share link, and sanity-check against mobile's columns | **Gary van Wyk** | Wisani | **Moved from Wisani 2026-09-20** — Gary already owned the ERD sanity-check, so drawing and checking it is one pass by the person who knows the live schema best, not two separate people touching the same artefact. Wisani drafted it (`uml-and-erd.md` Part 3) and reviews the redraw. |
| Activity 3.3 — Flutter interface wireframes | **Gary van Wyk** | Kea | Screens already exist and are live — this is "wireframe the existing screens", not design-from-scratch. Export a few real screenshots + label them, or trace them in Figma per the required video. |
| Activity 3.3 — ASP.NET interface wireframes | **Keamogetse Ogone Kgosi (Kea)** | Wisani | Pages/Bookings, Pages/Stock, Pages/Vehicles screenshots, labelled and tied back to the use cases they satisfy. |
| Activity 3.3 — Navigation flow | **Keamogetse Ogone Kgosi (Kea)** | Wisani | **Moved from Wisani 2026-09-20** — pairs naturally with her ASP.NET wireframes above (same screens, same person already has them open). How a staff member moves between dashboard → booking → add job/part → invoice/finalize, and admin-only branches (delete, reopen). |
| Design-alignment table (requirement → use case → sequence → ERD → interface) | **Mathye MD (Denny)** | Wisani | **Moved from Wisani 2026-09-20** — Denny's Phase 1 role was exactly this kind of cross-checking/content work (helped compile the SRS content, supported the redefined scope), so this continues that rather than being new ground. Required by the official Phase 2 assessment brief, item 4. |
| Reconfirm requirements with the stakeholder before finalizing the design | **Mathye MD (Denny)** | Wisani (kept informed) | **Wisani dropped as co-owner 2026-09-20** — Denny runs this himself now; this is literally the group's own stated priority for Phase 2 from the Phase 1 Group Reflection, and plays to his demonstrated strength (he's the one who chased down and secured the Ms Mbele consultation after email stalled). |
| Merge Phase 2 content into the existing SRS (single PDF, no separate document) | **Wisani** | Denny | Kept with Wisani — the official brief is explicit: "do not create a separate System Design Document," and this is a continuation of the SRS role she and Denny already held in Phase 1, not new overload. |
| Microsoft Project — update schedule + screenshot | **Moremi KE (Khumo)** | Wisani | Continues her Phase 1 role getting the schedule finished and distributed. |
| Progress Tracker — final top-up before submission | **Wisani** | Whole group sign-off | Official workbook continued as `Group Y - ITC327W Progress Checker (Phase 2 update).xlsx`, same structure as the Phase 1 submission. Needs Task Progress, Individual Contributions, Stakeholder Engagement and Challenges kept current, and the Phase 2 Group Reflection completed honestly at the end of the phase — not before. |
| GitHub evidence | **All** | — | Everyone commits their own piece under `project-docs/phase-2/` on a `phase2/design-docs` branch — don't have one person commit for everyone, that's exactly what individual GitHub activity tracking is meant to catch. For the paired UML task, both Ofentse and Breyton should have commits on it, not just one. |
| Presentation & defence rehearsal | **All** | — | 30 of the 100 Phase 2 marks — the single biggest line item. The rubric explicitly expects every member to be able to explain the *whole* design, not just their own piece — questions in the defence can go to anyone about any part. |

**After the rebalance, Wisani's active "do" list is 2 items** (SRS merge,
tracker top-up) plus reviewing 6 others — down from ~10. Everyone else
picked up at most one extra item.

Full deliverable list, rubric mapping and deadlines: see
`phase2-checklist.md`.

## Design examples (shared 2026-09-20)

Wisani shared **[Spanner Design Backups](https://claude.ai/artifact/4j8EwFJ9KL3tC9GujFSBov)**
with the group — worked examples of the architecture diagram and the UML
diagrams (use case + both sequence diagrams), drawn with real notation.
**These are reference examples, not the submission** — Ofentse, Breyton
and Gary still need to produce their own versions in a real diagramming
tool with a working share link (per the brief's own requirement); use the
examples to check notation and completeness, not to copy wholesale.

## Revision history

- **2026-09-20 (rev 5)**: Load check on Wisani — she was the owner on 10
  active items plus reviewer on most others, the same pattern as Phase 1's
  solo SRS/tracker/reflection load. Moved ERD redraw to Gary (merges with
  his existing sanity-check task), navigation flow to Kea (pairs with her
  ASP.NET wireframes), the design-alignment table to Denny (matches his
  Phase 1 content-support role), and dropped Wisani as co-owner of the
  stakeholder reconfirmation (Denny runs it alone, she stays informed).
  She keeps the SRS merge and tracker top-up — both direct continuations
  of her Phase 1 role, not overload. Also: shared the design-example
  diagrams with the group (see below) as reference, not the submission.
- **2026-09-20 (rev 4)**: Pulled in the official Phase 2 assessment brief
  and rubric (issued 2026-09-19, due **2026-10-12**, 30% of the module,
  presentation/defence alone 30/100 marks). Khumo now owns the Microsoft
  Project update (was Wisani) — she led the Phase 1 schedule work, so this
  continues that rather than being a new task. Freed-up navigation flow
  diagram moved to Wisani. Added the design-alignment table and the
  SRS-merge task, both explicit requirements in the official brief. Full
  breakdown in `phase2-checklist.md`.
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
