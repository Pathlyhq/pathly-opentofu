# Pathly + OpenTofu

**English** · [Français](README.fr.md) · [Español](README.es.md)


[![CI](https://gitlab.com/pathlyhq/pathly-opentofu/badges/main/pipeline.svg)](https://gitlab.com/pathlyhq/pathly-opentofu/-/pipelines)
[![Powered by Pathly](https://img.shields.io/badge/Powered%20by-Pathly-0B5FFF?style=flat-square)](https://pathlyhq.com)
[![Website](https://img.shields.io/badge/Website-pathlyhq.com-111827?style=flat-square)](https://pathlyhq.com)
[![API docs](https://img.shields.io/badge/API-developers-2563eb?style=flat-square)](https://pathlyhq.com/en/developers)
[![Start free](https://img.shields.io/badge/Solo-start%20free-16a34a?style=flat-square)](https://pathlyhq.com/en/login?mode=signup)

> **Get started in one click.** Create a free account on [Pathly](https://pathlyhq.com) ([sign up](https://pathlyhq.com/en/login?mode=signup)), create an API key in the console, then export `PATHLY_API_TOKEN`. This project is the official bridge to [Pathly monitoring](https://pathlyhq.com) — real-browser and HTTP checks for checkout, login and availability, with data hosted in the EU. Full API reference: [pathlyhq.com/en/developers](https://pathlyhq.com/en/developers).

## Same provider binary as Terraform

OpenTofu does **not** need a separate Pathly plugin. It loads the **identical**
provider binary published as
[`pathlyhq/pathly`](https://registry.terraform.io/providers/pathlyhq/pathly)
(same checksums, same GPG signature, same schema). Only the CLI changes
(`tofu` instead of `terraform`). Keep `source = "pathlyhq/pathly"` in
`required_providers`.

This repository is the OpenTofu-facing docs and examples mirror. It does **not**
duplicate Go provider code. The implementation lives in
[`pathly-terraform-provider`](https://github.com/pathlyhq/pathly-terraform-provider)
(and its GitLab mirror). See [`docs/compatibility.md`](docs/compatibility.md).

> **CI badge:** placeholder GitLab path `pathlyhq/pathly-opentofu` — adjust
> `GROUP/PROJECT` once the public mirror URL is final.

```hcl
terraform {
  required_version = ">= 1.6"
  required_providers {
    pathly = {
      source  = "pathlyhq/pathly"
      version = "~> 0.1"
    }
  }
}

provider "pathly" {}

resource "pathly_scenario" "checkout" {
  name         = "Checkout"
  url          = "https://shop.example.com/cart"
  interval_sec = 300
  expect_text  = "Your cart"
}
```

```sh
export PATHLY_API_TOKEN="sp_…"
tofu init
tofu plan
```

## Authentication

| Variable | Purpose |
|---|---|
| `PATHLY_API_TOKEN` | Organization API key (`sp_` prefix). **Required.** |
| `PATHLY_API_URL` | API base. Defaults to `https://api.pathlyhq.com`. |

Never put the token in a `.tf` file: an `api_token` attribute would land in
plaintext state. The environment variable is the only path that leaves no
trace in the repository or the state file.

## Install

1. Install [OpenTofu](https://opentofu.org/docs/intro/install/) ≥ 1.6.
2. Copy [`examples/complete`](examples/complete) or start from the snippet above.
3. Export `PATHLY_API_TOKEN`, then run `tofu init` / `tofu plan` / `tofu apply`.

OpenTofu resolves `pathlyhq/pathly` from the Terraform Registry mirror (and
from the OpenTofu registry when the provider is listed there). See
[`docs/compatibility.md`](docs/compatibility.md).

## Import

Same import IDs and `import` blocks as the Terraform provider. Prefer the
upstream example
[`examples/import`](https://github.com/pathlyhq/pathly-terraform-provider/tree/main/examples/import)
(or the sibling `pathly-terraform-provider` checkout):

```hcl
import {
  to = pathly_scenario.checkout
  id = "mon_…"
}
```

```sh
tofu import pathly_scenario.checkout mon_…
```

## Resources (identical API to the Terraform provider)

| Resource | Role |
|---|---|
| `pathly_scenario` | HTTP check or browser journey |
| `pathly_webhook` | Signed outbound webhook |
| `pathly_maintenance_window` | One-off or weekly maintenance |
| `pathly_sla_target` | Availability objective / error budget |
| `pathly_settings` | Organization settings |

Full schema reference: upstream provider docs. Complete OpenTofu example:
[`examples/complete`](examples/complete).

## Verify

```sh
# Unix
./scripts/verify-compat.sh

# Windows
pwsh ./scripts/verify-compat.ps1
```


## Related packages

| Package | Role |
|---|---|
| [pathly-terraform-provider](https://github.com/pathlyhq/pathly-terraform-provider) | Provider implementation |
| [pathly-cdktf](https://github.com/pathlyhq/pathly-cdktf) | CDK for Terraform |
| [pathly-pulumi](https://github.com/pathlyhq/pathly-pulumi) | Pulumi |
| [pathly-ansible](https://github.com/pathlyhq/pathly-ansible) | Ansible |
| [Pathly product](https://pathlyhq.com) | [Pathly monitoring](https://pathlyhq.com) |
## About Pathly

[Pathly](https://pathlyhq.com) is synthetic monitoring for agencies and e-commerce: replay the customer journey, catch broken checkouts before your clients call, and keep evidence (screenshot, step, runbook) ready for the invoice. Product: [pathlyhq.com](https://pathlyhq.com) · Developers: [pathlyhq.com/en/developers](https://pathlyhq.com/en/developers) · Status & pricing: [pathlyhq.com/en/pricing](https://pathlyhq.com/en/pricing).

## Author

| | |
|---|---|
| **Company** | Pathly |
| **Author** | Simon Raynaud / keyral |

See [AUTHORS](AUTHORS).

## License
Apache-2.0. Provider binary licensing follows the upstream provider repository.
