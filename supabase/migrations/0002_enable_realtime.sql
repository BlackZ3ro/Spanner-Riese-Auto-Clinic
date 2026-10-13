-- M7 (FR-09): the web app subscribes to live changes on bookings/stock_items, but
-- Supabase Realtime is not enabled for these tables in this project yet - confirmed
-- directly by subscribing and getting back:
--   "Unable to subscribe to changes with given parameters. Please check Realtime is
--    enabled for the given connect parameters: [... table: bookings ...]"
--
-- Run this in the Supabase SQL editor (or toggle it per-table under Database >
-- Replication in the dashboard, which does the same thing). Purely additive -
-- adds these tables to the existing supabase_realtime publication, doesn't change
-- any table structure or touch anything mobile or web already does.

alter publication supabase_realtime add table public.bookings;
alter publication supabase_realtime add table public.stock_items;
