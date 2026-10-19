# Spanner code guide: understand it, demo it, defend it

Group Y "The Zealots", ITC327W. Prepared by Wisani, 20 Oct 2026, for the
Phase 3 presentation (30 of 100 marks). The rubric says every member must
"explain decisions and limitations, and answer panel questions accurately".
This guide walks through the real code; every `file:line` points at the
repo, so you can open it in front of the panel.

**How to use it:**
1. Read Part 1 (10 minutes).
2. Read Part 2 slowly, with the files open (an hour).
3. Learn your own part in Part 7.
4. Do the self-test in Part 8 without looking.

---

## Part 1. The whole system in one picture

**Spanner** is a workshop system for **Riese Auto-Clinic** (owner and head
mechanic: Michael Riese). Staff book vehicles in, record parts and labour,
move the job through five phases, and produce an invoice. Customers follow
their car's progress with a reference code, without logging in.

```
 Flutter app (phone)            ASP.NET web app (front desk / laptop)
 - staff: book in, parts,       - staff: same jobs + invoice, stock,
   labour, phase, stock           vehicle history, WhatsApp button
 - customer: "I'm a customer"   - customer: /Track page (no login)
            \                         /
             \   HTTPS, anon key +   /
              \  staff login token  /
               v                   v
        ONE Supabase project (the shared backend)
        - PostgreSQL: bookings, customers, booking_parts, stock_items,
          stock_movements, jobs, booking_labor, profiles, ...
        - Auth: staff email + password logins
        - Row Level Security: who may read/write which rows
        - Database functions (RPC): add_booking_part, update_booking_phase,
          delete_booking_and_restock, get_booking_by_reference_code, ...
        - Realtime: tells the web dashboard when data changes
        - Edge Function send-phase-notification -> Firebase -> phone push
```

**The one sentence to remember:** *"Both apps talk to the same Supabase
project, so a booking made on the phone is the same database row the web
app reads. There is no copying or syncing between the apps."*

### Words the panel may use (from the Unit 4 Beginner Guide)

| Word | Meaning in Spanner |
|---|---|
| Frontend | The screens people use: the Flutter app and the web pages |
| Backend | Supabase: database, logins, rules, functions |
| CRUD | **C**reate (book in), **R**ead (dashboard, /Track), **U**pdate (phase, finalize), **D**elete (delete booking) |
| Authentication | *Who are you?* Email + password through Supabase Auth |
| Authorisation | *What may you do?* Admin vs mechanic (`profiles.role`), and the database rules (RLS, function checks) |
| API | Both apps call Supabase's REST API (PostgREST) through its client library; database functions are called with `rpc` |
| RLS (Row Level Security) | Rules inside PostgreSQL that decide, per row, what the logged-in user (or an anonymous visitor) may do. They apply no matter which app sends the request |
| Anon key | The public key both apps ship with. It is safe to be public **because** RLS decides what it can do. Anonymous visitors can't read the tables |
| Service-role key | The master key that bypasses RLS. **Never** in the apps or GitHub; only the Edge Function uses it, on Supabase's servers |
| Transaction | Several writes that succeed or fail together. A Postgres function runs as one transaction |

---

## Part 2. Follow one booking through the code

This is the backbone of the demo (shared processes P1 and P2). For each step:
what the user does, the code that runs, and what changes in the database.

### Step 1. Staff log in

**Web:** `web/Pages/Account/Login.cshtml.cs:40`

```csharp
var session = await supabase.Auth.SignInWithPassword(Email, Password);
// ...store the access + refresh tokens in an encrypted login cookie
await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, ...);
```

- **Every page needs a login** except Login and /Track
  (`web/Program.cs:25`: `AuthorizeFolder("/")`,
  `AllowAnonymousToPage("/Account/Login")`,
  `AllowAnonymousToFolder("/Track")`).
- **Per-request sessions.** On every request,
  `web/Auth/SupabaseSessionFilter.cs:28` puts that staff member's token back
  on the Supabase client (`SetSession`). So every database query runs **as
  that person**, and RLS applies to them, not to an anonymous visitor.
- **Why the client is "Scoped".** It is registered once per request
  (`web/Program.cs:61`, `AddScoped`), so two staff members never share one
  login.

