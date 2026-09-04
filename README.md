# Spanner

**Spanner** (working title) is a workshop booking, stock and invoicing system built for **Riese Auto-Clinic**, a real automotive workshop owned and run by Michael Riese. It gives the shop shared visibility of bookings, parts/stock and job costing across a mobile app for mechanics and a web app for the front desk, replacing the shop's current verbal/paper-based process.

This repository is the group project for **ITC327W** (Diploma in IT, Central University of Technology, South Africa), submitted by **Group Y**.

## The problem

Riese Auto-Clinic currently runs bookings, diagnostics, parts sourcing, repairs and invoicing informally, largely from memory and paper notes, with no shared record of stock, job status or costing. Spanner digitises that workflow so the owner, mechanics and front-desk staff are all working from the same information.

## Tech stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter |
| Web app | ASP.NET |
| Backend | Supabase (shared by both apps) |

## Key features (Phase 1 scope)

- Shared stock and parts visibility, with sourcing and cost tracking
- Per-job labour and parts tracking
- Booking and job status tracking for mechanics and front-desk staff
- Invoicing
- A Wikimedia-based vehicle reference image lookup: given a booking's brand, model and (optionally) year, the system pulls a best-effort reference image so a mechanic has a visual idea of the vehicle before it arrives

Customer-facing real-time job tracking was considered and deliberately **excluded** from this phase. It was raised during an academic consultation, but the stakeholder's own preference and operational experience pointed to it creating false ETA expectations and unnecessary overhead for mechanics, so it is documented as out of scope in the SRS rather than built. See the Requirements Change Log in the SRS for the full reasoning.

## Repository structure

> This section describes the project at a high level. Please check it still matches the actual folders in this repository before relying on it, and update it if the structure has moved on since this was written.

- `mobile/` — Flutter mobile app source
- `web/` — ASP.NET web app source
- `docs/` — SRS, feasibility study, risk register and project tracker
- `README.md` — this file

## Project documentation

The full Software Requirements Specification, Feasibility Study and Risk Register, the Microsoft Project schedule, and the Progress Checker/contribution tracker for this phase are submitted separately via the module's official submission process, and referenced from the SRS's Appendices section alongside this repository link.

## Team — Group Y

| Name | Student number | Focus this phase |
|---|---|---|
| Gary van Wyk | 222048911 | Stakeholder engagement & requirements lead; mobile app (Flutter); ASP.NET web app; Supabase setup |
| Keamogetse Ogone Kgosi (Kea) | 222003092 | GitHub repository setup and structure |
| Moremi KE (Khumo) | 222062729 | Stakeholder engagement support; coordinating the Microsoft Project schedule across the group |
| Mathye MD (Denny) | 221014861 | SRS content support; redefined scope; Microsoft Project schedule support |
| Wisani Nkuna | 222010787 | Progress tracking, reporting and coordination |

## Status

Unit 1 / Phase 1 (planning, stakeholder engagement, requirements and initial SRS) is complete and submitted. Phase 2 (architecture, UML, ERD and interface design) is next.
