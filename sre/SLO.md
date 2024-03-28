Ensuring your services operate efficiently with minimal maintenance requires addressing several key questions, such as:

- What is the current service level of your applications?
- What service level does the organization expect?
- How is the actual service level monitored?
- What actions are taken when the service level drops below expectations?

Addressing these questions provides clear direction on setting target service levels, monitoring actual service performance, and taking corrective actions when necessary.

Traditionally, operations teams have relied on Service Level Agreements (SLAs) to gauge system health, often aiming for a 99% availability target. However, this approach prompts critical inquiries:

- From a business perspective, why settle for 99%? If achieving 99% is possible, striving for 100% availability should be the goal.
- From an IT management viewpoint, what are the implications of an SLA breach? How is a drop to 98% detected, and how can service be restored to within acceptable limits?

Site Reliability Engineering (SRE) introduces a different approach by defining service health through multiple Service Level Objectives (SLOs), focusing on user experience rather than operational metrics. This shift replaces a broad 99% availability SLA with specific, targeted SLOs, such as:

- 99.9% of requests will be processed successfully.
- 90% of responses will be delivered within 0.5 seconds.
- 99% of responses will be delivered within 2 seconds.

These SLOs aim to track and enhance user experience by establishing a reliability threshold that maintains customer satisfaction.

Accepting that no application can achieve 100% error-free operation, SLOs set realistic performance thresholds. For instance, considering a 28-day period for monitoring response times, a 99% target allows for approximately 403 minutes (about 7 hours monthly) outside the SLO. In contrast, a 99.9% target reduces this margin to just 40 minutes monthly, illustrating the diminishing returns of pursuing higher availability targets.

In modern distributed systems, achieving high availability targets, such as four nines (99.99%), can be challenging and costly, often requiring complex architectures and significant investment. However, for most applications, such stringent service levels are unnecessary. Users are generally forgiving of occasional delays, likely resorting to simple workarounds like refreshing the page.

### Error Budgets

SLOs should represent achievable goals, agreed upon by stakeholders, including business product owners, development teams, and SRE teams. The concept of an error budget, which is the difference between 100% and the SLO target, provides a buffer for making system changes without excessively compromising service quality. This budget is crucial for managing the pace of product releases, as most service disruptions result from updates or configuration changes.

For new products, a lower SLO may be acceptable to allow for rapid development and experimentation. Conversely, established products with a large user base may require tighter SLOs to ensure stability over introducing new features. Exceeding the error budget necessitates a policy for restoring service levels, outlined in an error budget policy document agreed upon by business and IT teams. This policy defines the response to SLO breaches, ranging from reprioritizing feature development to imposing a complete change freeze, except for critical security updates.

SLOs and error budgets provide a framework for balancing user satisfaction with product development velocity, with the error budget policy serving as a contract to manage this balance effectively.
