# OpenTofu compatibility — `pathlyhq/pathly`

## Same binary, same source address

OpenTofu and Terraform load the **same** provider plugin binary published as
`pathlyhq/pathly` (identical archives, signatures and schema). There is no
separate OpenTofu fork of the Go code and no second package to install — only
the CLI name differs (`tofu` vs `terraform`).

| Client | Command | Provider source |
|---|---|---|
| Terraform | `terraform init` | `pathlyhq/pathly` |
| OpenTofu | `tofu init` | `pathlyhq/pathly` |

Constraint used in examples: `version = "~> 0.1"` (patch stream while API is v1).

## Registries

### Terraform Registry (HashiCorp)

- Canonical publish target for the provider binary and docs.
- Address: `registry.terraform.io/pathlyhq/pathly`.
- OpenTofu can pull from this registry (default provider network for many installs).

### OpenTofu Registry

- OpenTofu maintains its own registry / mirror layer for providers.
- When `pathlyhq/pathly` is listed there, `tofu init` may resolve through it
  without changing the `source` string in `.tf` files.
- Until then, configure OpenTofu to use the Terraform Registry hostname, or
  rely on the default mirror behaviour of your OpenTofu version.

No change to `required_providers` is required when switching clients:

```hcl
required_providers {
  pathly = {
    source  = "pathlyhq/pathly"
    version = "~> 0.1"
  }
}
```

## Versions tested (N / N-1)

Compatibility is validated against the **current** provider release and the
**previous** patch on the same minor line (N and N-1).

| Provider | OpenTofu | Terraform | Status |
|---|---|---|---|
| **v0.1.4** (N) | ≥ 1.6 / 1.7 / 1.8 | ≥ 1.6 | Supported |
| **v0.1.3** (N-1) | ≥ 1.6 / 1.7 / 1.8 | ≥ 1.6 | Supported |
| older `0.1.x` | ≥ 1.6 | ≥ 1.6 | Best-effort |

Update this table when a new provider patch is tagged. While the Pathly API
stays on v1, provider versions increment one patch at a time (`v0.1.4` →
`v0.1.5`, …) with no skipped numbers.

## Protocol / schema

The provider is built with **terraform-plugin-framework** and speaks the
standard Terraform Plugin Protocol. OpenTofu implements that protocol for
third-party providers, so:

- Resource types (`pathly_scenario`, `pathly_webhook`,
  `pathly_maintenance_window`, `pathly_sla_target`, `pathly_settings`) are
  identical.
- Auth remains `PATHLY_API_TOKEN` (optional `PATHLY_API_URL`).
- State format is interchangeable for the same provider version when moving
  between `terraform` and `tofu` on the same backend (still encrypt the backend:
  webhook secrets live in state).

## Conceptual schema check

[`scripts/verify-compat.sh`](../scripts/verify-compat.sh) and
[`scripts/verify-compat.ps1`](../scripts/verify-compat.ps1) assert that the
example declares the expected provider source and resource types. They do not
call the Pathly API. With OpenTofu installed they additionally run
`tofu fmt -check` and `tofu validate` after `tofu init -backend=false`.

## Security notes

- Prefer `PATHLY_API_TOKEN` over the `api_token` provider argument (state leak).
- Keep remote state encrypted (webhook HMAC secrets are stored in state).
- Scope API keys to the minimum needed for the resources you manage.
