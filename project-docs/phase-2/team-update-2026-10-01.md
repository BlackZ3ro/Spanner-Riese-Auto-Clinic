# Spanner: Team Update, 1 October 2026 (SRS v2.0 draft)

Group Y "The Zealots", ITC327W. From Wisani.
**Attached:** Group Y - SRS v2.0 (Phase 2 - System Architecture and Design).pdf (28 pages)
Live tracker: https://claude.ai/artifact/3TeRkof9dpEMUGjAiz2iDo
GitHub: https://github.com/BlackZ3ro/Spanner-Riese-Auto-Clinic (pull request #15; the SRS is also in `project-docs/`)
**Phase 2 is due Monday 12 October: 11 days.** Presentation and defence are worth 30 of the 100 marks.

## The SRS is merged: please read it before Saturday

The brief wants **one updated SRS as a single PDF**, not a separate design document. So here is the whole thing in one file:

- **Front (2 pages):** new cover with all 7 of us, and a revision page explaining what changed.
- **Part A (14 pages):** our Phase 1 SRS, exactly as submitted and marked (80%). Nothing rewritten.
- **Part B (12 pages):** Phase 2:
  - **Section 4:** new requirements FR-14 to FR-18, the change log (Changes 7-11), scope and risk updates.
  - **Section 5:** architecture, use case diagram, 5 sequence diagrams, ERD, Flutter wireframes, ASP.NET screens.
  - **Section 6:** design alignment table, editable-source links, and the list of what is still missing.

**Everyone:** in the defence, any of us can be asked about any part of the design. Read Part B end to end, not just your own section.

## One thing we all need to be able to explain: the scope change

In Phase 1 we **excluded** customer-facing status tracking (Change 5), because Michael Riese said it creates false expectations and extra work. At the 22 Sept consultation Ms Mbele asked for a customer screen, and Gary has now built the lookup plus notifications. The SRS records this honestly as **Change 7, a partial reversal**, and explains why the design avoids both of Michael's concerns:

- customers only see **5 broad stages**, never an ETA;
- staff change the stage with **one tap** at natural milestones.

Customer accounts are still out of scope. **Michael still has to agree to this change**, which is Denny's task below. If he says no, we disable notifications and keep the lookup staff-only (risk R-14).

## What each person still owes (SRS Section 6.3)

| Who | What | SRS section it fills | Due |
|---|---|---|---|
| **Denny** | Reconfirm the requirements with Michael Riese, **including Change 7**. Send me one line (his yes/no + date) for the Stakeholder Engagement sheet | 4.2, R-14 | **4 Oct** |
| **Denny** | Review the design alignment table I drafted, and correct anything wrong | 6.1 | 6 Oct |
| **Kea** | Navigation flow diagram (screens and how you move between them, both apps) + editable link | 5.6 | **4 Oct** |
| **Ofentse** | Architecture diagram redraw + editable link (use Figure 1 in the SRS as the reference) | 5.1, 6.2 | **4 Oct** |
| **Breyton** | Lucid links: set **Share -> Anyone with the link -> Can view** (they ask for a sign-in now), rename them from "Blank diagram", and check they match the SRS diagrams | 6.2 | **2 Oct** |
| **Gary** | **Revoke the leaked Firebase key** (overdue since 29 Sept); run migration 0007; build the mobile fixes | R-10 | **2 Oct** |
| **Gary** | ERD redraw + editable link (must include booking_labor, profiles, booking_push_tokens, phase, reference_code); editable link for the Flutter wireframes | 5.4, 5.5, 6.2 | 5 Oct |
| **Khumo** | Microsoft Project update (add the Phase 2 tasks) + screenshot | 6.2 | **3 Oct** |
| **Wisani** | Final SRS once the items above arrive; tracker top-up and Phase 2 reflection | whole doc | 8 Oct |
| **Everyone** | Presentation rehearsal: each person explains the whole design | - | week of 6 Oct |

**Editable links:** the brief says a PNG or PDF of a diagram **does not count**. Whatever tool you use (Lucid, draw.io, Canva), make sure the link opens **without signing in** before you send it. The draw.io starting files are in `project-docs/phase-2/diagrams/editable`.

## Already done

- Phase 1 (80%). Web app M0-M8.
- Mobile login, customer lookup and phase notifications (Gary).
- Admin-only rules on both apps. Consultation feedback applied.
- Reference diagrams with editable draw.io sources. Tracker v11. **SRS v2.0 draft.**

## Before we merge PR #15

Someone with the logins, please test the web app:
1. As a **mechanic**: there is no Finalize, Delete or Reopen.
2. As **admin**: all three work, and the booking page shows the phase and the customer reference code.

Reply in the group with the result.

Please update your task in the live tracker when you start and when you finish. It's how I know what's actually done.
