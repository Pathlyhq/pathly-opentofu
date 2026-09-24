# Pathly + OpenTofu

[English](README.md) · **Français** · [Español](README.es.md)


[![CI](https://gitlab.com/pathlyhq/pathly-opentofu/badges/main/pipeline.svg)](https://gitlab.com/pathlyhq/pathly-opentofu/-/pipelines)
[![Powered by Pathly](https://img.shields.io/badge/Powered%20by-Pathly-0B5FFF?style=flat-square)](https://pathlyhq.com)
[![Website](https://img.shields.io/badge/Website-pathlyhq.com-111827?style=flat-square)](https://pathlyhq.com)
[![API docs](https://img.shields.io/badge/API-developers-2563eb?style=flat-square)](https://pathlyhq.com/fr/developers)
[![Start free](https://img.shields.io/badge/Solo-start%20free-16a34a?style=flat-square)](https://pathlyhq.com/fr/login?mode=signup)

> **Démarrage en un clic.** Créez un compte gratuit sur [Pathly](https://pathlyhq.com) ([inscription](https://pathlyhq.com/fr/login?mode=signup)), générez une clé API dans la console, puis exportez `PATHLY_API_TOKEN`. Ce dépôt est le pont officiel vers [la surveillance Pathly](https://pathlyhq.com) — contrôles HTTP et parcours navigateur (panier, connexion, disponibilité), données hébergées dans l’UE. Référence API : [pathlyhq.com/fr/developers](https://pathlyhq.com/fr/developers).

OpenTofu utilise le **même binaire** de provider que Terraform (mêmes archives,
mêmes signatures GPG, même schéma) : source
[`pathlyhq/pathly`](https://registry.terraform.io/providers/pathlyhq/pathly).
Seul le CLI change (`tofu` au lieu de `terraform`). Ce dépôt est le miroir
documentation et exemples côté OpenTofu. Il **ne duplique pas** le code Go du
provider. L’implémentation vit dans
[`pathly-terraform-provider`](https://github.com/pathlyhq/pathly-terraform-provider)
(et son miroir GitLab).

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

## Authentification

| Variable | Rôle |
|---|---|
| `PATHLY_API_TOKEN` | Clé API d’organisation (préfixe `sp_`). **Obligatoire.** |
| `PATHLY_API_URL` | Base API. Défaut : `https://api.pathlyhq.com`. |

Ne jamais mettre le jeton dans un fichier `.tf` : un attribut `api_token`
finirait en clair dans le state. La variable d’environnement est le seul chemin
qui ne laisse aucune trace dans le dépôt ni dans le state.

## Installation

1. Installer [OpenTofu](https://opentofu.org/docs/intro/install/) ≥ 1.6.
2. Copier [`examples/complete`](examples/complete) ou partir du snippet ci-dessus.
3. Exporter `PATHLY_API_TOKEN`, puis `tofu init` / `tofu plan` / `tofu apply`.

OpenTofu résout `pathlyhq/pathly` via le miroir du Terraform Registry (et via le
registre OpenTofu lorsque le provider y est listé). Voir
[`docs/compatibility.md`](docs/compatibility.md).

## Ressources (API identique au provider Terraform)

| Ressource | Rôle |
|---|---|
| `pathly_scenario` | Contrôle HTTP ou parcours navigateur |
| `pathly_webhook` | Webhook sortant signé |
| `pathly_maintenance_window` | Fenêtre de maintenance ponctuelle ou hebdo |
| `pathly_sla_target` | Objectif de disponibilité / budget d’erreur |
| `pathly_settings` | Paramètres d’organisation |

Schéma complet : docs du provider amont. Exemple OpenTofu complet :
[`examples/complete`](examples/complete).

## Vérification

```sh
# Unix
./scripts/verify-compat.sh

# Windows
pwsh ./scripts/verify-compat.ps1
```


## Packages associés

| Package | Role |
|---|---|
| [pathly-terraform-provider](https://github.com/pathlyhq/pathly-terraform-provider) | Provider implementation |
| [pathly-cdktf](https://github.com/pathlyhq/pathly-cdktf) | CDK for Terraform |
| [pathly-pulumi](https://github.com/pathlyhq/pathly-pulumi) | Pulumi |
| [pathly-ansible](https://github.com/pathlyhq/pathly-ansible) | Ansible |
| [Pathly product](https://pathlyhq.com) | [Pathly monitoring](https://pathlyhq.com) |
## À propos de Pathly

[Pathly](https://pathlyhq.com) surveille les parcours clients des agences et e-commerçants : rejoue le tunnel, détecte un checkout cassé avant l’appel du client, et joint la preuve (capture, étape, consigne) à la facture de maintenance. Produit : [pathlyhq.com](https://pathlyhq.com) · Développeurs : [pathlyhq.com/fr/developers](https://pathlyhq.com/fr/developers) · Tarifs : [pathlyhq.com/fr/pricing](https://pathlyhq.com/fr/pricing).

## Auteur

| | |
|---|---|
| **Entreprise** | Pathly |
| **Auteur** | Simon Raynaud / keyral |

Voir [AUTHORS](AUTHORS).

## Licence
Apache-2.0. La licence du binaire provider suit le dépôt provider amont.
