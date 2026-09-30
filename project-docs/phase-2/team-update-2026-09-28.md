# Spanner: Team Update, 28 September 2026

Group Y "The Zealots", ITC327W. From Wisani.
Live tracker: https://claude.ai/artifact/3TeRkof9dpEMUGjAiz2iDo
Design examples and status: https://claude.ai/artifact/4j8EwFJ9KL3tC9GujFSBov
GitHub: https://github.com/BlackZ3ro/Spanner-Riese-Auto-Clinic (pull request #15)
Phase 2 due **12 October** (14 days). Presentation and defence: 30 of the 100 marks.

## Big news: the mobile app caught up

Gary pushed a major mobile update on 28 Sept:

- **Real login** through Supabase. Your role (Admin or Mechanic) now comes from your account, not a picker.
- **Customer lookup, no login** (our consultation feature, U3-21): customers tap "I'm a customer", enter their reference code, and see their car's stage, parts and labour.
- **Five booking phases** (Book-in, Labour, Reassembly, Ready for pickup, Finalized), with a **push notification** to the customer whenever the phase changes.
- **Admin-only actions** on mobile: Finalize, Delete and Reopen.

## What I fixed on top of it (in PR #15)

- **Security:** a Firebase private key had been committed to the repo. I removed it, and Gary is revoking it. **Never commit keys, passwords or service-account files.** The logins shared in the chat should also be changed after testing.
- **Web and mobile now agree on phases.** Finalizing on the web marks the car as Finalized for the customer. Before this, the customer kept seeing the old stage.
- **Agreed permissions are now in both apps:** only Admin can finalize, delete, reopen, and remove parts or labour. Both roles can restock and update the phase.
- **Deleting a booking** is now one safe database step on both apps (stock can't get out of sync), and the database itself refuses non-admins.
- **Database record:** the schema Gary built in the dashboard is now written down as migrations 0006 and 0007, so the ERD can show it.

## Diagrams: what changed and what you need to do

- The use case diagram has a new shared oval, **"Update booking phase"**. The customer's "Check repair status" is now a real, built feature.
- **Editable draw.io files for every diagram** are in `project-docs/phase-2/diagrams/editable`. Open one at app.diagrams.net, make it your own, then **File > Save as > Google Drive** and share the link. The brief only counts editable links; PNGs don't count.
- **ERD (Gary):** add `profiles`, `booking_push_tokens`, and the `phase` and `reference_code` columns on `bookings`.

## Done so far

Phase 1 (80%). Web app M0 to M8. Admin rules on web and mobile. Mobile login, customer lookup and notifications. Consultation held and applied. Reference diagrams (use case plus five sequence diagrams) with editable sources. Tracker v9.

## What's left, and who owns it

| Task | Owner | Due |
|---|---|---|
| Revoke the leaked Firebase key (urgent) | Gary | 29 Sep |
| Run migration 0007, check 0006 with `supabase db pull`, build the mobile fixes | Gary | 1 Oct |
| Redraw the architecture diagram + share link | Ofentse | overdue |
| Redraw the use case + sequence diagrams from the draw.io files + share links | Ofentse & Breyton | overdue (26 Sep) |
| ERD redraw incl. new tables + share link | Gary | overdue |
| Flutter wireframes: editable source link | Gary | overdue |
| Navigation flow diagram | Kea | overdue |
| Design-alignment table | Denny | overdue (27 Sep) |
| Reconfirm requirements with Michael Riese | Denny | now |
| Merge everything into the SRS (one PDF) | Wisani | 30 Sep |
| Microsoft Project update + screenshot | Khumo | 3 Oct |
| Tracker top-up + Phase 2 reflection | Wisani | 8 Oct |
| Presentation rehearsal: everyone explains the whole design | Everyone | week of 6 Oct |

**Please** update your task in the live tracker when you start and when you finish, and drop your share link in the group the same day. The SRS merge on 30 Sept needs your links, not screenshots.

## Testing before we merge PR #15

Log in on the web as a mechanic: there should be no Finalize, Delete or Reopen. Log in as admin: all three work, and the booking page shows the phase and the customer reference code.
