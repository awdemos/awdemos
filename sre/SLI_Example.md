Service Level Indicators (SLIs) serve as critical metrics for continuously monitoring the performance of your system to ensure it aligns with set objectives. 

The cornerstone of SLIs is their measurability - these are quantifiable metrics that can be automatically gathered and objectively evaluated. Although they correlate with user experience, their main attribute is their measurability.

For example, tracking HTTP status codes and response times can shed light on the latency and error rates encountered by users. The SLIs chosen for your service will vary based on the service type. For instance, a batch processing system may monitor the quantity of records processed accurately and the job's duration. In contrast, a service that responds to requests, such as a website or REST API, might prioritize measuring availability and latency.

- **Availability** refers to the proportion of successful requests out of the total requests made.
- **Latency** measures the time required to respond to requests.

Expressing SLIs in percentage terms is advantageous as it allows for a standardized comparison across diverse data types.

To calculate availability for a web application, you can use the formula:
`Availability = (Number of Successful Requests / Total Number of Requests) * 100`

For instance, if there are 10,000 requests within a given timeframe and 9,600 of these requests return a successful response code, then the SLI for availability stands at 96%.

Latency is more effectively represented through percentiles, offering a view into the distribution of response times, which is more informative than a simple average.

Consider a scenario with 5,000 requests where the mean response time is 1.5 seconds. This average could imply uniform response times of 1.5 seconds across all requests, or it might mean that 4,500 requests were answered in half a second while the remaining 500 took 10 seconds each. Percentiles help illustrate this distribution, enabling the definition of a percentile-based SLI.

In this context, one might observe that:
- 80% of requests receive a response within half a second,
- 92% within two seconds, and
- 98% within five seconds.

SLIs are not only used for continuous system performance monitoring but also assist in defining Service Level Objectives (SLOs).

Without predetermined reliability targets, assessing current performance levels with SLIs can offer a practical starting point for setting objectives. For example, with an availability SLI of 96%, one might consider this acceptable, factoring in that some errors may not significantly impact users. However, without specific data, further analysis might be required to determine if a higher target, such as 99% or 99.9%, is feasible.

Addressing uneven latency distribution might involve adjusting the SLO to relax the lower threshold while tightening the upper limit. Aiming for 90% of responses within 800 ms and 95% within 2 seconds could be a goal, pending analysis for feasibility before formal adoption and agreement for the service.

Each SLO is associated with its own error budget, and exceeding these budgets triggers the error budget policy. Thus, these figures must be realistic and reflective of a satisfactory user experience.

Decisions on launching new SLOs might be influenced by the likelihood of breaching them in the initial period. Opting to proceed might be a strategy to immediately engage the error budget policy, thereby enhancing system reliability.

The duration covered by SLOs is also crucial. Shorter periods allow for rapid adjustments but offer limited error budgets. Conversely, longer periods provide more leeway for extensive work but delay feedback. A commonly recommended period by SRE practices is 28 days, approximating a calendar month while offering a consistent timeframe for substantial work.

Consistent monitoring over a fixed period can be challenging, especially with variable traffic patterns, such as weekend spikes. Therefore, adhering to a 28-day cycle is advisable unless there's a compelling reason for alteration.
