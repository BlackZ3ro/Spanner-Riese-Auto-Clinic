# Getting Riese Auto-Clinic onto Google Search and Maps

**Why:** at the Phase 2 presentation (16 Oct 2026) Mr G searched Google for
"Riese Auto Clinic" while we presented. Only other "auto clinic" and "motor
clinic" businesses came up, not Riese. His feedback: get Riese onto the
Google results page.

**What it takes:** a free **Google Business Profile**. It is what makes a
business show up in Google Search and on Google Maps, with its address,
phone number, opening hours, photos and a website link. Our app can't do this
for Michael: the profile belongs to the business, and Google makes the owner
prove the business is real (verification).

**Who:** Michael Riese, or someone he asks to do it with him. The Google
account that creates the profile becomes its owner, so use the workshop's
own Google account, not a student's. He can add group members as managers
afterwards.

**Cost:** free.

## Steps for Michael (about 15 minutes, plus Google's check)

1. Go to **business.google.com/add** and choose **Add your business to
   Google**. Sign in with the workshop's Google account.
2. **Business name:** exactly as it appears on the sign. Check the spelling
   with Michael: "Riese Auto-Clinic" or "Riese Auto Clinic". Don't add extra
   words like "best mechanic", because Google's rules don't allow it.
3. **Category:** *Auto repair shop*.
4. **Location:** the workshop's street address, since customers bring their
   cars there.
5. **Contact:** the workshop phone number customers call or WhatsApp.
   **Website:** leave it blank for now, or take Google's free starter page.
   Once the Spanner web app is online, put in its address, so customers can
   open the tracking page (`/Track`) straight from Google.
6. **Verify.** Google chooses which options to offer. Its help page lists
   these:
   - a **video recording**, which Google recommends if it's offered;
   - a **phone call or text** with a code;
   - an **email**;
   - a **live video call** with Google during business hours;
   - a **postcard** with a code (most arrive within 14 days, and the code
     expires after 30 days).

   For a video, Google wants to see:
   - where the business is: the outside sign and the street;
   - the business itself: the workshop, tools, branded items;
   - proof that you run it: for example opening up with your keys, or an
     area only staff can go into.

   After the verification steps, Google's review takes **up to 5 business
   days**.
7. **When it's verified, finish the profile:**
   - opening hours;
   - photos: the logo (`web/wwwroot/img/riese-logo.png` in our repo), the
     workshop front and the sign;
   - a short description (draft below);
   - the services you offer.
8. **Check:** search "Riese Auto-Clinic" on Google and on Google Maps on a
   phone.

### Draft description (Michael to check and edit)

> Riese Auto-Clinic is an automotive workshop run by Michael Riese. We book in,
> service and repair vehicles. Every vehicle we book in gets a reference
> code, so you can follow its progress without phoning us: book-in and
> inspection, labour in progress, reassembly, ready for pickup.

Only use services and claims Michael confirms. Don't add opening hours or
services we've guessed.

## What we changed in the app for this

- **Page titles:** public pages (log in, `/Track`) are now titled
  "... - Riese Auto-Clinic", not "Spanner". That title is what Google shows
  in its results.
- **Tracking page:** `/Track` has a description and link-preview tags. Google
  uses the description under the result. WhatsApp uses the tags to show the
  Riese logo and title when staff send a customer the tracking link.
- **Once the web app is online:** set `PublicSiteUrl` (see `web/README.md`),
  and put the same address in the Google profile's website field.

Sources: Google Business Profile Help,
[Add or claim your Business Profile](https://support.google.com/business/answer/2911778) and
[Verify your business on Google](https://support.google.com/business/answer/7107242),
checked 16 Oct 2026.
