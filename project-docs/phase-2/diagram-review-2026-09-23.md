# Diagram review: SpannerUML.pdf and Sequence Diagram V2.pdf (23 Sept 2026)

> **Update 28 Sept:** finding 8 and open decision 1 are resolved — Gary added real Supabase login and admin-only Finalize/Delete/Reopen on mobile; part/labour removal was gated to admin afterwards. See CHANGELOG 28 Sept.

Checked against the web code (`web/Pages/Bookings/Details.cshtml.cs`), the
mobile code on `origin/main` (`mobile/lib/features/...`) and the
consultation outcomes. Corrected sequence diagrams are in `diagrams/`.

## Use case diagram (SpannerUML.pdf)

| # | Issue | Fix |
|---|-------|-----|
| 1 | Not restructured per the 22 Sept consultation: flat list of 10 top-level ovals, no Manage Bookings / Manage Stock hubs, no search or open/closed filter. | Use the restructured diagram in `uml-and-erd.md` Part 1. |
| 2 | "View dashboard" is an include of Log in; it should be an extension. | Make it an extension of Log in. |
| 3 | Customer actor and "Check repair status by reference code" are missing. | Add them (no login; task U3-21). |
| 4 | Admin and Mechanic are drawn as two separate actors sharing lines. | Admin generalizes Mechanic. |
| 5 | Labels are misspelled: `<<extent>>` should read `<<extend>>`, and "credentails" should read "credentials". | Correct both. |
| 6 | Finalise and Delete do not show that they need admin authorisation. | Add the {Admin auth} label. |
| 7 | "Reopen closed booking" hangs off View closed bookings with an include; Reopen is optional. | Use an extend. Decision 23 Sept: Reopen is ADMIN-ONLY (the code does not enforce it yet). |
| 8 | Mobile has NO login. It has a role picker (Admin / Mechanic, no password) that gates nothing. Mobile can finalize and delete without any admin check. | Note it on the diagram as a known asymmetry. Team decision needed. |

## Sequence diagrams (V2)

| Diagram | Issue | Fix |
|---------|-------|-----|
| 1 Flutter "adds a job" | Wrong flow: mobile never writes to `jobs`. Its "add work" writes `booking_labor` (description, hours > 0, rate). The diagram's `jobs(job_type,status)` insert is the web ledger. | Replaced with "Mechanic books in a vehicle": validate, look up customer (ilike name/phone), insert customer if new, insert booking. Matches Breyton's "add booking, not add job". |
| 1 | No login or role step. | Mobile step 1 is role pick only (no auth). |
| 2 and 3 web | "Check IsAdmin" is drawn as a call to Supabase. It is an in-app config check (`AdminEmails` allowlist, `config.IsAdmin`); no DB call. | Removed as a call. The alt condition is the check. |
| 2 and 3 | No Login step. | Added: 1. Login (Supabase Auth, JWT). 2. Working with the system. |
| 2 | "200 OK" is drawn after the alt, so it also applies to the denied branch. | Response moved inside the Admin branch. |
| 3 | Missing the "are you sure" confirm. Redirect target is the dashboard (`/Index`), which is correct. | Added the confirm. |
| 2 and 3 | `Loop` was flagged as infinite. | All frames are `alt`. |

## Open decisions (for the team)

1. Mobile has no real authentication or admin gate; web does. Document as a known gap or fix it.
2. Agreed permissions (23 Sept): only Admin can finalize, delete, reopen and remove jobs; both roles restock. Web does not yet gate Reopen or job removal; mobile gates nothing (task U3-23).
3. Mobile "labour" (`booking_labor`) and web "jobs" are separate ledgers.
4. Mobile adds a part and records the stock movement as two separate calls (not atomic). Web uses the `add_booking_part` RPC.