**Flutter:** `mobile/lib/features/auth/data/auth_repository.dart`
(`signInWithPassword`).

- `main.dart:51` listens to the login state (`authStateProvider`, a
  Riverpod `StreamProvider`): no session shows `RoleChoiceScreen` ("I'm a
  customer" / "I work here"), a session shows `HomeScreen`.
- The role (admin or mechanic) is read from the `profiles` table
  (`auth/providers/auth_provider.dart`, `currentProfileProvider`).

### Step 2. Book in a vehicle (Create)

**Flutter:** `book_in_screen.dart:327` `_submit()`.

1. The form validates (`validator: ... 'Required'`).
2. If the customer is new, it inserts a row into `customers`.
3. It calls `VehicleBookingNotifier.addBooking`
   (`providers/vehicle_booking_provider.dart:15`).
4. That calls the repository, `data/vehicle_booking_repository.dart:15`:

```dart
final row = await _client.from('bookings').insert({ 'brand': brand, ... })
    .select().single();          // returns the saved row, incl. database-filled columns
```

**Web:** `web/Pages/Bookings/Create.cshtml.cs:116` `OnPostAsync()`.

1. The same required fields are checked (attributes like
   `[Required]` and `[Range(1900, 2100)]`).
2. It creates the customer if needed, then inserts the booking
   (`:170`, `supabase.From<Booking>().Insert(booking)`).
3. It opens the new booking's page.

**The database fills in the rest**, so neither app can get it wrong:

- `reference_code`: `generate_reference_code()`
  (`supabase/migrations/0006...sql:44`). 8 random characters from an
  alphabet with no 0/O/1/I, so it's easy to read out over the phone. That
  is about 1 trillion combinations, and the function loops until the code
  is unique.
- `invoice_number`, `created_at`.
- `created_by`, the logged-in staff member (migration 0010, Ms Mbele's
  question).

**Same fields in both apps:** the web transmission list matches Flutter's
enum exactly (`Create.cshtml.cs`, `TransmissionOptions`: `manual`,
`automatic`, `cvt`, `semi_automatic`).

### Step 3. The other app sees it (shared process P1)

- **Web dashboard:** `web/Pages/Index.cshtml.cs:18` reads every booking
  whose `closed_at` is empty.
  - It **live-reloads**: one long-lived Realtime subscription
    (`Services/RealtimeChangeNotifier.cs`, started in `Program.cs:80`)
    hears database changes.
  - `Pages/Realtime/Stream.cshtml.cs` pushes them to every open browser
    tab (Server-Sent Events).
- **Flutter:** `VehicleBookingNotifier.build()` fetches the bookings
  **once**. Riverpod then keeps that list in memory for as long as the app
  runs (the providers aren't `autoDispose`), and the screens have **no
  pull-to-refresh**. So today, something added on the web only appears on
  the phone after the app is restarted.
- **This must be fixed before the demo** (Gary), or P1's web-to-phone half
  fails. Wrap the bookings list and the booking details in a
  `RefreshIndicator` that reloads the data:

```dart
RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(vehicleBookingProvider);              // forget the cached list
    await ref.read(vehicleBookingProvider.future);       // fetch it again from Supabase
  },
  child: /* the existing ListView */,
)
// on booking details also: ref.invalidate(bookingPartsProvider(booking.id)),
// ref.invalidate(bookingLaborProvider(booking.id)), ref.invalidate(stockItemProvider)
```

- After that fix, the phone shows web changes when staff pull down to
  refresh. The Unit 4 notes say that's enough unless real-time is a
  requirement.
- The customer screen is already fresh: every code lookup calls the
  database again.

### Step 4. Add a part: three writes that must happen together

Adding a part means three writes:
1. Lower `stock_items.quantity_on_hand`.
2. Insert a `booking_parts` row.
3. Insert a `stock_movements` row (the audit trail).

**Web:** `Details.cshtml.cs:344`, `OnPostAddPartAsync`, calls **one
database function** (`:397`):

```csharp
await supabase.Rpc("add_booking_part", new { p_booking_id = id, p_stock_item_id = ...,
    p_qty = ..., p_unit_price = stockItem.SellPrice, p_user_id = ..., p_reference = Booking.Registration });
```

`add_booking_part` (`supabase/migrations/0004...sql:50`):

```sql
update stock_items set quantity_on_hand = quantity_on_hand - p_qty
 where id = p_stock_item_id and quantity_on_hand >= p_qty;   -- only if enough stock
-- if no row changed: return (false, what is left) and stop
insert into booking_parts ...;  insert into stock_movements ...;
```

**Why a function:** a Postgres function is one transaction. Either all
three writes happen, or none do. The condition `quantity_on_hand >= p_qty`
stops two staff members from both taking the last part: the second update
changes no row and gets `ok = false`.

**Flutter** still does the three writes as separate calls
(`providers/booking_part_service.dart`). That gives the same result, but it
isn't all-or-nothing. It's on Gary's list (switch to `add_booking_part`).
The web also has a temporary fallback (`AddPartWithoutFunctionAsync`) until
migration 0009 removes an old broken copy of the function from the live
database.

**Price is "snapshotted":** `unit_price` is copied from the sell price at
that moment, so a later price change doesn't rewrite old invoices.

### Step 5. Labour

- **Web:** a job is a row in `jobs` (`OnPostAddJobAsync`). Hours and rate
  are recorded on `Jobs/Details`.
- **Flutter:** labour lines go into `booking_labor`.
- **Totals (FR-06):** booking-wide, `Details.cshtml.cs:70`:
  `PartsTotal + LabourTotal`. They are booking-wide because
  `booking_parts` has no `job_id`, so parts belong to the booking, not to
  one job.
- **Be honest if asked:** labour lives in two tables, so a web invoice and
  a mobile invoice can disagree. The group is choosing one table (proposal:
  `booking_labor`).

### Step 6. Change the phase, and the customer gets a push (shared process P2)

Five phases:
1. `booked_in`
2. `labor_in_progress`
3. `reassembly`
4. `ready_for_pickup`
5. `finalized`

The labels are identical everywhere: Flutter `booking_phase.dart`, web
`Track/Index.cshtml.cs:20`, and the push text.

Both apps call the **same database function**:

- web `Details.cshtml.cs:124`;
- Flutter `vehicle_booking_repository.dart:100`;
- the function is `update_booking_phase` (`0006...sql:71`):

```sql
if p_phase = 'finalized' then raise exception ...;   -- only Finalize may set that
update bookings set phase = p_phase where id = p_booking_id and status <> 'closed'
returning row_to_json(bookings.*) into result;        -- closed bookings can't change
```

**Then the push notification:**

1. A **Database Webhook** fires on every `bookings` update and calls the
   Edge Function `mobile/supabase/functions/send-phase-notification/index.ts`.
2. The function checks a shared secret (`:12`), so random callers are
   refused (401).
3. It does nothing if the phase didn't actually change (`:34`).
4. It reads the customer's phone tokens from `booking_push_tokens`. It uses
   the service-role key here, which is safe because it runs on Supabase's
   server, never in an app.
5. It sends the message through **Firebase Cloud Messaging**.

A customer's phone registers for these pushes when they look up their code
in the app (`push_notification_service.dart:19`, function
`register_push_token`, which refuses unknown codes).

### Step 7. Send on WhatsApp (Mr G's feedback)

`web/Services/CustomerWhatsApp.cs`:

- `ToWhatsAppNumber` (`:22`) turns `082 123 4567` into `27821234567`
  (international form, digits only). If it can't be sure of the number, it
  returns null, so WhatsApp asks staff to pick the chat instead of
  messaging a stranger.
- `Message` (`:56`) chooses the text:
  - the reference code at book-in;
  - a status update after a phase change (same labels as /Track);
  - a thank-you with the invoice number once closed;
  - plus the /Track link once the site is online (`PublicSiteUrl`).
- `Link` (`:81`) builds `https://wa.me/<number>?text=<message>`.

**Why not the WhatsApp Business API?** It charges per message and needs a
Meta business account. Our SRS has a zero-budget rule. Click-to-chat is
free, needs no keys, and a person checks the message before it's sent.

### Step 8. The customer tracks the car (no login)

- **Web:** `/Track?code=...`, `web/Pages/Track/Index.cshtml.cs:55`.
- **Flutter:** "I'm a customer", `customer_booking_repository.dart:8`.

Both call one function, `get_booking_by_reference_code`
(`0006...sql:96`):

- **`security definer`:** it runs with the function owner's rights, so the
  anonymous customer can see **this one booking** without being allowed to
  read the `bookings` table at all.
- **A narrow answer:** car, phase, parts names and quantities, labour
  lines. **No customer name, phone or email**, so a guessed code reveals
  nothing personal.
- The web page also rejects malformed codes early, and shows **the same
  message** for "wrong code" and "doesn't exist".

### Step 9. Finalize, invoice, reopen (admin)

- **Finalize** (`Details.cshtml.cs:135`) sets `status = closed`,
  `phase = finalized` and `closed_at = now`. Flutter's `close()` does the
  same, so both apps agree.
- **The admin check runs on the server** (`if (!IsAdmin) ...`), not just
  by hiding the button. A mechanic sending the form by hand is refused.
- **Migration 0011** adds the same rule **inside the database** (a trigger
  on `status`), so it holds for any app.
- **Invoice PDF:** `Services/BookingInvoiceDocument.cs` (QuestPDF, free
  Community licence). It is generated on request; nothing is stored.
- **Reopen** (`:217`) is admin only, and asks for the admin's password
  again before undoing a finalize.

### Step 10. Delete a booking (admin), with restock

`delete_booking_and_restock` (`0007...sql:20`), called from
`Details.cshtml.cs:194`:

1. It checks the caller is an admin **inside the database**.
2. It puts every part back into stock, with a `stock_movements` row.
3. It removes the labour, the parts and the booking.

It all happens in one transaction: all or nothing.

---

## Part 3. How the data is protected (likely questions)

| Threat | What stops it | Where |
|---|---|---|
| Someone opens the web app without logging in | Every page requires a login except Login and /Track | `web/Program.cs:25` |
| A logged-out person reads the tables with the public anon key | RLS: anonymous visitors get no table access (checked live, 7 Oct) | Supabase policies |
| A customer guesses a code | Random 8-character codes (~1 trillion); the lookup returns no personal data | `0006` `generate_reference_code`, `get_booking_by_reference_code` |
| A mechanic finalizes, deletes or reopens | Server check in the web app; delete checked in the database (0007); finalize/reopen in the database once 0011 is run | `Details.cshtml.cs`, `0007`, `0011` |
| Anyone changes a phase without logging in | Migration 0008 revokes anonymous access to staff functions (**must be run; open today**) | `0008` |
| Stock goes wrong when two people use the last part | Conditional update inside one transaction | `0004` `add_booking_part` |
| Secret keys leak | Keys live in user-secrets / Vercel settings, never in git; the service-role key only lives in the Edge Function | `Program.cs` comments, `.gitignore` |
| Fake calls to the push function | Shared webhook secret | `send-phase-notification/index.ts:12` |
| Supabase is down | Every page catches the error and shows a message instead of crashing (NFR-03, tested by pointing the app at a fake host) | each page's `try/catch` |

**Be honest:** a Firebase key was committed in September. The file was
removed, but the key must still be revoked (Gary). If asked, say so and
what's being done about it.

---

## Part 4. Design decisions and why (the "why did you..." questions)

| Decision | Why |
|---|---|
| **One Supabase project for both apps** | The brief requires it. It also means one source of truth: no syncing, the same rules (RLS) for both apps, free tier |
| **Supabase client library, not Entity Framework** (web) | It uses the same API and the same RLS as Flutter, as the logged-in user. EF would connect straight to Postgres with one powerful account and bypass RLS |
| **Razor Pages, not MVC** | The other official ASP.NET Core style: each page = view (`.cshtml`) + handler (`.cshtml.cs`, the controller part). Simpler for page-based forms. `Models/` and `Services/` as in MVC |
| **Riverpod** (Flutter) | Keeps data loading and state out of the screens: screens `watch` providers; providers call repositories; repositories talk to Supabase |
| **Database functions for multi-step changes** | All-or-nothing (transactions) and the same logic for both apps, instead of two copies |
| **Customers don't log in** | Michael's requirement (Phase 1 Change 5, softened by Change 7 at Ms Mbele's request): a reference code is enough, with five broad stages and no time estimates, so no false expectations |
| **WhatsApp click-to-chat** | Free (zero-budget rule), no keys, staff check the message before sending |
| **Booking-wide invoice** | Parts aren't linked to a single job in the schema (`booking_parts` has no `job_id`) |
| **Hosting on Vercel** | Free, a public address for /Track and the WhatsApp link; the web app runs as a container (`web/Dockerfile.vercel`) |

---

## Part 5. Known limitations (say them before they're found)

The rubric rewards explaining limitations. Say these confidently:

1. **Two labour tables** (`jobs` on the web, `booking_labor` on Flutter).
   Being merged into one.
2. **Flutter doesn't live-update**; staff pull down to refresh (once Gary
   adds pull-to-refresh, see Part 2 Step 3). The web dashboard does
   live-update.
3. **Push notifications are Android only** (Firebase is set up for Android).
4. **Flutter adds a part in three calls**, not one transaction (fix in
   progress).
5. **The admin role is read from two places** (web: a list of admin
   emails; Flutter: `profiles.role`). The web is moving to `profiles`.
6. **Vercel's container hosting is a beta** and sleeps after 5 idle
   minutes: the first page is slow and staff may have to log in again. We
   have a laptop back-up.
7. Anything from migrations 0008-0011 **not yet run** on the day.

---

## Part 6. Questions the panel is likely to ask, with answers

**Q: How do the two apps share data?**
They use the same Supabase project and the same tables. A booking made on
the phone is a row in `bookings`; the web dashboard reads that same row.
There is no copying between the apps.

**Q: Show us where Flutter connects to Supabase.**
`mobile/lib/main.dart:21`, `Supabase.initialize(url, anonKey)` from the
`.env` file. Then `Supabase.instance.client.from('bookings')...` in the
repositories.

**Q: And ASP.NET?**
`web/Program.cs:61` creates a `Supabase.Client` per request from the
`Supabase:Url` and `Supabase:AnonKey` settings (user-secrets or Vercel
environment variables, never in git).

**Q: What's the difference between authentication and authorisation in your system?**
Authentication: Supabase Auth checks the email and password. Authorisation:
what that person may do. That's admin vs mechanic, plus the database
rules: RLS, and the admin checks inside `delete_booking_and_restock` and
0011.

**Q: What stops a mechanic from finalizing by changing the request?**
The web handler checks `IsAdmin` on the server before doing anything
(`Details.cshtml.cs:135`). Delete is also checked in the database (0007).
Finalize and reopen get the same database check with 0011.

**Q: How is the reference code created? Can it be guessed?**
The database generates it (`generate_reference_code`): 8 characters from
32 easy-to-read letters and digits, about 1 trillion possibilities, and
unique. Even a right guess shows only the car and its progress, no
personal details.

**Q: Why does the customer lookup work without a login if the tables are locked?**
It's a `security definer` function. It runs with its owner's rights, finds
one booking by exact code, and returns only safe fields. The customer can
call the function, not read the table.

**Q: What happens if two people add the last part at the same time?**
`add_booking_part` only lowers the stock "where quantity_on_hand >= the
amount". The second update changes no row, so it returns `ok = false`, and
the web shows "only N left". It all runs in one transaction.

**Q: How does the push notification work?**
1. A phase change updates `bookings`.
2. A database webhook calls our Edge Function.
3. The function checks the secret, reads the customer's phone tokens and
   sends through Firebase Cloud Messaging.
4. The phone registered its token when the customer looked up their code.

**Q: Is it real-time?**
The web dashboard is: a Supabase Realtime subscription pushes changes to
the browser. Flutter reloads when staff pull down to refresh. The Unit 4
notes say a refresh is acceptable unless real-time is a requirement.

**Q: Show us validation.**
- Web: the attributes on `Create.cshtml.cs` (`[Required]`,
  `[Range(1900, 2100)]` for the year).
- Flutter: the `validator:` functions in `book_in_screen.dart`.
- Demo: leave the registration empty and press Save.

**Q: Why not the WhatsApp API?**
It costs per message and needs a business account. Our SRS sets zero
budget. Click-to-chat is free, and staff check the message first.

**Q: Where are the keys?**
Not in the code. The web reads them from user-secrets locally and from
Vercel's environment variables online. Flutter reads the URL and the
**anon** key from `.env`, which is public by design. The service-role key
is only an Edge Function secret on Supabase.

**Q: What would you improve?**
- One labour table.
- Live updates in Flutter.
- Push on iPhone.
- A stored `invoices` table (invoices are generated on request today).
- Parts linked to individual jobs.
- Customer self-service booking requests.

**Q: What was the hardest problem?**
Pick a real one:
- the two labour tables;
- the old copy of `add_booking_part` that broke the web (error 42804);
- finding that a phase could be changed without a login, by testing with
  the public key.

Say what you found, how you found it, and the fix.

---

## Part 7. Who presents what, and what you must know

A proposal. Agree it on Tuesday. Everyone should still read Parts 1-6:
the panel can ask anyone anything.

| Who | Presents | Must be able to open and explain |
|---|---|---|
| **Khumo** | Introduction: client, problem, architecture, one Supabase project; schedule | Part 1 picture; `web/Program.cs:61`; `mobile/lib/main.dart:21`; MS Project |
| **Gary** | Flutter: login, book in, parts, labour, phase | `main.dart`, `book_in_screen.dart:327`, `vehicle_booking_repository.dart`, `booking_detail_screen.dart`; Riverpod |
| **Ofentse** | Web: dashboard, booking page, invoice, stock, vehicle search | `Pages/Index`, `Pages/Bookings/Create` and `Details`, `Services/BookingInvoiceDocument.cs`, Razor Pages structure |
| **Breyton** (+ Gary) | **P1:** book in on the phone, see it on the web, add a part on the web, see the part and lower stock on the phone | Part 2 Steps 2-4; `add_booking_part` |
| **Kea** (+ Wisani) | **P2:** phase on the web, WhatsApp, the customer sees it (app or /Track), phase on the phone, /Track updates | Part 2 Steps 6-8; `update_booking_phase`, `get_booking_by_reference_code`, `CustomerWhatsApp.cs` |
| **Denny** | Security and roles, data consistency, known limitations | Parts 3 and 5; 0007, 0008, 0011 |
| **Wisani** | Hosting, GitHub, handling questions with the others | Vercel, README, migrations |

**Two-minute talk structure** for anyone:
1. What the user needs.
2. Show it working.
3. Open the one file that does it, and point at the key line.
4. Name the table it changes.
5. Name one limitation.

---

## Part 8. Self-test (answers at the end; don't peek)

1. Which file makes every web page require a login, and which two
   exceptions are there?
2. Why is the web Supabase client "Scoped" instead of a single shared one?
3. Name the three writes that happen when a part is added, and why they're
   in one function.
4. Which column does the database fill in when a booking is created that
   lets a customer track it? How is it generated?
5. Which phase can `update_booking_phase` never set, and why?
6. What does `security definer` mean for the customer lookup?
7. Which table holds labour on the web, and which on Flutter?
8. What does the Edge Function check before sending a push?
9. What does `ToWhatsAppNumber("082 123 4567")` return?
10. Which key is safe to ship inside the app, and which must never be?
11. Where is the admin check for deleting a booking enforced?
12. Name two known limitations.

**Answers:**

1. `web/Program.cs:25`; `/Account/Login` and `/Track`.
2. So each request runs as its own logged-in staff member and RLS applies
   to them; logins are never shared.
3. Lower stock, insert `booking_parts`, insert `stock_movements`. One
   function means one transaction, so all or nothing.
4. `reference_code`: 8 random readable characters, unique,
   `generate_reference_code()`.
5. `finalized`. Only Finalize & close sets it, together with
   `status = closed`.
6. It runs with the owner's rights, so the customer gets one booking's safe
   fields without access to the table.
7. Web: `jobs`. Flutter: `booking_labor`.
8. The webhook secret, and that the phase actually changed.
9. `27821234567`.
10. Safe: the anon key (RLS protects the data). Never: the service-role key.
11. Inside the database function `delete_booking_and_restock` (0007), plus
    the web's server check.
12. Any two from Part 5.
