# Putting Spanner online on Vercel

Plan for Phase 3: both apps on Wisani's Vercel account, free (Hobby) plan, so
the final presentation and Michael's acceptance test run on a real address
instead of a laptop. Written 17 Oct 2026.

| App | Vercel project | Address | How it runs | Status |
|---|---|---|---|---|
| ASP.NET web app (staff + `/Track`) | `riese-auto-clinic` | https://riese-auto-clinic.vercel.app | Container (`web/Dockerfile.vercel`) | Project created and set up; **not deployed yet** |
| Flutter app, built for the web | `riese-auto-clinic-app` (to create) | https://riese-auto-clinic-app.vercel.app | Static files (`flutter build web`) | Needs Gary's two small mobile changes first |

Both apps keep talking to the same Supabase project. Nothing about the
database changes because of hosting.

## 1. Web app (ASP.NET)

### Already done

- `web/Dockerfile.vercel` builds the app with the .NET 10 SDK and runs it on
  the port Vercel gives it (`$PORT`, default 80). Tested locally with Docker:
  the image builds and serves the login page and `/Track`.
- `web/Program.cs` trusts Vercel's `X-Forwarded-Proto` header, so the app
  knows it is on https (secure login cookie, correct links).
- Vercel project `riese-auto-clinic` created, root directory `web`.
- Deployment protection set so the **production** address is public (the
  customer `/Track` page has to open without a Vercel login). Preview
  deployments still need a Vercel login.
- Environment variable `PublicSiteUrl = https://riese-auto-clinic.vercel.app`
  (Production). With this set, the WhatsApp message gives customers a direct
  `/Track?code=...` link.

### Still to do (Wisani)

1. Vercel > riese-auto-clinic > **Settings > Environment Variables**, add for
   Production:
   - `Supabase__Url`: the project URL (`https://<ref>.supabase.co`)
   - `Supabase__AnonKey`: the **anon / public** key only

   Never the service-role key: the web app doesn't need it, and RLS only
   protects the data while the app uses the anon key with each staff
   member's login.
2. Deploy. From the repo root on a computer with Node.js:
   ```bash
   npx vercel link --project riese-auto-clinic
   npx vercel deploy --prod
   ```
   or connect the GitHub repo under **Settings > Git** so every push to `main`
   deploys by itself (better for Phase 3: the marker always sees the latest).
3. Check the address Vercel prints. If it isn't
   `riese-auto-clinic.vercel.app`, change `PublicSiteUrl` to match and
   redeploy.
4. Smoke test on the live address: `/Track` with a real reference code; staff
   login (admin and mechanic); book in, add a part, change the phase, Send on
   WhatsApp (the message should now contain the `/Track` link), download an
   invoice.
5. Supabase > Authentication > URL Configuration: add the Vercel address to
   the allowed URLs (only matters if we ever add password-reset emails).

### Things to know

- **Cold start.** Vercel stops the container after about 5 minutes with no
  visitors. The next visitor waits a few seconds while it starts. Before the
  presentation, open the site 2 minutes early.
- **Login 400 / surprise logouts (fixed 20 Oct).** Each container used to
  invent its own encryption key, so a login form opened on one container
  failed with HTTP 400 when submitted to the next, and staff were logged
  out. The app now derives one key from the `DataProtection__Secret`
  setting (`web/Auth/FixedKeyRepository.cs`). **Set it in Vercel** (any long
  random text, kept private). Tested by sending a form and a login cookie
  from one running copy of the app to a fresh one: 400 without the setting,
  works with it.
- **Realtime live-reload** on the dashboard needs a long-lived connection. If
  it drops when the container sleeps, the page still works; it just needs a
  manual refresh.
- Container hosting on Vercel is still a **beta** feature. Fallback if it
  misbehaves before the presentation: run the web app on a laptop
  (`dotnet run`) as in Phase 2; nothing in the code depends on Vercel.

## 2. Flutter app on the web

The Flutter app can be built as a website and hosted on Vercel as plain
files, next to the web app. Useful for the presentation (markers can open it
on any phone or laptop without installing an APK) and for customers who just
want to track their car.

### Changes needed in `mobile/` (Gary)

1. **Add the web platform** (the repo only has `android/`):
   ```bash
   cd mobile
   flutter create --platforms=web .
   ```
2. **Skip push notifications on the web.** `main.dart` already skips
   `Firebase.initializeApp()` when `kIsWeb`, but
   `PushNotificationService.registerForNotifications` doesn't, so it throws
   on the web when a customer enters their code. Add at the top of that method:
   ```dart
   if (kIsWeb) return; // push needs Firebase, which we only set up on Android
   ```
   (`import 'package:flutter/foundation.dart';`)
3. **The `.env` file becomes public on the web.** `pubspec.yaml` bundles
   `.env` as an asset, and on the web every asset can be downloaded by
   anyone. That's fine for `SUPABASE_URL` and `SUPABASE_ANON_KEY` (they're
   meant to be public; RLS protects the data), but **nothing else may ever go
   in that file**: no service-role key, no Firebase server key.
4. Build:
   ```bash
   flutter build web --release
   ```
   The site is in `mobile/build/web`.

### Deploy (Wisani or Gary)

1. Add `mobile/build/web/vercel.json` (or copy it in after each build) so
   refreshing a page doesn't give a 404:
   ```json
   { "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }] }
   ```
2. Deploy the built folder as its own project (the first time, the CLI asks
   whether to set up a new project: answer yes, no to linking an existing
   one, and name it `riese-auto-clinic-app`):
   ```bash
   cd mobile/build/web
   npx vercel deploy --prod
   ```
3. Vercel > riese-auto-clinic-app > Settings > Deployment Protection: keep
   Vercel Authentication on, set to protect everything except the production
   address, the same as the web app.

Test on a phone browser: staff login, bookings list, book in, customer
lookup with a reference code. Not expected to work on the web: push
notifications (Android only), and anything that saves files to the phone
(the invoice PDF may open in a new tab instead).

## 3. Cost

Both on the Hobby (free) plan: no cost, which keeps the SRS zero-budget rule.
The Hobby plan is for non-commercial use, which fits a student prototype. If
Riese Auto-Clinic ever uses it for real, that needs a paid plan or another
host; that would be Michael's decision after the module.
