# Unit 4 readiness: Spanner against the Assessment 3 checklist

Group Y "The Zealots", ITC327W. Prepared by Wisani, 18 Oct 2026, from the
Unit 4 notes on eThuto: Overview, Beginner Guide, Activities 4.2, 4.3 and
4.4, and the Group Progress Checkpoint, plus the Phase 3 rubric and
progress tracker (19 Oct). **Activity 4.1** (Supabase set-up) wasn't among
the files; someone please download it too.

## What Phase 3 actually is

- **Assessment 3: System Development, Implementation and Final
  Demonstration, 50%.** Due Mon 2 Nov; presentations 2-6 Nov.
- Unit 4 is **building and integrating**: Flutter and ASP.NET on **one
  Supabase backend**, with **at least two important processes that work
  across both apps**, shown live to the panel.
- **Formal testing is Unit 5, not now.** The checkpoint says: "You do not
  need to prepare a formal test plan, test cases or a defect log for this
  checkpoint." What it wants instead is the **initial function checks**
  tables, an **integration problems** record, and **evidence**
  (screenshots or short recordings, Supabase records, GitHub commits).
- Same SRS, same repo, same MS Project file, same tracker. No new SRS or
  repo. Approved changes made during building go into the SRS change log.
- Two rules the panel will check: **no secret or service-role keys** in the
  apps, GitHub or evidence; and **access rules enforced by the database**,
  "rather than relying only on hiding buttons or pages".

**Where we stand:** most of what Unit 4 asks for is already built, because
we built ahead of the design in Phases 1 and 2. The work now is:

1. fix the integration gaps listed in section 6;
2. prove everything with evidence;
3. fill in these tables in the SRS and tracker;
4. rehearse the demo.

Status key: **Built** = in the code on `main`; **Live-checked** = seen
working against the real Supabase project, with evidence; **Gap** = not
working or not consistent yet.

## How Phase 3 is marked (rubric, received 19 Oct)

Three lecturers each mark out of 100, and the panel average is halved to give
the mark out of 50. Our honest position today and what moves each line up:

| Criterion | Marks | "Excellent" needs | Where we are (19 Oct) | What gets us there | Owner |
|---|---|---|---|---|---|
| Shared Supabase Backend | 15 | ERD implemented with keys and relationships; required operations; authentication and access controls work; one shared project | Tables, keys and functions live and shared; access rules not fully enforced (0008, 0011 not run) | Run 0009, 0004, 0008, 0010, 0011; show the Table Editor and the check queries | Gary |
| Flutter Mobile Application | 15 | Main screens, navigation, forms and functions work reliably on Supabase; access follows the SRS | All main screens built (on main since 28 Sept) | WhatsApp button, add part in one step, web build; screenshots of every screen | Gary; Breyton (checks) |
| ASP.NET Web Application | 15 | Same, for the web pages | All pages built; WhatsApp done | Live on Vercel; one labour ledger; admin role from profiles; screenshots of every page | Wisani; Ofentse (checks) |
| Integration and Functional Correctness | 15 | Same Supabase records; **two shared processes work end to end**; consistent retrieval, updates and permitted access | P1 and P2 built, not yet recorded; labour values differ between the apps | Fix the section 6 problems; record P1 and P2 | Wisani, Gary; Kea (recording) |
| Final SRS and Implementation Evidence | 5 | Existing SRS continued with an implementation section, **requirement-to-function status**, screenshots, approved changes, known limitations, **GitHub link and MS Project screenshot** | Tables drafted in this file | SRS v3.0: sections 1-6 of this file + screenshots + change log + limitations | Wisani; Denny, Ofentse |
| Microsoft Project, GitHub and Progress Tracker | 5 | Schedule shows actual progress; **GitHub and the submitted ZIP hold the demonstrated version** with setup guidance; tracker has tasks, contributions, challenges and the **final group reflection** | Tracker filled 19 Oct; MS Project not yet updated for Phase 3; GitHub behind (uploads pending) | Khumo: MS Project; everyone: own Individual Contributions rows; upload the final code; group reflection 29 Oct | Khumo; everyone |
| Final Presentation and Live Demonstration | **30** | Clear live demo of Flutter + ASP.NET + Supabase incl. **two shared processes**; **every member participates meaningfully**, explains decisions and limitations, answers questions | Demo flow defined (section 9) | Each member presents a part; rehearse Sat 31 Oct; everyone able to explain any part | Everyone |

