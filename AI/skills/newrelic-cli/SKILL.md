---
name: newrelic-cli
description: >
  Query and manage New Relic observability data using the newrelic CLI across all
  your organization's accounts. Trigger on: newrelic, nrql, apm, deployment marker,
  alert policy, observability query, error rate, throughput, latency, SLO/SLI.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  tools: [newrelic-cli]
---

## What this skill does

Translates natural-language observability questions into `newrelic` CLI commands,
resolving account names to numeric IDs automatically. It knows every
New Relic account, which environment and service slot each belongs to, and
which region (US/EU) to use.

Prefer read-only commands and focused NRQL queries during investigation. Gather
evidence before proposing a fix, and distinguish what the data proves from what it
only suggests.

## Quick decision tree

- Performance issue, slow requests, or high latency: investigate APM performance.
- Custom telemetry or time-series data: use NRQL.
- Issue started after a release: inspect deployments and correlate the release with telemetry.
- Alert notification or policy issue: inspect alerts.
- Host, CPU, memory, disk, or process issue: inspect infrastructure.
- Agent is not reporting: run diagnostics and verify connectivity and configuration.

## Investigation rules

1. Establish the account, region, entity, environment, and time window first.
2. Start with a short window such as `SINCE 1 hour ago`, then expand only when needed.
3. Compare the affected period with a known-good period whenever possible.
4. Correlate latency, throughput, errors, deployments, and infrastructure signals.
5. Restrict queries by entity, time window, facets, and result limit; avoid unbounded results.
6. Confirm the selected entity and account because entity names are not always unique.
7. Ask for confirmation before changing alert policies, creating deployment markers, or performing any other write operation.

## Installation and authentication

If the CLI is not installed:

```bash
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash
```

Configure credentials through environment variables or a secure secret manager. Never
put API keys in source files or include them in responses.

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

If a command differs by CLI version, inspect the installed command instead of guessing:

```bash
newrelic --help
newrelic <namespace> --help
```

## Account resolution

A bundled `accounts.json` (sibling to this file) maps every New Relic
account. Read it at the start of any task to resolve accounts.

### Resolution rules

1. If the user names an **environment** (e.g. "production", "test", "uk-prod"),
   match against the `environment` field.
2. If they name a **slot** (e.g. "services", "envoy", "cardinal"), match against
   the `slot` field within the target environment.
3. If they give a **numeric account ID**, use it directly.
4. If they name an **alias** (e.g. "Acme_Corp_1", "My_Org"), match
   against the `alias` field.
5. **Defaults** when no account is specified:
   - Service-specific queries (transactions, throughput, errors) ->
     `$DEFAULT_SERVICES_ACCOUNT`
   - General queries (infrastructure, custom events) ->
     `$DEFAULT_MAIN_ACCOUNT`

Always confirm which account you resolved to before running the query, e.g.:
"Querying **Services Production** ($ACCOUNT_ID)..."

## CLI command reference

### NRQL queries

The most common operation. Always include `--accountId` and default to
`--format JSON` for structured output.

```bash
newrelic nrql query --accountId <ID> --query '<NRQL>' --format JSON
```

**Example patterns:**

```bash
# Transaction throughput
newrelic nrql query --accountId $ACCOUNT_ID \
  --query "SELECT rate(count(*), 1 minute) FROM Transaction WHERE appName = 'my-service' TIMESERIES SINCE 1 hour ago" \
  --format JSON

# Error rate
newrelic nrql query --accountId $ACCOUNT_ID \
  --query "SELECT percentage(count(*), WHERE error IS true) FROM Transaction WHERE appName = 'my-service' SINCE 1 hour ago" \
  --format JSON

# P99 latency
newrelic nrql query --accountId $ACCOUNT_ID \
  --query "SELECT percentile(duration, 99) FROM Transaction WHERE appName = 'my-service' TIMESERIES SINCE 1 hour ago" \
  --format JSON
```

### Entity search

Find applications, hosts, containers, and other entities.

```bash
newrelic entity search --name <NAME>
newrelic entity search --name <NAME> --domain APM --type APPLICATION
newrelic entity search --tag "environment:production"
```

Useful filters: `--domain` (APM, INFRA, BROWSER, SYNTH, etc.),
`--type` (APPLICATION, HOST, CONTAINER, etc.), `--tag`, `--alert-severity`,
`--reporting`.

List all APM applications or hosts and inspect a specific entity when a GUID is needed:

```bash
newrelic entity search --name "" --type APPLICATION --domain APM
newrelic entity search --name "" --type HOST
newrelic entity get --guid "<GUID>"
```

### APM operations

```bash
# Search for an application
newrelic apm application search --accountId <ID> --name <APP_NAME>

# Record a deployment
newrelic apm deployment create --applicationId <APP_ID> --revision <SHA>
```

