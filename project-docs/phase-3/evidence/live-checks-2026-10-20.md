# Live checks against the shared Supabase project, 20 Oct 2026

Run by Wisani from a development machine with the project's URL and
**public (anon) key only**. The keys were held in web user-secrets and the
git-ignored `mobile/.env`, never committed. No staff login was used, so these
checks cover only what an anonymous visitor (or someone holding the public
key from the app) can do. Every call used a random ID, so no data was read
or changed.

## Database access rules (Supabase REST API, public key)

| Check | Result | Means |
|---|---|---|
| Read `bookings`, `customers`, `stock_items` | Empty list (200) | RLS hides all rows from anonymous visitors |
| Customer lookup `get_booking_by_reference_code('ZZZZ2222')` | `null` (200) | Public lookup works; unknown code gives nothing away |
| `update_booking_phase` without login | **Refused: permission denied (42501)** | Migration **0008 is live**. Fixed since 7 Oct, when this call still worked |
| `add_booking_part` without login | Refused: permission denied | Staff-only (0008) |
| `delete_booking_and_restock` without login | Refused: permission denied | Staff-only (0008); admin check inside (0007) |
| `bookings.created_by` column | Does not exist (42703) | Migration **0010 not run yet** |
| `bookings.phase`, `reference_code`; tables `booking_labor`, `jobs`, `profiles` | Exist | Phase 2 schema in place |

Not checkable without a staff login: 0009 (old `add_booking_part` copy),
0011 (finalize/reopen trigger), and logged-in reads and writes. Gary's check
queries cover these.

## ASP.NET web app running against the live project

`dotnet run`, .NET 10, same code as the repo plus the login-message fix
below.

| Check (Activity 4.3, Step 7) | Result |
|---|---|
| Web application launches | Yes. Log: `[Supabase] Connected successfully`; `[Realtime] Subscribed to bookings/stock_items changes` |
| Connects to Supabase | Yes (startup query and Realtime subscription) |
| Pages that need a login redirect to the login page (`/`, `/Bookings/Create`, `/Stock`, `/Vehicles/Search`, `/Bookings/Closed`) | Yes (302 to `/Account/Login`) |
| Login form validates empty fields | Yes: "Enter your work email." / "Enter your password." |
| Wrong password | Rejected. **Bug found and fixed:** it used to show the raw Supabase error (`{"code":400,"error_code":"invalid_credentials",...}`); it now shows "Incorrect email or password." |
| `/Track` without login | Opens |
| `/Track?code=ABC` (malformed) | "That doesn't look like a reference code." |
| `/Track?code=ZZZZ2222` (unknown) | "We couldn't find a vehicle with that reference code." |
| Logged-in pages and functions | Not checked here (needs a staff account) |

Screenshots: `evidence/web/` (desktop and phone width).

## Not done from here

- **Vercel environment variables and deploy.** The assistant's Vercel
  connection has no access to the team, so Wisani adds `Supabase__Url` and
  `Supabase__AnonKey` in the Vercel dashboard and deploys.
- **Flutter run.** No Flutter SDK on this machine; Breyton/Gary run the app
  with the same `.env` values.
- **Firebase key revoke** in Google Cloud project `web-app-512220`. Needs a
  signed-in project owner.
