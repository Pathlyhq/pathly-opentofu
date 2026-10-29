/*
 * OpenTofu complete example — identical API to the Terraform provider
 * pathlyhq/pathly. Auth via PATHLY_API_TOKEN only (never in .tf).
 *
 *   export PATHLY_API_TOKEN="sp_…"
 *   tofu init && tofu plan
 */

terraform {
  required_version = ">= 1.6"
  required_providers {
    pathly = {
      source  = "pathlyhq/pathly"
      version = "~> 0.1"
    }
  }
}

# Token from PATHLY_API_TOKEN; optional PATHLY_API_URL.
provider "pathly" {}

resource "pathly_scenario" "journey" {
  for_each = var.journeys

  name         = each.value.name
  url          = each.value.url
  interval_sec = each.value.interval_sec
  expect_text  = each.value.expect_text

  max_latency_ms  = each.value.max_latency_ms
  expected_status = 200
  severity        = each.value.severity
  folder          = var.folder
  tags            = concat(["opentofu", var.environment], each.value.tags)
  runbook         = each.value.runbook
}

resource "pathly_sla_target" "objective" {
  for_each = { for key, j in var.journeys : key => j if j.severity == "critical" }

  scenario_id          = pathly_scenario.journey[each.key].id
  name                 = "${each.value.name} — ${var.objective_pct} %"
  objective_pct        = var.objective_pct
  window_days          = 30
  exclude_maintenance  = true
  warn_at_budget_ratio = 0.8
}

resource "pathly_maintenance_window" "backup" {
  weekday      = 7 # Sunday
  start_minute = 3 * 60
  duration_min = 120
  reason       = "Weekly backup"
}

resource "pathly_maintenance_window" "migration" {
  count = var.migration_starts_at == null ? 0 : 1

  scenario_id = pathly_scenario.journey["checkout"].id
  starts_at   = var.migration_starts_at
  ends_at     = var.migration_ends_at
  reason      = "Checkout funnel migration"

  # OpenTofu 1.8 rejects a variable validation that reads another variable.
  lifecycle {
    precondition {
      condition     = var.migration_ends_at != null
      error_message = "A one-off window needs both of its bounds."
    }
  }
}

resource "pathly_webhook" "alerts" {
  url    = var.webhook_url
  events = ["run.failed", "run.recovered"]
}

resource "pathly_scenario" "checkout_browser" {
  name         = "Checkout as a customer"
  type         = "browser"
  interval_sec = 300
  severity     = "critical"
  folder       = var.folder
  tags         = ["opentofu", var.environment, "payment"]
  runbook      = "https://wiki.example.com/ops/checkout-unavailable"

  viewport          = "desktop"
  locale            = "fr-FR"
  scenario_timezone = "Europe/Paris"
  click_delay_ms    = 500

  steps = [
    {
      op  = "goto"
      url = "https://shop.example.com/login"
    },
    {
      op       = "fill"
      selector = "input[name=email]"
      value    = var.shop_user
    },
    {
      op       = "fill"
      selector = "input[name=password]"
      value    = var.shop_password
    },
    {
      op       = "click"
      selector = "button[type=submit]"
      text     = "Sign in"
    },
    {
      op   = "assert_text"
      text = "Your cart"
    },
  ]
}

output "webhook_fingerprint" {
  description = "Fingerprint of the destination URL."
  value       = pathly_webhook.alerts.url_fingerprint
}
