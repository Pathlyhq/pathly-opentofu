# Changelog

All notable changes to this OpenTofu docs/examples mirror are documented here.

## [0.1.0] — 2026-09-23

### Added

- README (EN/FR): same provider source `pathlyhq/pathly`, `tofu init`, auth via
  `PATHLY_API_TOKEN`.
- Complete example: scenario, webhook, maintenance window, SLA target.
- Compatibility notes for Terraform Registry and OpenTofu registry (N / N-1:
  provider v0.1.4 / v0.1.3).
- `scripts/verify-compat.sh` and `scripts/verify-compat.ps1`.
- GitLab CI: `tofu fmt` / `tofu validate` when OpenTofu is available, skip with
  a clear message otherwise.
- Apache-2.0 license.
