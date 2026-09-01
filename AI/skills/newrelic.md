---
name: newrelic
description: Investigate application performance, errors, infrastructure health, deployments, alerts, and agent reporting issues on the New Relic platform using the New Relic CLI and NRQL.
---

# New Relic Investigation

Use the New Relic CLI to gather evidence from New Relic before proposing a fix. Prefer read-only commands and NRQL queries during investigation. Do not expose API keys, personal data, or large unfiltered result sets in responses.

## Quick Decision Tree

- Performance issue, slow requests, or high latency: investigate APM performance.
- Need custom telemetry or time-series data: use NRQL.
- Issue started after a release: inspect deployments and correlate the release with telemetry.
- Alert notification or policy issue: inspect alerts.
- Host, CPU, memory, disk, or process issue: inspect infrastructure.
- Agent is not reporting: run diagnostics and verify connectivity/configuration.

## Operating Rules

1. Establish the scope first: account, region, entity, environment, and time window.
2. Start broad, then narrow. Use short windows such as `SINCE 1 hour ago` before querying longer periods.
3. Compare the affected period with a known-good period whenever possible.
4. Correlate latency, throughput, errors, deployments, and infrastructure signals rather than relying on one metric.
5. State what the data proves, what it suggests, and what remains unknown.
6. Ask for confirmation before changing alert policies, creating deployment markers, or performing any other write operation.

## Setup And Authentication

Install the CLI if it is not already available:

```bash
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash
```

Configure a profile using environment variables. Keep credentials in the environment or a secure secret manager; never put them in source files or chat output.

```bash
export NEW_RELIC_API_KEY="..."       # User key, usually NRAK-...
export NEW_RELIC_ACCOUNT_ID="..."   # Numeric account ID
export NEW_RELIC_REGION="US"        # US or EU

newrelic profile add \
  --profile default \
  --apiKey "$NEW_RELIC_API_KEY" \
  --accountId "$NEW_RELIC_ACCOUNT_ID" \
  --region "$NEW_RELIC_REGION"

newrelic profile default --profile default
newrelic profile list
```

If a command differs by CLI version, check the installed command instead of guessing:

```bash
newrelic --help
newrelic <namespace> --help
```

## Entity Discovery

Find the entity GUID or application ID before making entity-specific requests.

```bash
# Search by name
newrelic entity search --name "my-app"

# List APM applications
newrelic entity search --name "" --type APPLICATION --domain APM

# List hosts
newrelic entity search --name "" --type HOST

# Inspect one entity
newrelic entity get --guid "<GUID>"
```

Confirm that the selected entity and account match the incident. Names are not always unique.

## NRQL Investigation

Run focused queries and preserve the query text and time window with the result.

```bash
newrelic nrql query \
  --accountId "$NEW_RELIC_ACCOUNT_ID" \
  --query "SELECT average(duration) FROM Transaction WHERE appName = 'my-app' SINCE 1 hour ago"
```

Useful starting queries:

```sql
-- Latency and throughput
SELECT average(duration), percentile(duration, 50, 95, 99), rate(count(*), 1 minute)
FROM Transaction
WHERE appName = 'my-app'
SINCE 1 hour ago TIMESERIES

-- Error rate
SELECT percentage(count(*), WHERE error IS true) AS errorRate,
       count(*) AS transactions
FROM Transaction
WHERE appName = 'my-app'
SINCE 1 hour ago TIMESERIES

-- Slowest transaction names
SELECT average(duration), percentile(duration, 95), count(*)
FROM Transaction
WHERE appName = 'my-app'
SINCE 1 hour ago
FACET name
LIMIT 10

-- Recent application errors
SELECT timestamp, error.class, error.message, transactionName
FROM TransactionError
WHERE appName = 'my-app'
SINCE 1 hour ago
LIMIT 100
```

Adapt event names and attributes to the telemetry actually present in the account. If a query returns no data, verify the entity name, event type, attribute names, account, and reporting window before concluding that the system is healthy.

## Performance Triage

1. Identify the affected application and the start time.
2. Query latency percentiles and throughput over time.
3. Facet by transaction name, endpoint, or other high-value dimensions.
4. Check error rate and recent `TransactionError` events.
5. Check external calls, database spans, and infrastructure metrics when available.
6. Compare with a baseline period and inspect deployments near the first degradation.

Report findings in this format:

```text
Scope: entity, account, region, and time window
Observed: measured latency/error/throughput change
Correlated: deployment, dependency, host, or other matching signal
Likely cause: evidence and confidence level
Next check: smallest query or operational action that can confirm it
```

## Deployments

Use deployment markers to correlate releases with telemetry. This is a write operation and requires explicit user intent.

```bash
newrelic apm deployment create \
  --applicationId "<APP_ID>" \
  --revision "v1.2.3" \
  --description "Feature: user auth"
```

Before creating a marker, confirm the application, revision, deployment time, and description. Do not create duplicate markers while investigating.

## Alerts

For alert issues, first determine whether the problem is evaluation, notification, or the underlying signal. Inspect policies, conditions, incidents, and notification channels using the installed CLI's help output. Treat all create, update, delete, enable, and disable commands as write operations requiring confirmation.

## Infrastructure

For host or process symptoms:

1. Find the relevant `HOST` entity and verify its reporting period.
2. Query CPU, memory, disk, network, and process telemetry for the affected hosts.
3. Facet by host and compare affected hosts with healthy peers.
4. Correlate host changes with application latency and errors.

Avoid unbounded host queries. Restrict by entity, time window, and a small result limit.

## Diagnostics And Agent Reporting

Run diagnostics when an agent is missing, stale, misconfigured, or failing to send data:

```bash
newrelic diagnose run
```

Use the diagnostic output to distinguish local configuration, authentication, connectivity, agent compatibility, and missing-telemetry problems. Redact secrets, hostnames, tokens, and customer data before sharing output.

## Common Commands

```bash
# Search an entity
newrelic entity search --name "my-app"

# Query NRQL
newrelic nrql query --accountId "$NEW_RELIC_ACCOUNT_ID" --query "<NRQL>"

# Run diagnostics
newrelic diagnose run
```

## Safety Checklist

- Confirm the active profile before every investigation.
- Use the smallest useful time range and result limit.
- Quote application names and NRQL values correctly.
- Never print or commit `NEW_RELIC_API_KEY`.
- Redact sensitive attributes and stack traces containing user data.
- Get confirmation before deployment markers or alert changes.
- Include the exact query, entity, account, and time window in the investigation notes.
