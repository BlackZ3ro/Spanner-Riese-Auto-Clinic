# Spanner

**Integrated prototype for Riese Auto-Clinic**

A mobile + web system that helps a mechanical workshop book vehicles, assign jobs, track labour time, record parts used, and generate invoices.

## Stakeholder
- **Organisation**: Riese Auto-Clinic  
- **Contact**: Michael Riese (Owner / Head Mechanic)

## Tech Stack
| Component              | Technology   |
|------------------------|--------------|
| Mobile application     | Flutter      |
| Web application        | ASP.NET      |
| Backend & Database     | Supabase     |

## Group Members
- [K.O Kgosi] – [222003092]
- [K.E Moremi] – [222062729]
- [G Van Wyk] – [222048911]
- [Mathye MD] – [221014861]
- [W Nkuna] – [222010787]

## Repository Structure

- `mobile/` – Flutter mobile application
- `web/` – ASP.NET web application
- `supabase/` – Shared backend (migrations & seed data)
- `project-docs/` – Assessment deliverables and project documentation
- `assets/` – Shared images, icons and mockups
- `CONTRIBUTORS.md` – Team ownership

## How to Run (to be completed later)
### Mobile (Flutter)
```bash
cd mobile
flutter pub get
flutter run

### Web (ASP.NET)
cd web
dotnet restore
dotnet run
