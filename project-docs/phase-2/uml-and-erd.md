# Activity 3.2 — UML and Database Design

Draft owners: Breyton Rossouw (use case diagram), Wisani + Gary (sequence
diagrams), Wisani (ERD). Everything below is grounded in the real app and
the real Postgres schema — not invented, so the diagrams should mostly need
re-drawing in a proper tool, not re-designing.

## Part 1 — Use Case Diagram

### Actors

Important correction vs. the generic "salon" example in the course
material: **customers are not system actors**. They're walk-in clients —
front-desk staff capture their details on their behalf. The real actors are
staff.

| Actor | What they need to do |
|---|---|
| **Mechanic** (staff, both apps) | Book in a vehicle, add jobs, link parts, record labour, view stock, search vehicle history, download invoices |
| **Admin** (staff, web only, specialised Mechanic) | Everything a Mechanic can do, **plus**: finalize & close a booking, delete a booking (with restock), reopen a closed booking (password-confirmed) |

`Admin` is a **generalization** of `Mechanic` — same relationship as the
course example's "Manager is a specialised Staff User".

### Use cases (from the real app, not hypothetical)

- Log in
- Book in a vehicle (with customer auto-fill/lookup)
- Add a job to a booking
- Add a part to a booking → **`<<include>>`** Decrement stock (always
  happens together — see `add_booking_part`)
- Record labour hours/rate on a job
- View live dashboard (Realtime updates)
- Search vehicle history (by registration, name, or phone)
- Download invoice (PDF)
- Add/view stock; create a new stock category or supplier inline
- Finalize & close a booking *(Admin only)*
- Delete a booking → **`<<include>>`** Restock parts, **`<<include>>`**
  Remove labour/jobs *(Admin only — one atomic call, `delete_booking_and_restock`)*
- Reopen a closed booking → **`<<extend>>`** Display "incorrect password"
  error *(Admin only, only when the password check fails)*

### Diagram (Mermaid; redraw as proper UML in draw.io/Lucid)

```mermaid
flowchart TB
    subgraph Boundary["Spanner System"]
        UC1(Log in)
        UC2(Book in a vehicle)
        UC3(Add a job)
        UC4(Add a part)
        UC4b(Decrement stock)
        UC5(Record labour)
        UC6(View live dashboard)
        UC7(Search vehicle history)
        UC8(Download invoice)
        UC9(Add/view stock)
        UC10(Finalize and close booking)
        UC11(Delete booking)
        UC11b(Restock parts)
        UC11c(Remove labour/jobs)
        UC12(Reopen booking)
        UC12b(Display incorrect-password error)
    end

    Mechanic((Mechanic))
    Admin((Admin))

    Admin --> Mechanic

    Mechanic --> UC1
    Mechanic --> UC2
    Mechanic --> UC3
    Mechanic --> UC4
    Mechanic --> UC5
    Mechanic --> UC6
    Mechanic --> UC7
    Mechanic --> UC8
    Mechanic --> UC9

    Admin --> UC10
    Admin --> UC11
    Admin --> UC12

    UC4 -. include .-> UC4b
    UC11 -. include .-> UC11b
    UC11 -. include .-> UC11c
    UC12 -. extend .-> UC12b
```

## Part 2 — Sequence Diagrams (at least one Flutter, one ASP.NET)

### Diagram 1 — Mechanic adds a job (Flutter → Supabase)

```mermaid
sequenceDiagram
    actor M as Mechanic
    participant F as Flutter App
    participant S as Supabase (Postgrest)

    M->>F: Enter job type, tap "Add job"
    F->>F: Validate not blank
    F->>S: INSERT INTO jobs (booking_id, job_type, status='pending')
    S-->>F: 201 Created
    F-->>M: Job appears in the list
```

### Diagram 2 — Admin finalizes a booking (ASP.NET → Supabase)