Two things that cost marks easily:
- **The ZIP and GitHub must match what we demo.** Freeze the code on Thu
  29 Oct, upload it, and zip that same version.
- **Participation is marked.** Seven people, seven parts of the demo
  (a proposal; agree it on Tuesday):

| Part | Who |
|---|---|
| Introduction, architecture, one shared Supabase project | Khumo |
| Flutter app: book in, parts, labour, phase | Gary |
| Web app: dashboard, booking, invoice, stock, search | Ofentse |
| Shared process P1 (phone → web → phone) | Breyton and Gary |
| Shared process P2 (web → WhatsApp → customer → phone → /Track) | Kea and Wisani |
| Access rules, data consistency, known limitations | Denny |
| Questions | Everyone |

## 1. Mobile functions (Activity 4.2, Step 1)

| Mobile function | Requirement / use case | Screen (`mobile/lib/features/`) | Status |
|---|---|---|---|
| Staff sign in, role from `profiles` | FR-12, Login | `auth/presentation/login_screen.dart`, `role_choice_screen.dart` | Built |
| Dashboard / home | Login includes Dashboard | `home/presentation/home_screen.dart` | Built |
| Book in a vehicle (customer + vehicle details, validation) | FR-01, Book in a vehicle | `bookings/presentation/book_in_screen.dart` | Built |
| View and search bookings | FR-11, Search bookings | `bookings_list_screen.dart` | Built |
| Booking details: add labour, add or remove parts | FR-02, FR-04, FR-05, FR-06 | `booking_detail_screen.dart` | Built (labour ledger gap, section 6) |
| Change the booking phase | FR-15, Update booking phase | `booking_detail_screen.dart` | Built |
| Finalize, delete (restock), reopen: admin only | FR-17, FR-18 | `booking_detail_screen.dart` | Built |
| Invoice PDF | FR-07, FR-08 | `bookings/data/invoice_pdf_service.dart` | Built |
| Stock list, add item, restock, categories and suppliers | FR-03, FR-10 | `stock/presentation/*` | Built |
| Customer: track repair by reference code | FR-14, Track repair status | `customer/presentation/customer_lookup_screen.dart`, `customer_status_screen.dart` | Built |
| Customer: phase push notifications | FR-16 | `customer/data/push_notification_service.dart` | Built (Android only) |
| Send reference code on WhatsApp | Mr G, 16 Oct | `booking_detail_screen.dart` | **Gap: Gary building it** |

## 2. Web functions (Activity 4.3, Step 1)

| Web function | Requirement / use case | Page (`web/Pages/`) | Status |
|---|---|---|---|
| Staff sign in (Supabase Auth); admin vs mechanic | FR-12, Login | `Account/Login` | Built, live-checked M1 |
| Dashboard: open bookings, stock levels, live reload | Dashboard, FR-09, FR-10 | `Index` | Built |
| Book in a vehicle, customer auto-fill | FR-01 | `Bookings/Create` | Built, live-checked M2 |
| Booking details: jobs, parts, totals | FR-02, FR-04, FR-06 | `Bookings/Details` | Built, live-checked M3/M4 |
| Labour hours and rate, complete a job | FR-05 | `Jobs/Details` | Built (labour ledger gap) |
| Change the booking phase | FR-15 | `Bookings/Details` | Built, needs logged-in check |
| Send on WhatsApp (code, updates, thank-you) | Mr G, 16 Oct | `Bookings/Details`, `Services/CustomerWhatsApp.cs` | Built, needs logged-in check |
| Finalize, delete (restock), reopen: admin only | FR-17, FR-18 | `Bookings/Details`, `Bookings/Closed` | Built |
| Invoice PDF | FR-07, FR-08 | `Bookings/Invoice` | Built, live-checked M5 |
| Stock list and add a part | FR-03, FR-10 | `Stock/Index`, `Stock/Create` | Built, live-checked M3 |
| Vehicle history search + Wikimedia picture | FR-11, FR-13 | `Vehicles/Search` | Built, live-checked M6 |
| Customer tracking page, no login | FR-14 | `Track/Index` | Built, live-checked 7 Oct |

Note for the panel: the notes use MVC (Models/Views/Controllers) as the
example. We use **Razor Pages**, the other ASP.NET Core approach: each page
has its view (`.cshtml`) and its handler (`.cshtml.cs`, the controller part),
with `Models/` and `Services/` alongside. That was our approved design, so
it's fine, but be ready to explain it.

