# Phase 3 plan (final phase)

Group Y "The Zealots", ITC327W. Drafted by Wisani, 17 Oct 2026.

**Phase 3 = Assessment 3, 50% of the module, due Monday 2 November 2026.
Presentations are in the week of 2-6 November** (Ms Mbele's announcement).
It continues the same SRS, designs, schedule, tracker and GitHub repo.

**Our internal deadline is Friday 30 October**, two days early, with one
named person uploading (Wisani; back-up Khumo). Phase 2 went in late; this
time we don't leave it to the last evening.

## 0. Before anything else

- **Get the Phase 3 brief and rubric.** eThuto posted "Rubric: Phase 3" and
  "Progress Tracker Phase 3". Wisani downloads both and puts them in
  `project-docs/phase-3/brief/`. This plan follows what Phase 3 normally
  asks for (a working system, testing, deployment, user documentation, final
  presentation); once we have the rubric, check every line against it and
  fix this plan.
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
| 7 | Test plan and test cases (one per FR-01 to FR-18 and NFR-01 to NFR-07: steps, expected result, actual result, pass/fail, screenshot) | Kea | Wisani | Thu 22 Oct (plan), Tue 27 Oct (results) |
| 8 | Run the tests on the live system: web (Ofentse), mobile and Flutter web (Breyton), customer tracking + WhatsApp (Kea) | Ofentse, Breyton, Kea | Kea | Tue 27 Oct |
| 9 | **Acceptance test with Michael Riese**: he books in a real car, follows it on `/Track`, gets the WhatsApp message, and signs off (or lists changes). Also: help him set up the Google Business Profile | Denny | Wisani | Sat 24 Oct (book the visit now) |
| 10 | User guide for staff (book in, parts, phase, WhatsApp, invoice, stock) and a one-page customer card ("how to track your car") | Denny + Ofentse | Kea | Tue 27 Oct |
| 11 | Microsoft Project: Phase 3 tasks, owners, links; status date; final screenshot | Khumo | Wisani | Tue 20 Oct (plan), Thu 29 Oct (final) |
| 12 | Progress Checker for Phase 3 (the new eThuto version), Individual Contributions **filled in by each member** | Everyone, Wisani collects | Khumo | Thu 29 Oct |
| 13 | Final SRS (v3.0): Phase 3 section with deployment, testing results, acceptance, user guide, final reflection, updated change log and risks | Wisani | Denny | Thu 29 Oct |
| 14 | Final presentation: deck, live demo script on the Vercel address, Mr G's WhatsApp demo, everyone able to explain the whole system | Everyone (deck: Khumo + Breyton) | Wisani | Rehearse Sat 31 Oct |
| 15 | Submit on eThuto | Wisani (back-up Khumo) | - | **Fri 30 Oct** |

## 3. Week by week

**Week 1, 17-23 Oct: get everything working on the real address**

- Brief and rubric downloaded; Ms Mbele asked about the Assessment 3 slot.
- Gary: Firebase key, migrations, then the mobile changes.
- Wisani: web app on Vercel; smoke test.
- Tuesday meeting: decide the labour ledger, agree this plan, Khumo puts it
  in MS Project.
- Kea: test plan. Denny: book Michael's visit.

**Week 2, 24-30 Oct: test, accept, document, submit**

- Flutter web build online. Ledger change built.
- Tests run and recorded on the live system; bugs fixed by Tuesday 27.
- Michael's acceptance test (aim for Saturday 24).
- User guide, final SRS, MS Project, tracker.
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
