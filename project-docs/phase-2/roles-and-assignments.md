# Phase 2 Roles and Assignments

**Group Y — ITC327W — Spanner (Riese Auto-Clinic)**
Updated: 2026-09-19

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
| Activity 3.2, Part 1 — Use Case Diagram | **Breyton Rossouw** | Wisani | Draft actor/use-case list is in `uml-and-erd.md` — Breyton's job is to draw it properly (system boundary, `<<include>>`/`<<extend>>`/generalization) and sanity-check it against what the app actually does (ask Wisani for a walkthrough if unsure). |
| Activity 3.2, Part 2 — Sequence Diagrams (≥2, one Flutter one ASP.NET) | **Wisani** (web one) + **Gary** (mobile one) | Ofentse/Breyton | Two draft sequence diagrams (Mermaid) are already in `uml-and-erd.md`. Gary should confirm the Flutter-side one matches mobile's actual code path. |
| Activity 3.2, Part 3 — ERD | **Wisani** | Gary | Drafted directly from the live Postgres schema (`web/Models/*.cs` + migrations) — Gary should sanity-check nothing's missing (e.g. any mobile-only columns not yet reflected on web). |
| Activity 3.3 — Flutter interface wireframes | **Gary** | Ofentse | Screens already exist and are live — this is "wireframe the existing screens", not design-from-scratch. Export a few real screenshots + label them, or trace them in Figma per the required video. |
| Activity 3.3 — ASP.NET interface wireframes | **Breyton Rossouw** | Wisani | Same idea on the web side — Pages/Bookings, Pages/Stock, Pages/Vehicles screenshots, labelled and tied back to the use cases they satisfy. |
| Activity 3.3 — Navigation flow | **Ofentse Rammutla** | Wisani | How a staff member moves between dashboard → booking → add job/part → invoice/finalize, and admin-only branches (delete, reopen). |
| Stakeholder design feedback | **Wisani** | — | Coordinating with Riese Auto-Clinic; will capture feedback in `project-docs/meeting-notes/`. |
| Microsoft Project update | **Wisani** | — | Add Unit 3 tasks/owners from this table; mark M0–M8 (dev) as already complete since it finished ahead of design docs. |
| GitHub evidence | **All** | — | Everyone commits their own piece under `project-docs/phase-2/` on a `phase2/design-docs` branch — don't have one person commit for everyone, that's exactly what individual GitHub activity tracking is meant to catch. |
| Progress Tracker | **Wisani** | — | Log each person's Phase 2 task against their name with today's date as the start. |

## Suggested sequence for the next few days

1. **Now – 21 Sept**: Ofentse and Breyton read `system-architecture.md` and
   `uml-and-erd.md`, turn the Mermaid drafts into proper diagram-tool
   exports, and each push their own commit.
2. **22 Sept, 12:00**: Consultation with Ms Mbele (Group Y's slot) — bring
   the architecture diagram, use case diagram, and progress tracker per the
   Unit 3 Group Progress Checkpoint (`6.pdf`).
3. **After feedback**: adjust diagrams, do the wireframes (Activity 3.3),
   finalize the design baseline.
