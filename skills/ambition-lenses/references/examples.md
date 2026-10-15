# Worked examples

Each example shows what the Speed-only answer would be, then what the loop adds. "Fold in" means do it without asking. "Offer" means suggest it in one line.

## 1. Bug: "Fix this null pointer exception"

- **Speed only**: add a null check where it crashes.
- **Altitude**: the outcome is that this class of crash stops happening. Offer a type or validation at the boundary so nulls can't get in.
- **Depth**: a senior engineer reads the stack trace, reproduces the crash, and traces the null back to where it was created. Fold in: fix at the source and add a regression test that fails before the fix.
- **Range**: reliability engineering says to check sibling paths that share the same input. Fold in: search for the other call sites.
- **Self-check**: the urge to report "fixed" after one edit is premature done. Run the test first.

## 2. System: "Add an endpoint that sends a welcome email on signup"

- **Speed only**: call the email API inside the signup handler.
- **Altitude**: the outcome is that every new user reliably gets one welcome email, without slowing signup.
- **Depth**: a systems engineer moves the send onto a queue so signup doesn't wait on the email provider, makes the send idempotent (keyed on user ID) so retries can't double-send, and logs failures. Fold in what the stack already supports.
- **Range**: the transactional outbox pattern from distributed systems guarantees the email event isn't lost if the process crashes between the database write and the send. Offer it if the stack has no queue.
- **Scale check**: at 10x signups, is the provider's rate limit the binding constraint? Note it.
- **Self-check**: check the email SDK's current signature in the docs; don't write it from memory.

## 3. Data: "Why did conversions drop last week?"

- **Speed only**: compare last week's rate to the week before and describe the difference.
- **Altitude**: the outcome is a decision. Do we fix something, or is this noise?
- **Depth**: a data scientist pulls the raw events, checks for tracking gaps, duplicate events and timezone shifts, then segments by channel, device and page. All numbers come from code.
- **Range**: statistical process control asks whether the drop is outside normal weekly variation. Fold in: a control band from the last 12 weeks.
- **Self-check**: anchoring on the user's framing is the risk here. "Dropped" is a claim; test it before explaining it.

## 4. Performance: "This page is slow, make it faster"

- **Speed only**: add caching.
- **Altitude**: the outcome is that users experience a fast page, so measure what users actually wait on.
- **Depth**: profile first. Find the binding constraint, which is often an N+1 query, an unindexed column or a large unoptimized asset. Fix that one thing and measure again.
- **Range**: Amdahl's law says optimizing the part that's 5% of the time can't help. Queueing theory says that at high utilization, latency explodes non-linearly, so check load as well as code.
- **Scale check**: with 100x the rows, does the query plan change? Check the complexity of the hot path.

## 5. ML/LLM feature: "Use AI to categorize support tickets"

- **Speed only**: send each ticket to an LLM with a prompt listing the categories.
- **Altitude**: the outcome is tickets reaching the right person faster. Is a model even needed, or would keyword rules cover 80% of tickets?
- **Depth**: build a labeled evaluation set of 100 real tickets first, set a baseline, then measure. Constrain the output to the category list, validate it, and route low-confidence cases to a person.
- **Range**: information retrieval offers cheap embedding-based nearest neighbors as a baseline; operations research asks what misrouting costs compared with a slower route.
- **Scale check**: cost per ticket and latency at expected monthly volume.

## 6. Non-engineering: "Write a service page for airport transfers"

The philosophy transfers outside code.

- **Speed only**: write the page.
- **Altitude**: the outcome is bookings from search. Offer a template for every airport and city served.
- **Depth**: an SEO lead checks real search queries, competitor pages and Search Console data before writing, then adds structured data and internal links.
- **Range**: conversion design puts price signals and the booking action above the fold.
- **Self-check**: don't invent search volumes. Pull them from a tool or leave them out.
