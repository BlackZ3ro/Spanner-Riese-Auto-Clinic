# Demo script (web app) - ~2-3 minutes

Sample data already lives in the shared Supabase project, so this needs no
setup beyond logging in. No equivalent mobile demo script existed to align
with (checked `/mobile` and `/project-docs` - nothing found), so this uses
the same vehicle/booking data as-is; if a mobile demo gets scripted later,
point it at the same Volkswagen Polo booking below so both apps tell one
story instead of two disconnected ones.

## Cast

- **Vehicle**: Volkswagen Polo (2019), registration `CY 45 KL GP`
- **Job**: "Suspension inspection and repair" - completed, 1.5 hours @ R480/h
- **Part used**: Polo Suspension Kit (SKU PSK-001) x1, R4,500.00
- **Total**: R5,220.00 (R4,500 parts + R720 labour)
- Two other real bookings (Toyota Tazz `CAW 22015`, Toyota Corolla
  `BD 5I SMR GP`) are also visible on the dashboard for a "this is a real
  working system, not just one fake row" feel.

## Script

**1. Log in (10s)**
Open the app, log in as a staff member. Point out: no customer-facing
login exists by design (SRS, Out of Scope) - this is a staff tool only.

**2. Dashboard (20s)**
Land on the dashboard. Three real bookings are visible, plus current
stock levels. Point out the Polo Suspension Kit row - 8 on hand, not 9,
because of what we're about to show.

**3. Open the Volkswagen Polo booking (30s)**
Click into `CY 45 KL GP`. Show the booking details, then the "Suspension
inspection and repair" job - already marked complete with 1.5 hours at
R480/hour. Show the linked Polo Suspension Kit part underneath it, and
the parts/labour/total breakdown at the bottom (R4,500 + R720 = R5,220).

**4. Download the invoice (20s)**
Click "Download invoice (PDF)". Open it - point out it lists the same
labour line, the same part line, and the same total the page just showed
- generated on demand, not a static file.

**5. Vehicle history search (30s)**
Go to Vehicle history, search `CY 45`. Show the same booking comes back
with its job history, plus a Wikimedia reference image of a Volkswagen
Polo (best-effort visual aid - explicitly not claimed to be a photo of
this exact car, per the SRS and risk R-13).

**6. Stock page (15s)**
Go to Stock. Show the Polo Suspension Kit at 8 on hand, 4,500/4,500 cost/
sell - point out this dropped automatically when the part was linked to
the booking, no manual stock adjustment needed.

**7. (If time allows) Book in a new vehicle live (30s)**
Use "Book in a vehicle" to create one more booking live, showing the form
validates required fields and redirects straight to the new booking's
detail page.

## What this deliberately doesn't show

- Realtime live-sync between web and mobile - not demoable yet, see
  `web/CLAUDE.md`'s M7 section for why (mobile has no Realtime subscriptions
  of its own to sync against).
- A "jobs in progress" panel scoped to *this* job's parts specifically -
  the total shown is booking-wide by design (see CLAUDE.md's M4 section)
  since parts aren't tracked per-job in this schema.
