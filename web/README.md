# Web Application (ASP.NET)

This folder contains the ASP.NET web application for Spanner - the front-desk/
admin-facing counterpart to the Flutter mobile app in `/mobile`, sharing one
Supabase backend.

## Owner
Gary (see repo `CONTRIBUTORS.md`) - other group members are welcome to help,
per the ASP.NET build plan's M0-M8 milestone sequence.

## Stack
ASP.NET Core 10 (LTS), Razor Pages, the `Supabase` NuGet package for data
access/auth/realtime. See `CLAUDE.md` for the full context and ground rules.

## Setup

1. Install the [.NET 10 SDK](https://dotnet.microsoft.com/download).
2. Restore packages:
   ```bash
   cd web
   dotnet restore
   ```
3. Configure Supabase credentials with user secrets (never commit these,
   never use the `service_role` key here - anon/public key only):
   ```bash
   dotnet user-secrets set "Supabase:Url" "https://<project-ref>.supabase.co"
   dotnet user-secrets set "Supabase:AnonKey" "<anon-public-key>"
   ```
4. Run the application:
   ```bash
   dotnet run
   ```
   On startup, the console prints whether the Supabase connection succeeded.
   Without credentials configured, it still starts (read-only pages that need
   Supabase just won't have data yet).

## Status

- M0 (project setup, Supabase client wiring): done. Live connection confirmed.
- M1 (staff login + read-only dashboard): code complete, built against the
  real Supabase schema (see `CLAUDE.md` - it differs from the original plan).
  Login/dashboard tested against a live login failure and the unauthenticated
  redirect; a successful login is still pending a confirmed staff account.
