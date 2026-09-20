# Phase 2 Master Checklist

Source: the official **ITC327W Group Assessment 2** brief (issued
2026-09-19, due **2026-10-12**) and the **Phase 2 marking rubric**
(Group Y sheet) — both from CUT, not drafted by us. Assessment 2 = 30% of
the module. Presentation/defence alone is 30 of the 100 marks.

Phase 3 (Assessment 3, due 2026-11-02, 50% of the module) **continues the
same SRS, design and GitHub repo** — nothing here is throwaway. Get Phase 2
right and Phase 3 starts from a working baseline instead of a redo.

**Updated 2026-09-20**: Wisani's task load was checked and rebalanced (see
`roles-and-assignments.md` rev 5) — the ERD redraw, navigation flow, and
design-alignment table moved to Gary, Kea and Denny respectively.
[Spanner Design Backups](https://claude.ai/artifact/4j8EwFJ9KL3tC9GujFSBov)
(worked architecture + UML diagram examples) was shared with the group as
a reference, not the submission.

## The 8 things that must exist in the actual submission

| # | Submission item | Format | Status |
|---|---|---|---|
| 1 | Updated SRS (Phase 1 + Phase 2 in **one PDF**) | New "System Architecture and Design" section inserted into the existing SRS — **not** a separate document | Draft content ready, not yet merged into the SRS PDF |
| 2 | Microsoft Project plan | Original editable file + a clear screenshot inside the SRS | Khumo owns this |
| 3 | ITC327W Progress Tracker | Excel workbook, continuing the real Phase 1 one | Drafted, needs final top-up before submission |
| 4 | GitHub repository | Working link, current docs, no secrets | Live, being kept current |
| 5 | Original design source links | Working links to the **editable** architecture/use case/sequence/ERD/wireframe files (draw.io, Lucidchart, Figma, etc.) — a PDF or screenshot does **not** count on its own | Not started — see note below |
| 6 | Phase 2 presentation & defence | Delivered live at the assessment session | Not scheduled yet |

**Important, easy to miss:** rubric item 5 above ("Design Alignment,
Documentation and Source Links") explicitly requires a **working share
link to the editable diagram**, not just an exported PDF/PNG. Whoever
redraws a diagram in draw.io/Lucidchart/Figma must turn on link sharing (or
export the editable file into the submission ZIP if the tool is offline)
and record that link. This is graded on its own (5 marks) and also gates
part of "Design Alignment" more broadly.

## Owner / reviewer per deliverable

Nobody works alone on their piece — everyone has one reviewer whose job is
to actually look, not just approve. Push directly to GitHub rather than
routing everything through one person; the commits themselves are how the
group stays in sync, not extra meetings.

| Task | Owner | Reviewer | Rubric line it feeds | Due |
|---|---|---|---|---|
| System architecture diagram — redraw in a real tool + share link | Ofentse | Gary | System Architecture Design (10) | 21 Sept |
| Use case diagram + 2 sequence diagrams ("the UML diagrams") — redraw + share links | Ofentse & Breyton, together | Wisani (content), Gary (Flutter sequence matches real code) | Use Case Diagram (10), Sequence Diagrams (10) | 21 Sept |
| ERD — redraw in a real tool + share link, and sanity-check vs mobile's columns | **Gary** (moved off Wisani 20 Sept) | Wisani | ERD and Database Design (10) | 23 Sept |
| Flutter interface wireframes (from the real, live screens) | Gary | Kea | Flutter Interface Design (10) | 25 Sept |
| ASP.NET interface wireframes (from the real, live screens) | Kea | Wisani | ASP.NET Interface Design (10) | 25 Sept |
| Navigation flow diagram | **Kea** (moved off Wisani 20 Sept) | Wisani | feeds Design Alignment (5) | 25 Sept |
| Design-alignment table (requirement → use case → sequence → ERD → interface) | **Denny** (moved off Wisani 20 Sept) | Wisani | Design Alignment, Documentation and Source Links (5) | 27 Sept |
| Reconfirm requirements with Michael Riese before the design is called final | **Denny** (sole owner from 20 Sept) | Wisani (informed) | feeds Design Alignment + credibility of the whole section | After 22 Sept consultation |
| Merge everything into the existing SRS as one new section (no separate doc) | Wisani | Denny | Design Alignment (5), all design criteria depend on this existing | 30 Sept |
| Microsoft Project — update schedule + screenshot into the SRS | **Khumo** | Wisani | MS Project, GitHub and Progress Tracker (5) | 3 Oct |
| Excel Progress Tracker — final top-up (tasks, contributions, challenges, Phase 2 reflection) | Wisani | Whole group sign-off | MS Project, GitHub and Progress Tracker (5) | 8 Oct |
| GitHub — keep current, no secrets, README up to date | Whoever changes something, pushes it themselves | — | MS Project, GitHub and Progress Tracker (5) | Ongoing |
| Consultation with Ms Mbele | All | — | de-risks everything above | 22 Sept, 12:00 |
| Presentation & defence rehearsal — **everyone must be able to explain the whole design, not just their own piece** (rubric's own wording) | All | — | Presentation and Defence (30 — the single biggest line item) | Week of 6 Oct |

## Full 100-mark breakdown (for reference)

| Component | Marks |
|---|---|
| System Architecture Design | 10 |
| Use Case Diagram | 10 |
| Sequence Diagrams | 10 |
| ERD and Database Design | 10 |
| Flutter Interface Design | 10 |
| ASP.NET Interface Design | 10 |
| Design Alignment, Documentation and Source Links | 5 |
| Microsoft Project, GitHub and Progress Tracker | 5 |
| Presentation and Defence | 30 |
| **Total** | **100** |

## Before you submit — the brief's own checklist, verbatim

- [ ] Phase 1 SRS includes all required Phase 2 diagrams and designs
- [ ] Architecture shows Flutter, ASP.NET and Supabase as **one** integrated system
- [ ] Use Case Diagram uses appropriate UML notation and relationships
- [ ] At least two Sequence Diagrams are complete and linked to approved use cases
- [ ] ERD contains appropriate entities, keys, relationships and cardinality
- [ ] Both Flutter and ASP.NET interface designs are complete and aligned with requirements
- [ ] SRS includes a Microsoft Project screenshot and the editable file is submitted
- [ ] GitHub is current and does not contain confidential information or private credentials
- [ ] Design links work and any offline editable files are included in the ZIP
