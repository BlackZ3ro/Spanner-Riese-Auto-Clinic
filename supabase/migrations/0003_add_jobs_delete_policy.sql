-- Fixes a real bug in 0001_create_jobs_table.sql: it granted `authenticated`
-- staff SELECT/INSERT/UPDATE on jobs, but never DELETE. With RLS enabled and
-- no matching policy, every DELETE against jobs since M2 has silently
-- affected zero rows - PostgREST still returns 204 either way, so this went
-- unnoticed through several rounds of "test data cleanup" that didn't
-- actually clean anything up. Confirmed directly: deleting a row returns
-- 204, but the row is still there on the next authenticated read.
--
-- Purely additive - one more policy, no existing behaviour changes.

create policy "Authenticated staff can delete jobs"
  on public.jobs for delete
  to authenticated
  using (true);
