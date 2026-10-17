# Spanner: Team Update, 17 October 2026

Group Y "The Zealots", ITC327W. From Wisani.
**Attached:** Gary handoff PDF (Gary), Phase 3 plan (`project-docs/phase-3/phase-3-plan.md`).
**Phase 3 is due Monday 2 November. We submit on Friday 30 October.** Presentations are 2-6 Nov.

---

Hi all. Here's what I changed since the presentation on Friday, and what's next.

**All the presentation feedback is done** (files on GitHub in `submission/presentation/` and `project-docs/phase-2/`):

1. **Customer use case (Mr G):** customers now have their own use cases. *Track repair status* includes *Check the reference code in Supabase* and *View phase, parts and labour*; *Code not found* extends it; plus *Get phase updates* and *Receives WhatsApp message*. New table `use-case-traceability.md`: for every use case, what the user types in, which code runs it, which table it touches. That's the "not just two stick men" point. Read it before the final presentation.
2. **Communication with the client in the sequence diagrams (Mr G):** new sequence diagram 5 (customer updates: phase change, push, WhatsApp, `/Track`). Book-in (Flutter and web) and finalize now end with the WhatsApp message to the customer.
3. **WhatsApp with the reference code (Mr G):** the web booking page has a **Send on WhatsApp** button. It opens WhatsApp with the message typed in: the code at book-in, a status update after each phase change, a thank-you with the invoice number at the end. It uses WhatsApp's free click-to-chat link, not the paid API, so it's still zero budget. Gary is to add the same button to the mobile app.
4. **ERD signs and lines (Ms Mbele):** redrawn with proper crow's-foot ends, no crossing lines, and a legend. Her question "who is logged in doing this?" is answered: new `created_by` link from staff (auth users) to bookings (migration 0010, Gary to run).
5. **Riese on Google (Mr G):** public pages are now titled "Riese Auto-Clinic", with a search description. Getting onto Google Search and Maps needs a free **Google Business Profile**, which only Michael can verify. Step-by-step guide: `google-business-profile.md`. **Denny**, please go through it with Michael.
6. **Late submission evidence:** MS Project corrected (submission done 14 Oct, presentation 16 Oct, feedback tasks added, 81% complete) and the Progress Checker updated (tasks U3-38 to U3-47, the presentation in Stakeholder Engagement, three new challenges). Both ready to send to Ms Mbele.

**Going live (new):** I've set up Vercel so the system runs on a real address for Phase 3:

- Web app: **riese-auto-clinic.vercel.app** (staff login and the customer `/Track` page). The project is ready; I'm deploying it this weekend.

- Flutter app built for the web: **riese-auto-clinic-app.vercel.app**, once Gary's two small mobile changes are in.

From then on, the WhatsApp message gives customers a direct tracking link. Plan: `project-docs/phase-3/hosting-on-vercel.md`.

**Two things to know:**

- Our Phase 2 files went into the **"Assessment 3"** (Phase 3) slot on eThuto. I'm asking Ms Mbele to sort it out so it doesn't count as our Phase 3 attempt.

- eThuto has posted the Phase 3 rubric and tracker. I'll put them in `project-docs/phase-3/brief/` and check the plan against them.

**What I need from each of you this week:**

| Who | What | By |
|---|---|---|
| **Gary** | Revoke the Firebase key; run the four SQL files; mobile WhatsApp button and web build. All in the attached PDF | 19 / 21 / 24 Oct |
| **Denny** | Book Michael's acceptance visit (aim for Sat 24 Oct) and go through the Google Business Profile with him | Book by Tue 20 Oct |
| **Kea** | Test plan: one test case per requirement (FR-01 to FR-18, NFR-01 to NFR-07) | Thu 22 Oct |
| **Khumo** | Phase 3 tasks into MS Project from the plan | Tue 20 Oct |
| **Ofentse** | Test the web app on the Vercel address once it's up (I'll send the link) | from Tue 20 Oct |
| **Breyton** | Test the Flutter web build and the APK on your phone | from Sun 25 Oct |
| **Everyone** | Tuesday meeting: agree the Phase 3 plan and decide on **one labour ledger** (mobile's `booking_labor` vs web's `jobs`; the two invoices can disagree right now) | Tue 20 Oct |

Please read the Phase 3 plan before Tuesday and tell me if your dates don't work.
