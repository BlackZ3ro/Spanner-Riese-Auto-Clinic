# Use cases: user input, code and database table

Mr G at the Phase 2 presentation (16 Oct 2026): a good use case "is not just
two stick men"; behind every use case "there must be code, there must be a
database table, there must be interaction input from the user". This table
shows all three for every use case in the use case diagram
(`diagrams/usecase-restructured.png`, editable `diagrams/editable/usecase.drawio`).

Web paths are under `web/`, mobile paths under `mobile/lib/features/`.
"RPC" means a database function in Supabase (`supabase/migrations/`).

## Staff (Admin and Mechanic)

| Use case | What the user enters | Code (web / mobile) | Database |
|---|---|---|---|
| **Login**, includes *Validate with Supabase Auth* and *Dashboard* | Email and password | Web `Pages/Account/Login`, dashboard `Pages/Index`. Mobile `auth/presentation/login_screen.dart`, `home/presentation/home_screen.dart` | Supabase Auth (`auth.users`). Role from `profiles.role` (mobile) or the `AdminEmails` setting (web). Dashboard reads `bookings`, `stock_items` |
| **Book in a vehicle** | Customer name and phone (email, company optional); brand, model, year, registration, kilometres, engine, transmission | Web `Pages/Bookings/Create`. Mobile `bookings/presentation/book_in_screen.dart` | Looks up and inserts `customers`; inserts `bookings`. The database fills in `reference_code` (random, unique), `invoice_number` and, after migration 0010, `created_by` |
| **Message customer on WhatsApp** (new) | Tap *Send on WhatsApp*, check the message, tap Send | Web `Pages/Bookings/Details` and `Services/CustomerWhatsApp.cs`. Mobile: still to build | Reads `bookings` (`reference_code`, `phase`, `status`, `customer_phone`, `invoice_number`). Writes nothing |
| **Search bookings / vehicle history** | Registration, customer name or phone | Web `Pages/Vehicles/Search` (plus `Services/VehicleImageService.cs`, Wikimedia picture). Mobile `bookings/presentation/bookings_list_screen.dart` (search box) | `bookings`, `jobs` |
| **View bookings** (open / closed filter) | Open or closed | Web `Pages/Index` (open), `Pages/Bookings/Closed`. Mobile `bookings_list_screen.dart` | `bookings.status` |
| **Download invoice (PDF)** | Click *Download invoice* | Web `Pages/Bookings/Invoice` with `Services/BookingInvoiceDocument.cs` (QuestPDF). Mobile `bookings/data/invoice_pdf_service.dart` | `bookings`, `booking_parts`, `stock_items`, plus `jobs` (web labour) or `booking_labor` (mobile labour) |
| **Manage stock** (search, add / restock, categories) | Search text; SKU, name, category, supplier, cost and sell price, quantity, reorder level; restock quantity | Web `Pages/Stock/Index`, `Pages/Stock/Create`. Mobile `stock/presentation/` (`stock_list_screen`, `add_stock_item_screen`, `stock_item_detail_screen`, `manage_categories_suppliers_screen`) | `stock_items`, `categories`, `suppliers`; a restock adds an `in` row to `stock_movements` |
| **Update booking phase** | Choose the new phase | Web `Pages/Bookings/Details` (`OnPostPhaseAsync`). Mobile `booking_detail_screen.dart` | RPC `update_booking_phase` sets `bookings.phase`; a database webhook calls the Edge Function `send-phase-notification`, which reads `booking_push_tokens` and pushes through Firebase Cloud Messaging |
| **Update booking** (add labour / add part), includes *Decrement stock* | Job type; labour hours and rate; part and quantity | Web `Pages/Bookings/Details` (`OnPostAddJobAsync`, `OnPostAddPartAsync`), `Pages/Jobs/Details` (`OnPostSaveHoursAsync`, `OnPostMarkCompleteAsync`). Mobile `booking_detail_screen.dart` | `jobs` (web labour), `booking_labor` (mobile labour); RPC `add_booking_part` inserts `booking_parts`, lowers `stock_items.quantity_on_hand` and adds an `out` row to `stock_movements`, all in one step |

## Admin only

| Use case | What the user enters | Code (web / mobile) | Database |
|---|---|---|---|
| **Finalize & close booking** | Click *Finalize & close* | Web `OnPostFinalizeAsync`. Mobile `booking_detail_screen.dart` | `bookings`: `status = 'closed'`, `phase = 'finalized'`, `closed_at`. The phase change pushes a notification to the customer |
| **Delete booking**, includes *Restock parts* and *Remove jobs* | Confirm the delete | Web `OnPostDeleteAsync` | RPC `delete_booking_and_restock` (migrations 0005, 0007): returns every part to `stock_items` with a `stock_movements` row, removes `jobs`, `booking_labor`, `booking_parts` and the `bookings` row, all or nothing |
| **Reopen closed booking** | The admin's own password | Web `OnPostReopenAsync` | Supabase Auth checks the password again; `bookings` back to open |
| **Remove a job (labour line)** or part | Confirm | Mobile `booking_detail_screen.dart` (`_confirmRemoveLabor`, `_confirmRemovePart`) | `booking_labor`, `booking_parts` (a removed part goes back to stock) |

## Customer (no login)

| Use case | What the user enters | Code (web / mobile) | Database |
|---|---|---|---|
| **Track repair status** | The reference code (booking slip or WhatsApp message) | Web `Pages/Track/Index`. Mobile `customer/presentation/customer_lookup_screen.dart`, then `customer_status_screen.dart` | RPC `get_booking_by_reference_code` |
| *Check reference code in Supabase* (included) | Nothing more | The same RPC, which runs as `security definer`, so the customer never gets direct table access | `bookings.reference_code` (unique, 8 random characters) |
| *View phase, parts and labour* (included) | Nothing more | Track page timeline; `customer_status_screen.dart` | The RPC's answer: phase, parts (`booking_parts` + `stock_items`), labour (`booking_labor`) |
| *Show "code not found"* (extends Track) | A wrong or unknown code | `Track/Index.cshtml.cs` error message; mobile lookup screen | The RPC returns nothing |
| **Get phase updates on the phone** | Allow notifications in the app | Mobile `customer/data/push_notification_service.dart` | RPC `register_push_token` saves the phone in `booking_push_tokens` (unknown codes are refused); the Edge Function `send-phase-notification` sends the push |
| Receives **Message customer on WhatsApp** | Nothing (reads the message) | WhatsApp, from the staff member's phone or computer | None |
