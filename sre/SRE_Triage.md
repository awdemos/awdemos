An SRE triage workflow typically follows these stages:

1. **Triage**
2. **Examine**
3. **Diagnose**
4. **Test**
5. **Cure**

This structured approach ensures a systematic investigation, with each phase yielding specific outcomes.

**Initiating the Workflow:**

The workflow is can be triggered manually or by an alert, which could be:

- An automated notification due to a Service Level Objective (SLO) breach, detailing the metrics involved.
- A problem report from a user, ideally specifying the expected vs. actual behavior.
- Verifying the problem is not a false positive.

**Triage Stage:**

The primary goal at this stage is to quickly restore system health, focusing on remediation to prevent further escalation. Strategies may include:

- Increasing server capacity
- Redirecting traffic to alternate data centers
- Limiting incoming requests
- Switching to a read-only mode

The objective is not to solve the underlying issue but to mitigate immediate impact, aiming for a stable system to allow for deeper investigation.

**Examination Stage:**

Here the focus shifts to understanding the problem's nature and triggers. Effective usage of monitoring and logging are critical, enabling the identification of trends or spikes that hint at the issue's onset. Tools like service graphs and distributed tracing can pinpoint potential failure points and track request chains, respectively.

**Diagnosis Stage:**

This phase involves identifying the root cause. A thorough examination of the system's components, their interactions, and data flow is crucial. Key questions include:

- What is the system doing?
- Why is the behavior unexpected?
- Where are resources being allocated?
- When did the issue begin?

**Testing Stage:**

The aim is to isolate the probable cause from a list of possibilities. This might involve:

- Executing HTTP requests to analyze responses,
- Checking database access permissions,
- Tracing SQL queries,
- Conducting network path analyses.

Documenting each step is essential, particularly any changes made during the process.

**Curing Stage:**

The final step involves applying a fix with strong confidence in the proposed solution. The outcome might be a fully resolved issue or a temporary mitigation, and may involve detailed documentation for a long-term solution. In cases where a definitive solution isn't found, outlining necessary instrumentation for future investigations is key.

Upon concluding the investigation and resolving the incident, a postmortem analysis is conducted by the stakeholders to review what transpired, talk through its impact to all concerned persons, and assign tasks to mitigate its ability to reoccur.

I like to perform these within a couple of days of the incident so that its impact is still fresh in peoples mind and to gather any information discovered after the incident was resolved.