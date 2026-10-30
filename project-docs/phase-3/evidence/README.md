# Implementation evidence (30 Oct 2026)

All screenshots use dummy data (Test Customer, 060 000 0000, TEST 001 GP). Other customers' rows are hidden. Taken from the Flutter app (web build, phone size) and the live website, on one Supabase project.

The same screenshots with captions: `Spanner implementation evidence (30 Oct 2026).pdf` in this folder.

## Flutter app (`mobile/`)

| File | What it shows | Requirement |
|---|---|---|
| m01-welcome-screen.png | Welcome screen with the Riese logo and the two entry points: customer and staff. | Flutter UI |
| m02-customer-enter-reference-code.png | Customer enters the reference code from the booking slip or WhatsApp message. No login. | FR-14 |
| m03-customer-code-not-found.png | Unknown code: clear message, no data revealed. | FR-14, NFR-03 |
| m04-staff-sign-in.png | Staff sign-in with Supabase Auth. | FR-12 |
| m05-home-admin.png | Home screen, signed in as Admin: 9 open jobs read from the shared database (the website shows the same count). | FR-12, FR-09 |
| m06-bookings-list-new-booking.png | Bookings list: the new dummy booking at the top (other customers hidden). | FR-11 |
| m07-book-in-form-validation.png | Book-in form validation: "Enter a whole number" and "Required" messages. | FR-01, NFR-01 |
| m08-book-in-form-filled-dummy-data.png | Book-in form filled with dummy data (Test Customer, 060 000 0000, Toyota Corolla, TEST 001 GP). | FR-01 |
| m09-booking-saved-reference-code-whatsapp.png | Booking saved: the reference code RYOSOGZ2 and a ready-to-send WhatsApp message (Mr G, 16 Oct). | FR-01, FR-14 |
| m10-booking-details-new.png | Booking details: invoice INV-00020, reference code, customer, phase tracker at step 1. | FR-01, FR-15 |
| m11-add-part-dialog.png | Add part: stock item, quantity and price charged. | FR-04 |
| m12-part-added.png | Part added to the booking (R20.00). | FR-04 |
| m13-phase-change-confirm.png | Moving the booking to the next phase asks for confirmation; the customer is notified. | FR-15, FR-16 |
| m14-phase-labor-in-progress.png | Phase is now "Labor in progress". | FR-15 |
| m15-add-labor-dialog.png | Add work / labor: 1 hour at the standard R350/h gives R350.00. | FR-05 |
| m16-totals-and-finalize.png | Parts R20 + labor R350 = grand total R370.00; Finalize & close (admin). | FR-06, FR-17 |
| m17-customer-status-after-web-change.png | Customer status screen after the WEBSITE moved the booking to Reassembly: the phone shows the new phase plus the part and work done. | Shared process P2 |
| m18-bookings-list-reassembly-from-web.png | Staff list shows "Reassembly", changed on the website. | Shared process P2 |
| m19-booking-reassembly-from-web.png | Booking details: phase 3 (Reassembly) set on the website. | Shared process P1/P2 |
| m20-finalize-confirm.png | Finalize confirmation (admin only). | FR-17 |
| m21-booking-finalized-closed.png | Booking closed and finalized: all four steps ticked; Reopen is admin only. | FR-17 |
| m22-completed-tab.png | Completed tab lists the finalized booking. | FR-11 |
| m23-stock-list.png | Stock list with quantities. | FR-03, FR-10 |
| m24-stock-item-part-decreased.png | Ponytail Test Part: 2 on hand (was 3 before the part was added to the booking). | FR-04, FR-10 |
| m25-home-mechanic-role.png | Home screen, signed in as Mechanic. | FR-12, FR-17 |
| m26-closed-booking-mechanic-no-reopen-delete.png | Closed booking as a mechanic: only "Export / print invoice", no Reopen or Delete. | FR-17 |
| m27-pull-to-refresh-before-after.png | Pull-to-refresh on the bookings list: the left half shows a booking at "Book-in & inspection"; its phase was then changed in the database (as the website would); after pulling down the list the right half shows "Reassembly", without restarting the app. Other customers are cropped out. | FR-09, shared process P1/P2 |

## Website (`web/`)

| File | What it shows | Requirement |
|---|---|---|
| w01-login.png (+ phone width where taken) | Staff login page (desktop). | FR-12 |
| w02-login-wrong-password.png (+ phone width where taken) | Wrong password: "Incorrect email or password." | FR-12, NFR-01 |
| w03-dashboard-today.png (+ phone width where taken) | Dashboard: stat cards, current bookings and stock levels (other vehicles hidden). | FR-09, FR-10 |
| w04-booking-created-on-phone.png (+ phone width where taken) | Booking page on the website after the labour change: a booking with a part (R20) and labour entered the way the phone does it (R350) shows the same R370 total as the phone (m16), with the Labour section and Remove button. Taken on the live site after the 30 Oct redeploy. | Shared process P1; FR-05, FR-06 |
| w05-book-in-form.png (+ phone width where taken) | Book in a vehicle (web form). | FR-01 |
| w06-stock.png (+ phone width where taken) | Stock page (same quantities as the phone). | FR-03, FR-10 |
| w09-track-customer-page.png (+ phone width where taken) | Customer tracking page by reference code, no login (Labor in progress). | FR-14 |
| w10-phase-changed-on-web.png (+ phone width where taken) | Phase changed to Reassembly on the website. | FR-15; shared process P2 |
| w11-job-added.png (+ phone width where taken) | Job added on the website. | FR-02 |
| w12-booking-finalized-admin.png (+ phone width where taken) | Finalized booking (admin) after a web labour line was added (R500 labour, R520 total): Reopen and Delete available; WhatsApp thank-you. | FR-17 |
| w13-closed-bookings.png (+ phone width where taken) | Closed bookings list (other customers hidden). | FR-11 |
| w14-track-finalized.png (+ phone width where taken) | Tracking page shows "Finalized - booked out to customer". | FR-14 |
| w15-booking-as-mechanic-no-admin-buttons.png (+ phone width where taken) | Same booking as a mechanic: no Finalize, Reopen or Delete. | FR-17 |
| w16-invoice-pdf-page.png (+ phone width where taken) | Invoice PDF generated by the website: both labour lines (one entered like the phone, one on the web) and the part, grand total R520. | FR-07 |

`web/whatsapp-message.txt` is the WhatsApp message the website prepared for the booking. `web/invoice-test-booking-30-oct.pdf` is the invoice the website generated.

## Known limitations seen

- Labour was in two tables (found 30 Oct: phone R350, website R0). Fixed the same day: one table, booking_labor; w04, w12 and w16 retaken on the live site.
- Flutter has no live updates; pull the list or a booking down to reload it (m27, added 30 Oct).
- Push notifications and fingerprint login need a physical Android phone.
- Vehicle reference photo could not load in the capture environment.
