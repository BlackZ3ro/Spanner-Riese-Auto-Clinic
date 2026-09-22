# Project Risk Register

**Likelihood and Impact** are rated Low / Medium / High (1–3).  
**Score** = Likelihood × Impact, bucketed as:  
- Low (1–2)  
- Medium (3–4)  
- High (6–9)

| ID   | Risk Statement                                                                 | Category                  | Likelihood | Impact | Score / Level | Mitigation                                                                 | Contingency                                                                 | Owner   | Status     |
|--------------------------------------------------------------------------------------|---------------------------|------------|--------|---------------|----------------------------------------------------------------------------|-----------------------------------------------------------------------------|---------|------------|
| R-01 | Michael Riese’s availability for feedback and confirmation reduces as the semester progresses, delaying requirement sign-off. | Stakeholder               | Medium     | High   | 6 / High      | Agree a light-touch, low-effort check-in channel (WhatsApp) early and batch questions to minimise his time burden. | Fall back on previously confirmed requirements and document any assumption explicitly for later confirmation. | Gary    | Open       |
| R-02 | The stakeholder requests additional features once he sees the working prototype, expanding scope beyond what the semester allows. | Scope                     | Medium     | Medium | 4 / Medium    | Maintain a clearly refined, agreed scope and log any new request in the requirements change log rather than building it immediately. | Park new requests as a “Phase 2 / future work” list to revisit after submission. | Denny   | Open       |
| R-03 | The web application (ASP.NET) has not yet started and the group has limited prior ASP.NET experience, risking a late or rushed build. | Technical                 | Medium     | High   | 6 / High      | Start ASP.NET scaffolding and the Supabase connection early in Phase 2, in parallel with mobile work rather than after it. | Reduce the web app to a read-only dashboard of the same Supabase data if full parity cannot be reached in time. | Khumo   | Open       |
| R-04 | The project outgrows Supabase’s free-tier storage/bandwidth limits before the project is demonstrated. | Technical / Infrastructure| Low        | Medium | 2 / Low       | Monitor usage via the Supabase dashboard monthly; avoid storing large files (e.g. full-resolution photos) unnecessarily. | Compress or offload large assets, or apply for Supabase’s student/hobby tier if a limit is approached. | Gary    | Open       |
| R-05 | Real-time sync between the mobile app and web app produces conflicting or duplicate records (e.g. two staff editing the same job). | Technical / Integration   | Low        | Medium | 2 / Low       | Use Supabase’s row-level timestamps and design simple, single-writer-per-record flows where possible. | Add a manual “last updated by” field so conflicts are visible and can be corrected by staff. | Gary    | Open       |
| R-06 | A group member loses connectivity or availability at short notice (already experienced once this phase), delaying their task. | Team / Resource           | Medium     | Medium | 4 / Medium    | Keep the progress tracker current so gaps are visible early, and maintain a WhatsApp-first coordination habit that doesn’t depend on any one channel. | Reassign or share the affected task temporarily among members with capacity. | Wisani  | Monitoring |
| R-07 | Task completion becomes uneven across members as deadlines approach, with some falling behind. | Team / Schedule           | Medium     | Medium | 4 / Medium    | Review the Task Progress tracker weekly and flag slipping tasks before they become blockers. | Redistribute the task or bring in support from a member with lighter load (as already planned for Khumo supporting Gary). | Wisani  | Monitoring |
| R-08 | The formal stakeholder interview (U1-05) and supporting evidence are not finalised in time to support the SRS. | Documentation / Evidence  | Low        | High   | 3 / Medium    | Schedule the interview as a fixed WhatsApp call this week rather than leaving it open-ended, given direct access to the stakeholder. | Use the existing informal discussion as interim evidence, clearly logged as informal pending the formal record. | Gary    | Open       |
| R-09 | The GitHub repository is not set up in time, leaving no evidence of individual contribution as required by the assessment. | Project Management        | Low        | High   | 3 / Medium    | Kea has taken ownership of repository setup and should create it with a proper README promptly. | If delayed, migrate local project history into the repository as soon as it is created so contribution history is not lost. | Kea     | Open       |
| R-10 | Customer and vehicle data (contact details, VIN, licence plate) is exposed through inadequate access control or accidentally committed to GitHub. | Legal / Compliance        | Low        | High   | 3 / Medium    | Apply Supabase Row Level Security from the start and add real stakeholder data to `.gitignore` / exclude from any repository content. | Rotate any exposed credentials immediately and review repository history to remove the exposure if it occurs. | Denny   | Open       |
| R-11 | PDF invoice generation does not integrate cleanly with the chosen library, producing incorrectly formatted or incomplete invoices. | Technical                 | Low        | Medium | 2 / Low       | Prototype the PDF generation step early with sample data rather than leaving it until the end of development. | Fall back to a simpler, text-based PDF layout if a more polished template proves too time-consuming to implement. | Gary    | Open       |
| R-12 | The Microsoft Project schedule underestimates remaining effort, causing later phases to slip. | Schedule                  | Medium     | Medium | 4 / Medium    | Base task durations on actual Phase 1 pace rather than optimistic estimates, and review the schedule against real progress each phase. | Cut lower-priority scope items (see refined scope) rather than compressing testing or integration time. | Denny   | Open       |

---

## Three Highest Project Risks

- **R-01** — Stakeholder availability declining over the semester (**Score 6 / High**)  
  Everything downstream depends on continued access to Michael Riese.

- **R-03** — ASP.NET web app not yet started, limited prior experience (**Score 6 / High**)  
  The single biggest technical gap between current progress and the full scope.

- **R-12** — Microsoft Project schedule underestimates remaining effort (**Score 4 / Medium**)  
  The next-highest risk, and directly relevant once the current draft schedule is reviewed against actual Phase 1 pace.