```mermaid
sequenceDiagram
    actor A as Admin
    participant W as ASP.NET Web App
    participant S as Supabase (Postgrest)

    A->>W: POST /Bookings/Details?handler=Finalize
    W->>W: Check IsAdmin (server-side, not just hidden button)
    alt not admin
        W-->>A: "Only an admin can finalize a booking."
    else is admin
        W->>S: UPDATE bookings SET status='closed', closed_at=now() WHERE id=...
        S-->>W: 200 OK
        W-->>A: Redirect to booking (now read-only, off dashboard)
    end
```

### (Optional third) Diagram 3 — Admin deletes a booking, atomic restock

```mermaid
sequenceDiagram
    actor A as Admin
    participant W as ASP.NET Web App
    participant S as Supabase (Postgres function)

    A->>W: Confirm "Are you sure?" → POST Delete
    W->>W: Check IsAdmin
    W->>S: RPC delete_booking_and_restock(booking_id, user_id)
    Note over S: single transaction:<br/>restock every part,<br/>log stock_movements,<br/>delete jobs, booking_parts, booking
    S-->>W: void (success) or error
    W-->>A: Redirect to dashboard (booking gone, stock restored)
```

## Part 3 — Entity Relationship Diagram

Taken directly from `web/Models/*.cs` and `supabase/migrations/` — this is
the **real, live schema**, including the customer/invoice columns mobile
added mid-project (see `web/CLAUDE.md`'s "Schema drift" note).

```mermaid
erDiagram
    CUSTOMERS ||--o{ BOOKINGS : "books in"
    BOOKINGS ||--o{ JOBS : "has"
    BOOKINGS ||--o{ BOOKING_PARTS : "uses"
    STOCK_ITEMS ||--o{ BOOKING_PARTS : "used in"
    STOCK_ITEMS ||--o{ STOCK_MOVEMENTS : "tracked by"
    CATEGORIES ||--o{ STOCK_ITEMS : "classifies"
    SUPPLIERS ||--o{ STOCK_ITEMS : "supplies"

    CUSTOMERS {
        uuid id PK
        text name
        text phone
        text email
        text company
        timestamptz created_at
    }
    BOOKINGS {
        uuid id PK
        uuid customer_id FK
        text brand
        text model
        int year
        text engine_size
        text engine_code
        text transmission_type
        text registration
        bigint kilometers
        text image_url
        text status
        text invoice_number "DB-generated sequence, e.g. INV-00005"
        timestamptz created_at
        timestamptz closed_at
    }
    JOBS {
        uuid id PK
        uuid booking_id FK
        text job_type
        text status
        numeric labour_hours
        numeric labour_rate
        timestamptz created_at
        timestamptz completed_at
    }
    BOOKING_PARTS {
        uuid id PK
        uuid booking_id FK
        uuid stock_item_id FK
        int quantity
        numeric unit_price
        timestamptz created_at
    }
    STOCK_ITEMS {
        uuid id PK
        text sku
        text name
        uuid category_id FK
        uuid supplier_id FK
        numeric cost_price
        numeric sell_price
        int quantity_on_hand
        int reorder_level
        timestamptz created_at
    }
    STOCK_MOVEMENTS {
        uuid id PK
        uuid item_id FK
        text type "in / out"
        int quantity
        numeric cost_at_time
        text reference
        uuid user_id
        timestamptz timestamp
    }
    CATEGORIES {
        uuid id PK
        text name
        timestamptz created_at
    }
    SUPPLIERS {
        uuid id PK
        text name
        text contact_info
        timestamptz created_at
    }
```

### Notes for the write-up

- `bookings` also keeps denormalized `customer_name`/`customer_phone`/
  `customer_email`/`customer_company` columns alongside the `customer_id`
  foreign key — a deliberate snapshot so a booking's customer info stays
  correct even if the `customers` record is edited later. Worth a sentence
  in the design rationale.
- `booking_parts` has no `job_id` — parts are booking-wide, not tied to a
  specific job. Flagged in `web/CLAUDE.md` as a known limitation, not
  something to silently redesign away this late.
- Two disconnected labour totals currently exist (`jobs.labour_hours ×
  labour_rate` on web vs. a `booking_labor` table mobile introduced) — this
  is exactly the kind of thing Activity 3.2's "Step 14: Check Alignment"
  is meant to catch. Worth raising with Ms Mbele directly.
