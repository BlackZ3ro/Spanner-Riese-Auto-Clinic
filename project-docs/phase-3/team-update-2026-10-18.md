# Spanner: Phase 3 brief, what it means for us (18 October 2026)

Group Y "The Zealots", ITC327W. From Wisani.
**Attached:** Unit 4 readiness pack (every table the notes ask for, filled in for Spanner), revised Phase 3 plan, Gary's updated handoff.
**Phase 3 is due Monday 2 November. We submit Friday 30 October.** Presentations are 2-6 Nov.

---

Hi all. I've gone through the Unit 4 notes on eThuto: Overview, Beginner
Guide, Activities 4.2, 4.3 and 4.4, and the Final Assessment checkpoint.
Here's what Phase 3 is and where we stand.

**What Phase 3 is:** *Assessment 3: System Development, Implementation and
Final Demonstration (50%).*

1. The Flutter app and the ASP.NET app working on **one Supabase backend**.
2. **At least two processes that work across both apps**, shown live to the
   panel. For example, something done on the phone shows up on the web, and
   the other way round.
3. **Evidence:** screenshots or short recordings of each app and of the
   shared processes, Supabase records, GitHub commits.
4. The **same** SRS (with any approved changes recorded), MS Project file and
   tracker. No new SRS or repo.

**Good news:**
- **Formal testing is Unit 5, not now.** The checkpoint says we *don't* need
  a test plan, test cases or a defect log yet. So I've dropped the test-plan
  task. Instead we fill in simple "initial function checks" tables.
- **Most of it is already built.** Because we built ahead in Phases 1 and 2,
  both apps already share one Supabase backend and do the main functions. I
  filled in every table the notes ask for in the readiness pack.

**Our two demo processes:**
- **P1: book-in, both directions.**
  1. Book in a car on the phone.
  2. It appears on the web dashboard.
  3. Add a part on the web.
  4. The phone shows the part, and the stock has dropped.
- **P2: repair progress to the customer.**
  1. Staff change the phase on the web and tap Send on WhatsApp.
  2. The customer gets the message and sees the stage in the app or on
     `/Track`.
  3. Staff change it again on the phone.
  4. The web `/Track` page updates.

**What the panel will check, and what we must fix:**
- **"Permissions enforced by the database, not just hidden buttons."**
  - Gary's migration **0008**: right now anyone can change a booking's phase
    without logging in.
  - New migration **0011**: makes finalize and reopen admin-only in the
    database. I've written and tested it; Gary runs it.
- **"Both apps use the same values."**
  - Status and phase values match in both apps. ✔
  - **Labour does not match:** the phone uses `booking_labor`, the web uses
    `jobs`, so the two invoices can disagree. We decide on Tuesday.
  - The admin role is read from two places; I'm moving the web to `profiles`.
- **No keys or real customer data** in GitHub or in screenshots. Dummy data
  only (e.g. "Test Customer", 060 000 0000).

**This week:**

| Who | What | By |
|---|---|---|
| **Everyone** | Read the readiness pack (short) before Tuesday | Tue 20 Oct |
| **Gary** | Firebase key; run **0009, 0004, 0008, 0010, 0011**; mobile WhatsApp button, web build, add part in one step (updated PDF) | 19 / 21 / 25 Oct |
| **Ofentse** | Web function checks on the live address, one screenshot per row (readiness §7) | from Tue 20 Oct |
| **Breyton** | Same for the Flutter app on your phone (readiness §7) | from Sun 25 Oct |
| **Kea** | Screen recording of P1 and P2 (phone and laptop side by side) | Tue 27 Oct |
| **Denny** | Book Michael's visit; with Ofentse, put the readiness tables into the SRS | 20 / 27 Oct |
| **Khumo** | Unit 4 tasks into MS Project (4.1-4.4, owners, dates) | Tue 20 Oct |
| **Wisani** | Web app live on Vercel; web fixes (admin role, labour once decided); SRS merge; tracker | ongoing |

**Two things still missing from eThuto:** Activity 4.1 (the Supabase
set-up notes) and the Phase 3 rubric. Whoever sees them first, please drop
them in the group.

Tuesday's meeting: agree the plan, decide on the labour ledger, and do a
quick dry run of P1.
