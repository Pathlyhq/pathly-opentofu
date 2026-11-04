# Pathly + OpenTofu

[English](README.md) · [Français](README.fr.md) · **Español**


[![CI](https://github.com/Pathlyhq/pathly-opentofu/actions/workflows/ci.yml/badge.svg)](https://github.com/Pathlyhq/pathly-opentofu/actions/workflows/ci.yml)
[![Powered by Pathly](https://img.shields.io/badge/Powered%20by-Pathly-0B5FFF?style=flat-square)](https://pathlyhq.com)
[![Website](https://img.shields.io/badge/Website-pathlyhq.com-111827?style=flat-square)](https://pathlyhq.com)
[![API docs](https://img.shields.io/badge/API-developers-2563eb?style=flat-square)](https://pathlyhq.com/es/developers)
[![Start free](https://img.shields.io/badge/Solo-start%20free-16a34a?style=flat-square)](https://pathlyhq.com/es/login?mode=signup)

> **Empiece en un clic.** Cree una cuenta gratuita en [Pathly](https://pathlyhq.com) ([registro](https://pathlyhq.com/es/login?mode=signup)), genere una clave API en la consola y exporte `PATHLY_API_TOKEN`. Este repositorio es el puente oficial hacia [la monitorización Pathly](https://pathlyhq.com): comprobaciones HTTP y de navegador (carrito, login, disponibilidad), con datos en la UE. Referencia API: [pathlyhq.com/es/developers](https://pathlyhq.com/es/developers).

OpenTofu usa el **mismo binario** de provider que Terraform (mismos archivos,
mismas firmas GPG, mismo esquema): fuente
[`pathlyhq/pathly`](https://registry.terraform.io/providers/pathlyhq/pathly).
Solo cambia el CLI (`tofu` en lugar de `terraform`). Este repositorio es el
espejo de documentación y ejemplos orientado a OpenTofu. **No duplica** el
código Go del provider. La implementación vive en
[`terraform-provider-pathly`](https://github.com/Pathlyhq/terraform-provider-pathly)


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

## Autenticación

| Variable | Función |
|---|---|
| `PATHLY_API_TOKEN` | Clave de API de la organización (prefijo `sp_`). **Obligatoria.** |
| `PATHLY_API_URL` | Base de la API. Por defecto `https://api.pathlyhq.com`. |

Nunca ponga el token en un archivo `.tf`: un atributo `api_token` acabaría en
claro en el estado. La variable de entorno es el único camino que no deja
rastro en el repositorio ni en el archivo de estado.

## Instalación

1. Instale [OpenTofu](https://opentofu.org/docs/intro/install/) ≥ 1.6.
2. Copie [`examples/complete`](examples/complete) o parta del fragmento anterior.
3. Exporte `PATHLY_API_TOKEN`, luego ejecute `tofu init` / `tofu plan` / `tofu apply`.

OpenTofu resuelve `pathlyhq/pathly` desde el espejo del Terraform Registry (y
desde el registro OpenTofu cuando el provider esté listado allí). Véase
[`docs/compatibility.md`](docs/compatibility.md).

## Recursos (API idéntica al provider Terraform)

| Recurso | Función |
|---|---|
| `pathly_scenario` | Control HTTP o recorrido de navegador |
| `pathly_webhook` | Webhook saliente firmado |
| `pathly_maintenance_window` | Mantenimiento puntual o semanal |
| `pathly_sla_target` | Objetivo de disponibilidad / presupuesto de error |
| `pathly_settings` | Ajustes de organización |

Esquema completo: docs del provider upstream. Ejemplo OpenTofu completo:
[`examples/complete`](examples/complete).

## Verificación

```sh
# Unix
./scripts/verify-compat.sh

# Windows
pwsh ./scripts/verify-compat.ps1
```


## Paquetes relacionados

| Package | Role |
|---|---|
| [terraform-provider-pathly](https://github.com/Pathlyhq/terraform-provider-pathly) | Provider implementation |
| [pathly-cdktf](https://github.com/pathlyhq/pathly-cdktf) | CDK for Terraform |
| [pathly-pulumi](https://github.com/pathlyhq/pathly-pulumi) | Pulumi |
| [pathly-ansible](https://github.com/pathlyhq/pathly-ansible) | Ansible |
| [Pathly product](https://pathlyhq.com) | [Pathly monitoring](https://pathlyhq.com) |
## Acerca de Pathly

[Pathly](https://pathlyhq.com) es monitorización sintética para agencias y e-commerce: reproduce el recorrido del cliente, detecta un checkout roto antes de la llamada, y deja la prueba (captura, paso, runbook) lista para la factura. Producto: [pathlyhq.com](https://pathlyhq.com) · Desarrolladores: [pathlyhq.com/es/developers](https://pathlyhq.com/es/developers) · Precios: [pathlyhq.com/es/pricing](https://pathlyhq.com/es/pricing).

## Autor

| | |
|---|---|
| **Empresa** | Pathly |
| **Autor** | Simon Raynaud / keyral |

Véase [AUTHORS](AUTHORS).

## Licencia
Apache-2.0. La licencia del binario del provider sigue el repositorio upstream del provider.
