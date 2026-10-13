# Zealots Tracker — Design Plan (for Claude, build/maintenance only)

Internal companion to `tracker-team-guide.md` — that one is what the group
reads; this one is what I (or a future session) read before touching the
artifact's code. Keep the two separate: one explains the tool, the other
explains how it's built.

## Subject grounding
Team name "The Zealots", project "Spanner" (auto workshop app). Lean into
workshop/garage materiality — not another generic SaaS kanban look.

## Design plan
- **Color** (tokens, light-first, dark redefines):
  - `--bg` #F7F5F1 (warm shop-manual off-white) / dark #1C1D1F (graphite)
  - `--surface` #FFFFFF / #26282B
  - `--ink` #22201D / #EDEAE4
  - `--muted` #6B655C / #9C968C
  - `--accent` #D9622B (torque-wrench rust orange) — primary actions, progress
  - `--accent-2` #3E6E8E (steel blue) — informational, links, avatars fallback
  - `--ok` #4C8C4A, `--warn` #C79A2E, `--danger` #C0463B — status only, never decorative
- **Type**: display — "Oswald" (condensed, workshop signage character) for
  headings/eyebrows; body — "Inter" for everything readable, tabular
  numerals for dates/percent; mono — "JetBrains Mono" for task IDs
  (U3-01) and the countdown. All via Google Fonts link tag.
- **Layout**: sticky header (team name, days-to-deadline chip, phase
  progress bar) → owner-grouped task list (7 columns of cards, one per
  person, cards show task, reviewer, status pill, due date) → below it a
  compact shared activity/notes feed (latest first) doubling as the
  "contact" channel. Phone width: columns stack to one, feed moves below.

## Data model (`db` capability)
Collection `tasks`, doc id = task code (`u3-01` … `u3-19`):
```
{ code, title, owner, reviewer, status: "not_started"|"in_progress"|"done",
  due, rubricLine, lastEditedBy (user id), lastEditedAt (ISO) }
```
Collection `notes`, auto id:
```
{ taskCode (nullable, null = general note), text, authorId, createdAt }
```
Rules: default (`{db:{}}`) — every org member reads/writes shared paths.
Fine for a 7-person group; no per-viewer private subtree needed.

## Capabilities
`capabilities: { db: {}, user: { scopes: ["profile"] } }` — db for the
shared task/notes store, user (profile scope) to show real names/avatars
on edits and notes without ever persisting a name into `db` (store id
only, resolve via `user.profiles()` at render time, per its own rules).

## Build notes
- Seed the 19 real tasks from `phase2-checklist.md` /
  `roles-and-assignments.md` via `write_db` batch right after first
  publish — never hardcode seed data inside the page's own JS (per the
  db capability's own guidance).
- `db` unresolved (`null`) or a write rejected → render read-only, no
  dead buttons, no retry loops. This is the expected state for anyone not
  in the same Claude org — the team guide already sets that expectation.
- No `comments` capability — a plain `notes` collection is simpler to get
  right than customAnchors, and doubles as an always-visible feed (the
  "communicate through work done" ask) rather than a per-element pin UI.
- Subscribe once (`onSnapshot`) on the tasks collection and the notes
  collection; render from local state on each snapshot.
- Attribution: write `lastEditedBy: (await user.id())`, never a name.
