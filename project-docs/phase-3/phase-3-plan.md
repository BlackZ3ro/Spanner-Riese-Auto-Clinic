# Phase 3 plan (final phase)

Group Y "The Zealots", ITC327W. Drafted by Wisani, 17 Oct 2026; **revised 18 Oct
after reading the Unit 4 notes** (see `unit-4-readiness.md`).

**Phase 3 = Assessment 3: System Development, Implementation and Final
Demonstration, 50% of the module, due Monday 2 November 2026.
Presentations are in the week of 2-6 November** (Ms Mbele's announcement).
It continues the same SRS, designs, schedule, tracker and GitHub repo.

**Our internal deadline is Friday 30 October**, two days early, with one
named person uploading (Wisani; back-up Khumo). Phase 2 went in late; this
time we don't leave it to the last evening.

## 0. Before anything else

- **Unit 4 notes read (18 Oct).** Phase 3 is about building and
  **integrating** both apps on one Supabase backend, demonstrating **at least
  two processes that work across both apps**, and keeping **evidence**.
  **Formal testing (test plan, test cases, defect log) is Unit 5, not
  needed for this checkpoint.** What's needed instead is the "initial
  function checks" tables and a record of integration problems. Every table
  the notes ask for is filled in for our project in `unit-4-readiness.md`.
- **Rubric and tracker received 19 Oct** (`brief/`). Seven criteria; the
  live presentation alone is **30 of 100**, and every member must take part.
  How each criterion maps to our work and owners: `unit-4-readiness.md`,
  "How Phase 3 is marked". Tracker filled in:
  `tracker/Group Y - ITC327W Phase 3 Project Progress Tracker (updated 19 Oct).xlsx`.
- **Code freeze Thu 29 Oct:** the GitHub repo and the submitted ZIP must be
  the version we demonstrate (rubric).
- **Still to get from eThuto:** Activity 4.1 (Supabase set-up).
- **Ask Ms Mbele about the 14 Oct upload.** Our Phase 2 files went into the
  **"Assessment 3"** slot on eThuto, which is the Phase 3 slot. Ask her to
  move or mark it as Phase 2, so it isn't marked as our Phase 3 attempt and
  doesn't block our real Phase 3 upload. (Wisani, by Monday 19 Oct.)

## 1. Where we stand (17 Oct)

- Web app: every SRS function works, plus the Phase 2 feedback (Send on
  WhatsApp, customer use cases, Google search titles). Ready to deploy on
  Vercel; only the two Supabase settings are missing.
- Mobile app: built by Gary. **No changes on `main` since 28 Sept**, so these
  are still open: the database migrations, the Firebase key, the tracking
  patch, the WhatsApp button. Details in the Gary handoff PDF.
- Designs, schedule and tracker: updated for the 16 Oct feedback.

## 2. What we have to finish

| # | Work | Owner | Reviewer | By |
|---|---|---|---|---|
| 1 | Run migrations 0009, 0004, 0008, 0010 and check 0006 (`supabase db pull`) | Gary | Wisani | Wed 21 Oct |
| 2 | Revoke the leaked Firebase key (open since 29 Sept) | Gary | Wisani | Mon 19 Oct |
| 3 | Mobile: Send on WhatsApp button, web build (`kIsWeb` guard), apply the tracking patch, client colours | Gary | Kea | Sat 24 Oct |
| 4 | Put the web app online (Vercel) and test it there | Wisani | Ofentse | Tue 20 Oct |
| 5 | Put the Flutter web build online (Vercel) | Gary + Wisani | Breyton | Sun 25 Oct |
| 6 | **Decide on one labour ledger.** Mobile uses `booking_labor`, web uses `jobs`, so the two invoices can disagree. Proposal: keep `booking_labor` (mobile, the customer tracking page and the push already use it); Wisani moves the web app to it, `jobs` keeps the job type only | Whole group decides, Wisani + Gary build | Denny | Decide Tue 20 Oct, built Sun 25 Oct |
| 7 | Fix the integration gaps in `unit-4-readiness.md` section 6: run **0011** (finalize/reopen admin-only in the database; written and tested), web reads the admin role from `profiles`, mobile add-part through `add_booking_part` | Gary (SQL, mobile), Wisani (web) | Kea | Sun 25 Oct |
| 8 | Initial function checks on the live system, with a screenshot per row (readiness section 7): web (Ofentse), Flutter and Flutter web (Breyton). Screen recording of the two shared processes P1 and P2 (Kea) | Ofentse, Breyton, Kea | Kea | Tue 27 Oct |
| 9 | **Acceptance test with Michael Riese**: he books in a real car, follows it on `/Track`, gets the WhatsApp message, and signs off (or lists changes). Also: help him set up the Google Business Profile | Denny | Wisani | Sat 24 Oct (book the visit now) |
| 10 | SRS v3.0 implementation section: the function, shared-process, consistency, roles and alignment tables from `unit-4-readiness.md`, approved changes (WhatsApp, created_by, 0011, labour ledger) in the change log, known limitations | Denny + Ofentse (tables), Wisani (merge) | Kea | Tue 27 Oct |
| 11 | Microsoft Project: Phase 3 tasks, owners, links; status date; final screenshot | Khumo | Wisani | Tue 20 Oct (plan), Thu 29 Oct (final) |
| 12 | Phase 3 Progress Tracker (filled in 19 Oct; keep current): each member adds their own **Individual Contributions** rows; Group Reflection at the end | Everyone, Wisani collects | Khumo | Thu 29 Oct |
| 13 | Final SRS (v3.0) as one PDF, plus Supabase evidence (Table Editor screenshots, keys and personal data hidden) | Wisani, Gary (Supabase screenshots) | Denny | Thu 29 Oct |
| 14 | Final presentation: deck, live demo script on the Vercel address, Mr G's WhatsApp demo, everyone able to explain the whole system | Everyone (deck: Khumo + Breyton) | Wisani | Rehearse Sat 31 Oct |
| 15 | Submit on eThuto | Wisani (back-up Khumo) | - | **Fri 30 Oct** |

## 3. Week by week

**Week 1, 17-23 Oct: get everything working on the real address**

- Brief and rubric downloaded; Ms Mbele asked about the Assessment 3 slot.
- Gary: Firebase key, migrations, then the mobile changes.
- Wisani: web app on Vercel; smoke test.
- Tuesday meeting: decide the labour ledger, agree this plan, Khumo puts it
  in MS Project.
- Denny: book Michael's visit. Everyone: read `unit-4-readiness.md`.

**Week 2, 24-30 Oct: test, accept, document, submit**

- Flutter web build online. Ledger change built.
- Function checks and the P1/P2 recording on the live system; problems
  fixed by Tuesday 27.
- Michael's acceptance test (aim for Saturday 24).
- Final SRS, MS Project, tracker (Challenges & Actions = the integration
  problems list).
- **Submit Friday 30 Oct.**

**Week 3, 31 Oct-6 Nov: present**

- Rehearsal Saturday 31 Oct: full demo on the live address, each person
  answers questions on any part.
- On the day: open both Vercel addresses 2 minutes early (cold start), have
  the laptop version ready as a fall-back, a phone with WhatsApp ready for the
  WhatsApp demo.

## 4. Risks

| Risk | What we do |
|---|---|
| Vercel's container hosting is a beta; the site is slow after 5 idle minutes | Open it early; laptop version (`dotnet run`) as fall-back |
| Supabase free plan pauses a project after a week with no activity | Someone opens the app at least every few days; restore from the dashboard if it pauses |
| Gary's database and mobile work stays open (nothing on `main` since 28 Sept) | Handoff PDF with exact steps; check-in on Tue 20 Oct; if blocked, Gary gives Wisani temporary access to run the SQL |
| Michael isn't available for acceptance | Book now; fall-back is a recorded video call plus a written sign-off |
| Two labour ledgers give two different invoice totals | Decide on 20 Oct (item 6) |
| Late submission again | Internal deadline 30 Oct, named uploader, upload checked by a second person |
| Phase 2 upload sits in the Phase 3 slot | Ask Ms Mbele this week |