### Profile management

Profiles store API keys and default account IDs for repeated use.

```bash
newrelic profile list
newrelic profile add --name <PROFILE> --apiKey <KEY> --region <US|EU> --accountId <ID>
newrelic profile default --name <PROFILE>
```

### NerdGraph (GraphQL)

For advanced queries not covered by built-in commands.

```bash
newrelic nerdgraph query '{ actor { user { email } } }'
```

### Custom events

```bash
newrelic events post --accountId <ID> --event '{"eventType":"Deployment","revision":"abc123"}'
```

## Performance triage

1. Identify the affected application and approximate start time.
2. Query latency percentiles and throughput over time.
3. Facet by transaction name, endpoint, or another high-value dimension.
4. Check error rate and recent `TransactionError` events.
5. Check external calls, database spans, and infrastructure metrics when available.
6. Compare with a baseline period and inspect deployments near the first degradation.

Summarize findings using this format:

```text
Scope: entity, account, region, and time window
Observed: measured latency, error, or throughput change
Correlated: deployment, dependency, host, or other matching signal
Likely cause: evidence and confidence level
Next check: smallest query or operational action that can confirm it
```

## Alerts

For alert issues, determine whether the problem is evaluation, notification, or the
underlying signal. Inspect policies, conditions, incidents, and notification channels
using the installed CLI's help output. Treat create, update, delete, enable, and disable
commands as write operations requiring confirmation.

## Infrastructure

For host or process symptoms:

1. Find the relevant `HOST` entity and verify its reporting period.
2. Query CPU, memory, disk, network, and process telemetry for affected hosts.
3. Facet by host and compare affected hosts with healthy peers.
4. Correlate host changes with application latency and errors.

## Diagnostics and agent reporting

Run diagnostics when an agent is missing, stale, misconfigured, or failing to send data:

```bash
newrelic diagnose run
```

Use the output to distinguish local configuration, authentication, connectivity, agent
compatibility, and missing-telemetry problems. Redact secrets, hostnames, tokens, and
customer data before sharing diagnostic output.

## Environment variables

| Variable | Purpose |
|---|---|
| `NEW_RELIC_API_KEY` | Personal API key (NRAK-...) |
| `NEW_RELIC_ACCOUNT_ID` | Default account ID |
| `NEW_RELIC_REGION` | US (default) or EU |
| `NEW_RELIC_LICENSE_KEY` | License key (for posting events) |

## Workflow

1. **Parse intent**: What does the user want to know or do?
2. **Resolve account**: Read `accounts.json`, match environment/slot/alias.
3. **Build command**: Construct the `newrelic` CLI invocation.
4. **Show the user**: Display the resolved account and command before running.
5. **Execute**: Run via Bash and return results.
6. **Interpret**: Summarize the data in plain language -- highlight anomalies,
   trends, or notable values.

## Common NRQL patterns

These patterns cover the most frequent observability questions:

```sql
-- Service health overview
SELECT count(*), average(duration), percentage(count(*), WHERE error IS true)
FROM Transaction WHERE appName = '{service}'
SINCE 1 hour ago

-- Top slow transactions
SELECT average(duration), count(*)
FROM Transaction WHERE appName = '{service}'
FACET name SINCE 1 hour ago LIMIT 10

-- Error breakdown
SELECT count(*) FROM TransactionError
WHERE appName = '{service}' FACET error.class SINCE 1 hour ago

-- Infrastructure (CPU/memory) -- use main account
SELECT average(cpuPercent), average(memoryUsedPercent)
FROM SystemSample WHERE hostname LIKE '%{service}%'
SINCE 1 hour ago TIMESERIES

-- Kafka consumer lag -- use services account
SELECT average(consumer.totalLag)
FROM KafkaOffsetSample WHERE consumerGroup LIKE '%{service}%'
FACET topic SINCE 1 hour ago
```

## Multi-account queries

When a question spans multiple accounts (e.g. "compare prod vs test error
rates"), run separate queries against each account and present the results
side by side. Label each result clearly with the account name and environment.

## Error handling

- If `newrelic` is not installed, suggest: `brew install newrelic-cli`
- If authentication fails, check `newrelic profile list` and suggest
  `newrelic profile add`
- If an account ID is ambiguous (e.g. "services" without an environment),
  ask the user to clarify which environment

## Safety checklist

- Confirm the active profile before every investigation.
- Use the smallest useful time range and result limit.
- Quote application names and NRQL values correctly.
- Never print or commit `NEW_RELIC_API_KEY`.
- Redact sensitive attributes and stack traces containing user data.
- Include the exact query, entity, account, and time window in investigation notes.