## 3. Shared processes (Activity 4.4, Steps 1 and 4)

We need at least two, ideally with information flowing both ways. We have
four; demo **P1 and P2**, keep P3 and P4 as back-up.

| # | Shared process | Action in Flutter | Action in ASP.NET | Shared information | Status |
|---|---|---|---|---|---|
| **P1** | Book-in reaches the other app | Staff book in a car | The booking appears on the dashboard; staff open it | `bookings`, `customers` | Built; record it |
| **P2** | Repair progress reaches the customer | Customer enters the reference code and sees the phase; push arrives | Staff change the phase (and Send on WhatsApp) | `bookings.phase`, `reference_code`, `booking_push_tokens` | Built; needs 0008 run first |
| P3 | Parts and stock stay in step | Mechanic adds a part to a booking; stock drops | Stock page shows the new quantity; part is on the web invoice | `booking_parts`, `stock_items`, `stock_movements` | Web add-part needs 0009 |
| P4 | Admin closes the job | Booking moves to closed; customer sees "Finalized" | Admin finalizes; invoice PDF | `bookings.status`, `phase`, `closed_at` | Built |

**P1 demo, both directions:**
1. Book in a car on the phone.
2. Refresh the web dashboard: the car is there.
3. On the web, add a part.
4. Reopen the booking on the phone: the part is there and the stock has
   dropped.

**P2 demo:**
1. On the web, move the booking to *Labor in progress* and tap Send on
   WhatsApp.
2. On a second phone, the customer gets the message.
3. The customer opens the app's *I'm a customer* screen (or the `/Track`
   link) and sees step 2 of 5.
4. Move it to *Ready for pickup* on the phone app.
5. Refresh `/Track` on the web: step 4.

## 4. Same backend and consistent data (Activity 4.4, Steps 2 and 3)

| Item | Flutter | ASP.NET |
|---|---|---|
| Supabase project | `.env` `SUPABASE_URL` | user-secrets / Vercel env `Supabase__Url` (must be the same project) |
| Key used | anon (publishable) key only | anon key only; each request carries the staff member's own login |
| Tables | same tables | same tables |
| Authentication | Supabase Auth, role from `profiles.role` | Supabase Auth; admin from the `AdminEmails` setting |

| Field | Values both apps use | Consistent? |
|---|---|---|
| `bookings.status` | `checked_in`, `closed` | Yes |
| `bookings.phase` | `booked_in`, `labor_in_progress`, `reassembly`, `ready_for_pickup`, `finalized` (same labels as `/Track`) | Yes |
| Finalize | `status=closed`, `phase=finalized`, `closed_at=now` | Yes |
| Reopen | `status=checked_in`, `phase=ready_for_pickup`, `closed_at=null` | Yes |
| `reference_code`, `invoice_number` | generated by the database, read by both | Yes |
| **Labour** | Flutter writes `booking_labor`; web writes `jobs.labour_hours x labour_rate` | **No: two invoices can differ** |
| **Admin role** | Flutter reads `profiles.role`; web reads an email list | **Partly: two sources of truth** |
| Adding a part | Flutter: three separate calls; web: one database function (`add_booking_part`) | Same result, but Flutter isn't all-or-nothing |

## 5. Roles and access (Activity 4.4, Step 5)

| User | Expected | Enforced by the database? |
|---|---|---|
| Mechanic (both apps) | Book in, parts, labour, phase, stock; **no** finalize, delete or reopen | Delete: yes (0007). Finalize and reopen: yes once **0011** is run (until then, hidden buttons only) |
| Admin (both apps) | Everything, incl. finalize, delete (restock), reopen | Yes |
| Customer (no login) | Only their own booking, by reference code | Yes: lookup function only, no table access |
| Anyone without a login | Nothing staff-only | **Yes, checked live 20 Oct:** no rows readable; `update_booking_phase`, `add_booking_part` and `delete_booking_and_restock` refused (0008 live) |

The notes say access must be enforced by the database, "rather than relying
only on hiding buttons". Two fixes:

- **0008:** done; confirmed live 20 Oct (`evidence/live-checks-2026-10-20.md`).
- **Finalize and reopen** (admin only): migration **0011** adds the same
  admin check as 0007. Written and tested on a local Postgres (mechanic
  refused, admin allowed, phase changes unaffected); Gary to run it.

## 6. Integration problems (Activity 4.4, Step 6): goes into Challenges & Actions

