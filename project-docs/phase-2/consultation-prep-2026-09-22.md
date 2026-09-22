# Consultation Prep — Ms Mbele, Tuesday 2026-09-22, 12:00 (Group Y's slot)

Based on the Unit 3 Group Progress Checkpoint ("Phase 2 Readiness") —
bring evidence of each item, don't just describe it.

## What to bring (per the checkpoint doc)

- [ ] System Architecture Diagram (`system-architecture.md`)
- [ ] Use Case Diagram (`uml-and-erd.md`, Part 1)
- [ ] At least 2 Sequence Diagrams (`uml-and-erd.md`, Part 2)
- [ ] ERD (`uml-and-erd.md`, Part 3)
- [ ] Flutter + ASP.NET interface designs (in progress — see tracker)
- [ ] Navigation flow (in progress)
- [ ] Stakeholder feedback evidence (see below)
- [ ] Microsoft Project — updated
- [ ] GitHub — current design docs
- [ ] Project Progress Tracker — current

## Genuine open questions worth asking Ms Mbele directly

1. **Design-after-build sequencing** — the web app's development (M0–M8)
   was largely finished before these Unit 3 design docs were drawn up
   (the group prioritised having a working, stakeholder-testable prototype
   early). Is documenting the *actual, verified* architecture/ERD
   acceptable evidence for Assessment 2, or does she expect to see
   design-before-build reasoning specifically?
2. **Two disconnected labour ledgers** (mobile's `booking_labor` vs web's
   `jobs.labour_hours × labour_rate`, both live against the same bookings)
   — is this the kind of schema-alignment issue Unit 3's "Step 14: Check
   Alignment" is meant to catch, and should it block the Phase 2 baseline
   until resolved, or can it be documented as a known limitation for now?
3. **Admin/mechanic role split exists on web but not mobile** — is that an
   acceptable asymmetry for the prototype, or does she expect parity across
   both apps before the design is "final"?
4. **New members' contribution window** — Ofentse and Breyton joined
   2026-09-17, partway through Unit 3. How should that be reflected in
   individual peer evaluation / GitHub evidence expectations, given they
   have less time on this phase than the rest of the group?
5. Anything specific she wants corrected before the diagrams are finalized
   for submission, based on what the group brings to this consultation.

## Notes from the meeting (22 Sept, Lab 226 — lecture halls in BHP were closed)

Feedback focused on the use case diagram and one new requirement, rather
than the five questions above being answered one by one — worth a follow-up
email or the next consultation if those still need direct answers.

**Use case diagram — restructure:**
- Too many top-level ovals; consolidate into base use cases (`Manage
  Bookings`, `Manage Stock`) with `«extend»` points fanning out to specific
  actions, rather than one oval per action.
- `View dashboard` shouldn't be standalone — make it an `«extend»` of
  `Login`.
- Add filtering between open and closed jobs as an explicit use case.
- Label the Admin-only extension points with the authentication
  requirement itself, not just "(Admin only)" in prose.
- Full restructure applied same day — see `uml-and-erd.md` Part 1 and the
  "Consultation outcomes" table there mapping each note to what changed.

**New requirement, confirmed:** a customer-facing repair-status lookup —
enter a reference code, see the vehicle's phase, **no login required**.
Deliberately narrower than the real-time tracking the group excluded from
scope in Phase 1 (see SRS Requirements Change Log) — this is a single
lookup screen, not push updates or an account. Target: working by end of
day 23 Sept. Implementation details (which app, what the reference code
actually is) still open — see `uml-and-erd.md`'s "New feature" section and
`system-architecture.md` point 5.

**Attendance:** held in Lab 226 (BHP lecture halls were all booked/closed).
Lusandla Cloud Systems confirmed attending.
