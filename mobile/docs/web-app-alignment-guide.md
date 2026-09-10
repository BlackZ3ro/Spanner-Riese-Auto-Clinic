# Keeping mobile in sync with the web app

Written after building the ASP.NET web app (`web/`) against the real
Supabase schema. This is what mobile needs to know to stay compatible -
both apps share one database, so a change on either side that isn't
reflected here can silently break the other.

## 1. The schema mobile's models don't fully match yet

Both apps read/write the same tables directly (no API layer in between), so
the Dart models in `mobile/lib` and the C# models in `web/Models` should
describe the exact same columns. Right now they don't, in two places:

**`VehicleBooking` (`mobile/lib/features/bookings/models/vehicle_booking.dart`)**
is missing two columns that exist in the real `bookings` table and that the
web app already reads/writes:

```dart
// Currently commented out in vehicle_booking.dart:
// @Default(BookingStatus.checkedIn) BookingStatus status,
// DateTime? createdAt,
```

`booking_status.dart` is a fully commented-out stub - the `BookingStatus`
enum doesn't exist as working code yet. The web app just uses a plain
`string` for status (currently only `"checked_in"` and, once a booking is
closed, presumably `"closed"` - worth confirming what value closing
actually uses, since no booking in the live data has been closed yet).

**Why this matters**: if mobile's `VehicleBooking.fromJson()` doesn't map
`status`, mobile can't show or filter on it - and if it doesn't map
`created_at`, it can't sort bookings by recency correctly either. Both
already exist on every row in the database; this is a mobile-model gap,
not a missing database column.

**Suggested fix** (uncomment and wire up, matching the DB's snake_case via
Dart's usual `@JsonKey` or your existing json_serializable convention):
```dart
required String status,       // maps to bookings.status
DateTime? createdAt,          // maps to bookings.created_at
```

## 2. Tables that exist now but didn't when mobile's models were written

Two tables were added to the live database while building the web app:

- **`jobs`** (id, booking_id, job_type, status, labour_hours, labour_rate,
  created_at, completed_at) - see `web/CLAUDE.md`'s M2/M4 sections and
  `supabase/migrations/0001_create_jobs_table.sql` for the exact shape and
  RLS policy. If mobile wants to show or create jobs, this is the table -
  no separate model exists on the mobile side for it yet.
- Realtime is being enabled on `bookings` and `stock_items`
  (`supabase/migrations/0002_enable_realtime.sql`, pending review). Once
  applied, mobile could subscribe to `.stream()` on these tables to get
  live updates the same way the web dashboard now does - see section 4.

## 3. Auth: mobile currently has none

`mobile/lib`'s "role select" screen
(`features/auth/presentation/role_select_screen.dart`) is a local
`StateProvider<UserRole?>` - it doesn't call Supabase Auth at all, isn't
tied to a real account, and resets every time the app restarts (defaults
to `null`). There are zero `Auth.signIn*` / `signUp*` calls anywhere in
`mobile/lib`.

The web app's login (`web/Pages/Account/Login.cshtml.cs`) is the first real
implementation of staff authentication in this project - it calls
`Auth.SignInWithPassword(email, password)` against the same Supabase
project mobile uses. **The same staff accounts work on both apps** once
mobile wires up real sign-in - Supabase Auth accounts aren't
platform-specific.

If/when mobile adds real login, the Supabase Flutter client's equivalent
call is:
```dart
final response = await Supabase.instance.client.auth.signInWithPassword(
  email: email,
  password: password,
);
```
matching the C# `SignInWithPassword` call web already uses - keeping the
method name/shape the same across both makes it easy to explain either
side in the same breath during the defence.

## 4. If mobile adds Realtime later, match this pattern

The web app's `Services/RealtimeChangeNotifier.cs` subscribes to Postgres
changes like this (conceptually - full C# in that file):
1. Open one Realtime channel per table of interest (`bookings`,
   `stock_items`).
2. On any insert/update/delete, refresh whatever's showing that data.

The Flutter equivalent (Supabase Flutter client) is a `.stream()` query,
e.g.:
```dart
Supabase.instance.client
    .from('bookings')
    .stream(primaryKey: ['id'])
    .listen((rows) { /* update UI */ });
```
No code changes needed on the web side for mobile to add this - Realtime
publication is a database-level setting (see migration `0002`), not
per-app.

## 5. Field-naming convention to keep following

Both apps use the database's own snake_case column names directly in
queries/inserts (`engine_size`, `quantity_on_hand`, `transmission_type`,
etc.), converted to camelCase (Dart) or PascalCase (C#) only in the model
layer. Stick with that rather than renaming columns in either app's model -
it's what's let both apps reuse the exact same field names throughout this
build without translation bugs.

## 6. Where to look for more detail

`web/CLAUDE.md` has the full build log (what was built each milestone, bugs
found and fixed, and why) if you want the reasoning behind any of the
above. `web/docs/team-handoff-report.md` is the same information pitched
at the whole group rather than mobile specifically.
