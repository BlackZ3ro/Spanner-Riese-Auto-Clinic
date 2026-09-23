# Spanner (Riese Auto-Clinic) - Project Status, Beginning to 23 September 2026

Group Y "The Zealots", ITC327W. Prepared by Wisani Nkuna (222010787).
Team: Wisani Nkuna, Gary van Wyk, Keamogetse Ogone Kgosi (Kea), Moremi KE (Khumo), Mathye MD (Denny), plus Ofentse Rammutla (223056856) and Breyton Rossouw (222069744), who joined on 17 September 2026.
Stakeholder: Michael Riese. Academic mentor: Ms Mbele.
Repository: github.com/BlackZ3ro/Spanner-Riese-Auto-Clinic (working branch phase2/design-docs, local only, not yet pushed).

## 1. What the project is

A workshop booking, stock and invoicing system for Riese Auto-Clinic: a Flutter mobile app and an ASP.NET Core web app sharing one Supabase (Postgres) backend.

## 2. Timeline from the start

| When | What happened |
|---|---|
| 25 Aug 2026 | Repository created; planning, requirements, design, testing and meeting-notes folders set up. |
| Aug - Sep (Phase 1) | Requirements, SRS, Feasibility Study, Risk Register, stakeholder interview and Microsoft Project plan produced. Phase 1 (Planning, Requirements and Feasibility) result: **80%**. |
| Sep (web build) | ASP.NET web app built milestone by milestone: M0 setup, M1 login and dashboard, M2 book in a vehicle and jobs, M3 stock and parts, M4 labour costing, M5 invoice PDF, M6 vehicle history search, M7 real-time sync and non-functional checks, M8 full test pass and demo script. The Flutter mobile app (Gary) landed on main in parallel. |
| Sep (hardening) | Web reconciled with the mobile schema, stock race condition fixed, finalize/reopen added, missing DELETE policies fixed, admin-only Finalize and Delete with atomic restock added (migrations 0004 and 0005). Two live-found migration bugs fixed. |
| 17 Sep | Ofentse and Breyton joined; roster corrected against the real Phase 1 Progress Checker. |
| 19 Sep | Phase 2 design docs drafted from the live schema and real behaviour: architecture, use case, sequence diagrams, ERD. UML task paired to Ofentse and Breyton. |
| 20 Sep | Load rebalanced (ERD to Gary, navigation flow to Kea, design-alignment table to Denny). Zealots Tracker (shared task board) and Spanner Design Backups (reference diagrams, wireframes, real screenshots) published. Gary's Flutter wireframes added. ASP.NET wireframes checked off. |
| 22 Sep | Consultation with Ms Mbele (Lab 226). Feedback: fewer, tighter use case ovals; Manage Bookings / Manage Stock with extensions; authentication on extensions; dashboard as an extension; open/closed filter; new customer repair-status lookup by reference code (no login). |
| 23 Sep | Reference diagrams corrected against the real web and mobile code and the consultation feedback. Permissions agreed. Tracker updated. This report. |

## 3. What is done

- Phase 1 submitted (80%).
- Web app milestones M0 to M8 built and tested; live against Supabase.
- Admin/mechanic access on web (config allowlist); atomic delete-with-restock; stock decrement RPC.
- Phase 2 reference designs: architecture, use case (final structure), sequence diagrams (book in a vehicle on mobile and web, admin finalize, admin delete, admin reopen), ERD draft, web wireframes, real screenshots, Gary's Flutter wireframes (PNG), consultation prep and outcomes.
- Official Progress Checker continued as "Phase 2 update v7" (Phase 1 rows preserved verbatim).
- Zealots Tracker updated for the consultation (tasks and feed).
- Design review of Ofentse and Breyton's diagrams against the code, with corrected reference versions.

## 4. Agreed design decisions (23 Sept)

- Admin on the left, Mechanic on the right; shared use cases connect to both; admin-only use cases connect to Admin only.
- **Only Admin can finalize a booking, delete a booking, reopen a closed booking and remove jobs. Both roles can restock parts** and do everything else.
- Dashboard is a separate box included from Login, not a hub.
- Login includes "Validate with Supabase Auth" on web and mobile (the mobile role picker stays for testing only).
- Sequence diagrams: Login first, then working with the system; `Alt` never `Loop`.
- Customer (no login) checks repair status by reference code.

## 5. Known gaps between the design and the code

1. Mobile has no real login: role picker only, and it gates nothing (mobile can finalize and delete). Task U3-22.
2. Web does not yet gate Reopen (it only asks for the user's own password) or single-job removal to admins. Task U3-23.
3. Mobile "labour" (`booking_labor`) and web "jobs" are separate ledgers on the same bookings.
4. Mobile adds a part and records the stock movement as two separate calls (not atomic); web uses one RPC.
5. Migrations 0004 and 0005 final versions need a confirmed live re-check by Gary; a leftover DELTEST booking is still in the live database.

## 6. What is left (Phase 2 due 12 October 2026; Phase 3 due 2 November 2026)

| # | Task | Owner | Target |
|---|---|---|---|
| U3-02 | Redraw architecture diagram + share link | Ofentse | 21 Sep (overdue) |
| U3-04 | Redraw use case + sequence diagrams to the new reference versions + editable share links | Ofentse and Breyton | 26 Sep |
| U3-08 | Redraw ERD + share link, sanity-check against mobile | Gary | 23 Sep |
| U3-10 | Flutter wireframes: editable .canvas source and link | Gary | 25 Sep |
| U3-12 | Navigation flow diagram | Kea | 25 Sep |
| U3-13 | Design-alignment table (requirement to use case to sequence to ERD to interface) | Denny | 27 Sep |
| U3-14 | Reconfirm requirements with Michael Riese | Denny | after 22 Sep |
| U3-15 | Merge everything into the existing SRS as one PDF | Wisani | 30 Sep |
| U3-18 | Microsoft Project update + screenshot into the SRS | Khumo | 3 Oct |
| U3-19 | Progress Checker final top-up incl. Phase 2 Group Reflection | Wisani | 8 Oct |
| U3-20 | Presentation and defence rehearsal (30 of 100 marks) | Everyone | week of 6 Oct |
| U3-21 | Customer repair-status lookup by reference code (new). **No owner yet.** Needs Gary's decision: reuse invoice_number or a new column | UNASSIGNED | 23 Sep (group target) |
| U3-22 | Mobile login validated by Supabase Auth (new) | UNASSIGNED (suggest Gary) | 1 Oct |
| U3-23 | Apply agreed permissions in web and mobile (new) | Wisani, review Gary | 1 Oct |

Submission checklist (from the official brief): one updated SRS as a single PDF (no separate design document); working links to editable design sources (PNG/PDF alone does not count); editable MS Project file plus screenshot; Excel tracker; GitHub link.

## 7. Risks to watch

- Editable source links are still missing for every diagram; PNG/PDF exports do not satisfy the brief.
- U3-21 has no owner and its deadline has effectively passed.
- Wisani is still the single point for SRS merge and tracker top-up; keep the rebalance.
- Individual contributions must be honest: the ASP.NET wireframes were produced by Wisani, not Kea, and the mobile mockup in the backups is a backup, not Gary's work.
