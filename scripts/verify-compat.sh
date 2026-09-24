#!/usr/bin/env bash
# Conceptual OpenTofu / provider schema check for pathlyhq/pathly examples.
# Does not call the Pathly API. Skips tofu fmt/validate when tofu is missing.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXAMPLE="${ROOT}/examples/complete"
MAIN="${EXAMPLE}/main.tf"

fail() { echo "FAIL: $*" >&2; exit 1; }
ok() { echo "OK: $*"; }

[[ -f "$MAIN" ]] || fail "missing $MAIN"

# Provider source must stay identical to Terraform consumers.
grep -q 'source\s*=\s*"pathlyhq/pathly"' "$MAIN" \
  || fail 'expected required_providers source = "pathlyhq/pathly"'
ok 'provider source pathlyhq/pathly'

# Core resource types (identical API to the Terraform provider).
for type in pathly_scenario pathly_webhook pathly_maintenance_window pathly_sla_target; do
  grep -q "resource \"$type\"" "$MAIN" \
    || fail "example must declare resource \"$type\""
  ok "resource $type present"
done

# Auth documentation contract: env-only token.
grep -q 'PATHLY_API_TOKEN' "${ROOT}/README.md" \
  || fail 'README.md must document PATHLY_API_TOKEN'
ok 'PATHLY_API_TOKEN documented'

# Empty provider block is the recommended pattern (token from env).
grep -qE 'provider\s+"pathly"\s+\{\s*\}' "$MAIN" \
  || fail 'expected provider "pathly" {} (token from PATHLY_API_TOKEN)'
ok 'provider block uses env auth'

if command -v tofu >/dev/null 2>&1; then
  ok "tofu available: $(tofu version | head -n1)"
  (
    cd "$EXAMPLE"
    tofu fmt -check -recursive
    tofu init -backend=false -input=false
    tofu validate
  )
  ok 'tofu fmt + validate passed'
else
  echo "SKIP: tofu not installed — conceptual checks only (install OpenTofu to run fmt/validate)."
fi

echo
echo "All conceptual compatibility checks passed."