| # | Problem | Cause | Action | Who | Status |
|---|---|---|---|---|---|
| 1 | Web "Add part" fails (error 42804) | Old text version of `add_booking_part` still in the database | Run 0009 then 0004 | Gary | Open (web has a temporary workaround) |
| 2 | Phase can be changed without a login | Postgres lets everyone run new functions by default | Run 0008 | Gary | **Fixed** (confirmed live 20 Oct) |
| 3 | Web and mobile invoices can show different labour | Two labour tables (`jobs` vs `booking_labor`) | Decide Tue 20 Oct; proposal: keep `booking_labor`, move the web over | Wisani + Gary | Open |
| 4 | Admin role read from two places | Web uses an email list, mobile uses `profiles.role` | Web reads `profiles.role` too | Wisani | Open |
| 5 | Finalize and reopen only blocked by hidden buttons | No database check | Migration 0011 (admin check, like 0007): written and tested 18 Oct | Gary runs it | Fix ready |
| 6 | Mobile add-part isn't all-or-nothing | Three separate calls | Switch mobile to the `add_booking_part` function | Gary | Open |
| 7 | Push setup throws in the Flutter web build | No `kIsWeb` check | One-line guard | Gary | Open |
| 8 | Who booked a car in wasn't recorded (Ms Mbele) | No column | 0010 `created_by` | Gary runs it | Open |
| 9 | Leaked Firebase key in git history | Key file was committed in Sept | Revoke the key | Gary | Open since 29 Sept |
| 10 | Mobile doesn't live-update | No Realtime subscriptions in mobile | Accept: the notes say a refresh is fine unless real-time is a requirement. Record as a limitation | - | Accepted |
| 11 | Flutter never reloads bookings or parts after the first load | Riverpod providers cache the list; no pull-to-refresh | Add `RefreshIndicator` + `ref.invalidate` (code guide, Part 2 Step 3) | Gary | Open (found 20 Oct). **Needed for P1** |

## 7. Initial function checks (4.2 and 4.3, Step 7)

Fill in with **dummy data** (e.g. customer "Test Customer", phone 060 000
0000), never a real customer. Each tester keeps a screenshot per row.

| Check | Flutter (Breyton) | ASP.NET (Ofentse) | Action required |
|---|---|---|---|
| App launches | | | |
| Main screens/pages display | | | |
| Navigation works | | | |
| Forms validate (leave a required field empty) | | | |
| Connects to Supabase | | | |
| Records saved (book in, add part) | | | |
| Records retrieved (list, search, `/Track`) | | | |
| Login works | | | |
| Access restrictions (mechanic can't finalize; logged-out user is sent to login) | | | |

## 8. Evidence to collect (keep in `project-docs/phase-3/evidence/`)

| Evidence | Who | By |
|---|---|---|
| Flutter screenshots: every screen in section 1 | Breyton | Sun 25 Oct |
| Web screenshots: every page in section 2 | Ofentse | Sun 25 Oct |
| Screen recording of P1 and P2 (phone + laptop side by side) | Kea | Tue 27 Oct |
| Supabase Table Editor screenshots: the test booking before and after each step (**hide keys and personal data**) | Gary | Tue 27 Oct |
| The 3 check-query results after 0008/0009/0010 | Gary | Wed 21 Oct |
| GitHub commit history per member (Insights > Contributors) | Wisani | Thu 29 Oct |
| MS Project with Unit 4 tasks + screenshot | Khumo | Thu 29 Oct |
| Tracker: Task Progress, Individual Contributions, Challenges & Actions (section 6), Phase Summary, Group Reflection | Everyone; Wisani collects | Thu 29 Oct |

## 9. Final demonstration (checkpoint list)

1. Flutter app running (phone, plus the Vercel web build as back-up).
2. ASP.NET app running (Vercel, plus a laptop as back-up).
3. Main functions in each app: book in, part, labour, phase, invoice, stock,
   search.
4. Both apps on the same Supabase project (show the Table Editor).
5. **P1 and P2** live.
6. Data saved, retrieved and updated correctly: show the row change in
   Supabase.
7. Honest current state and known limitations (anything left open in
   section 6).

Rules for the day:
- Dummy data only.
- No keys on screen.
- Open the Vercel addresses 2 minutes early.
- Everyone can explain any part: how the apps connect to Supabase, CRUD,
  authentication vs authorisation, RLS.
