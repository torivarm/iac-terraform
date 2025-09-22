# Gjennomgang av «backend»-oppsettet (Terraform + Azure)

Denne gjennomgangen forklarer koden studentene bruker for å klargjøre en **Terraform-backend** i Azure: Resource Group, Storage Account + container (for state), Key Vault og nødvendige **RBAC-tilganger**. Målet er at du skal forstå **hva** hver ressurs gjør, **hvorfor** konfigurasjonen er satt som den er, og **hvordan** navngivingen styres med `locals` og variabler.

---

## Filoversikt

- **`variables.tf`** – alle parametere studentene kan (og bør) overstyre i `terraform.tfvars` (region, navn, tilganger, m.m.).
- **`locals.tf`** – logikk for navngiving (samler og utleder navn basert på variabler) og samling av principals som skal få RBAC.
- **`main.tf`** – selve ressursene i Azure: RG, Storage Account, Container, Key Vault, samt RBAC-tilordningene.
- **`outputs.tf`** – nyttige verdier etter deploy, bl.a. en ferdig **backend.hcl**-snippet som kan brukes i `terraform init`.

---

## Provider og pålogging

```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id  # kan være null => bruker CLI-«default»
  use_cli         = true                 # Terraform bruker `az login`-konteksten
}
```

- **`use_cli = true`** betyr at Terraform autentiserer via din `az login`-økt (Entra ID-bruker eller service principal).
- **`subscription_id`** kan settes i `tfvars`, men er valgfritt om du har riktig «default subscription» i `az`.

**Data-kilde:**
```hcl
data "azurerm_client_config" "current" {}
```
- Henter **tenant**, **subscription** og **object id** for den identiteten Terraform kjører som. Brukes i RBAC og Key Vault.

---

## Variabler (utdrag)

```hcl
variable "location" { type = string }                  # Azure-region
variable "name_prefix" { type = string }               # Kort prefiks for navn
variable "unique_suffix" { type = string, default="" } # Unik hale for globalt unike navn
variable "resource_group_name" { default = "" }
variable "storage_account_name" { default = "" }
variable "container_name" { default = "tfstate" }
variable "kv_name" { default = "" }

variable "assign_current_user" { type = bool, default = true }
variable "extra_principal_ids" { type = list(string), default = [] }

variable "tags" {
  type = map(string)
  default = { purpose="tf-backend", lifecycle="platform", cleanup="exclude" }
}
```

- **Prinsipp:** Du kan spesifisere eksakte navn, eller la koden **generere fornuftige** navn ut fra `name_prefix` og `unique_suffix`.
- **RBAC-styring:**  
  - `assign_current_user = true` gir innlogget bruker tilgang automatisk.  
  - `extra_principal_ids` lar deg gi tilganger til **App Registrations / service principals** (for GitHub Actions).

---

## Lokale verdier (locals) og navngiving

> **Formål:** Sentralt sted for å **beregne navn** og **samle principals** for RBAC, slik at hovedressursene blir rene og konsise.

### Generering av unik «suffix»
- Hvis `unique_suffix` **ikke** er satt av studenten, lager koden en kort `random_string` (f.eks. `ab12`). Dette hjelper på global unike navn for **Storage Account** (må være unikt i hele Azure).

### Samling av principals
```hcl
locals {
  principals = toset(
    concat(
      var.extra_principal_ids,
      var.assign_current_user ? [data.azurerm_client_config.current.object_id] : []
    )
  )
}
```
- Lager et **sett** av alle AAD-objekter (brukere/app-er) som skal få RBAC-roller i oppsettet.

### Eksempel: _sa_final_ (Storage Account-navn)

Her er et eksempel på et uttrykk brukt i koden:

```hcl
sa_final = var.storage_account_name != "" ? var.storage_account_name : (
  local.final_suffix != "" ? "st${var.name_prefix}${local.final_suffix}" : "st${var.name_prefix}"
)
```

**Forklaring trinn for trinn:**
1. **Har studenten gitt et eksplisitt navn?**  
   - Ja → bruk `var.storage_account_name`.  
   - Nei → gå til trinn 2.
2. **Har vi en «suffix» (enten gitt eller auto-generert)?**  
   - Ja → bygg navn som `st<prefix><suffix>`, f.eks. `sttfstateab12`.  
   - Nei → bygg navn som `st<prefix>`, f.eks. `sttfstate`.

**Hvorfor sånn?**
- **Storage Account**-navn må være **globalt unike**, korte, kun **små bokstaver og tall**, 3–24 tegn.  
- Mønsteret `st` + `<prefix>` + `<suffix>` gir:
  - konsistent navnestandard,
  - høy sannsynlighet for unike navn (via suffix),
  - og menneskelig lesbarhet (du ser hvilket kurs/prosjekt det tilhører).

---

## Ressurser

### Resource Group
```hcl
resource "azurerm_resource_group" "rg" {
  name     = local.rg_final
  location = var.location
  tags     = var.tags
}
```
- Samler alt i en **RG**. Taggene brukes for **opprydding** (`cleanup=exclude`), **lifecycle** og **kostnadsstyring**.

### Storage Account (for Terraform state)
```hcl
resource "azurerm_storage_account" "sa" {
  name                     = local.sa_final
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  allow_blob_public_access        = false
  shared_access_key_enabled       = false   # AAD-only på sikt
  https_traffic_only_enabled      = true

  blob_properties {
    versioning_enabled = true
    delete_retention_policy { days = 14 }
    container_delete_retention_policy { days = 14 }
    change_feed_enabled = true
  }

  identity { type = "SystemAssigned" }

  tags = var.tags
}
```

**Hvorfor disse innstillingene?**
- **Sikkerhet**:  
  - `allow_blob_public_access=false` og `shared_access_key_enabled=false` → press mot **AAD-baserte** rettigheter i stedet for nøkler.  
  - `min_tls_version="TLS1_2"` og `https_traffic_only_enabled=true` → kryptert trafikk.
- **Robusthet** for state:  
  - `versioning_enabled=true`, **soft delete** (blob/container) og **change feed** gir mulighet for **gjenoppretting** og **revisjon**.

### Container for Terraform state
```hcl
resource "azurerm_storage_container" "state" {
  name                  = var.container_name   # default "tfstate"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}
```
- Dette er «bøtta» Terraform-backenden peker på. All state lagres som en blob (`key`) under denne containeren.

### Key Vault (RBAC-modus)
```hcl
resource "azurerm_key_vault" "kv" {
  name                        = local.kv_final
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.kv_sku_name
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  enable_rbac_authorization   = true
  public_network_access_enabled = true
  tags = var.tags
}
```

**Hvorfor RBAC og soft delete?**
- **RBAC** gir samme styringsmodell som resten av Azure (roller).  
- **Soft delete + purge protection** hindrer utilsiktet tap av hemmeligheter – viktig når klassen jobber og rydder ofte.

---

## RBAC-tilordninger (roller)

> **Hovedidé:** Gi akkurat de rettighetene som trengs (Least Privilege) til de **principal-ene** i `locals.principals`.

```hcl
# Blob-tilgang på containeren (les/skriv state)
resource "azurerm_role_assignment" "sa_blob_contributor" {
  for_each             = local.principals
  scope                = azurerm_storage_container.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.key
  depends_on           = [azurerm_storage_container.state]
}

# Lesetilgang på SA (for portal/oppslag)
resource "azurerm_role_assignment" "sa_reader" {
  for_each             = local.principals
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Reader"
  principal_id         = each.key
}

# Key Vault-tilgang (skriv/les secrets)
resource "azurerm_role_assignment" "kv_secrets_officer" {
  for_each             = local.principals
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}
```

- **Container-scope**: `Storage Blob Data Contributor` er nødvendig for at Terraform-backend skal kunne **lese/ skrive/lease** state-fila.
- **Key Vault**: `Secrets Officer` → kan opprette/oppdatere/lese secrets (for oppgaver som trenger det). Velg `Secrets User` hvis kun lesing skal være lov.

---

## Outputs og backend.hcl

```hcl
output "backend_hcl_example" {
  value = <<EOT
resource_group_name  = "${azurerm_resource_group.rg.name}"
storage_account_name = "${azurerm_storage_account.sa.name}"
container_name       = "${azurerm_storage_container.state.name}"
use_azuread_auth     = true
EOT
}
```

- Etter `terraform apply` kan studenten «skrive ut» denne til en fil:
  ```bash
  terraform output -raw backend_hcl_example > shared/backend.hcl
  ```
- Ved migrering av lokal state til AzureRM-backend:
  ```bash
  terraform init \
    -migrate-state \
    -backend-config="shared/backend.hcl" \
    -backend-config="key=<org>/<repo>/<stack>/<env>.tfstate"
  ```
  Hvor `key` er **banen** (blob-navnet) til state-filen under containeren. Bruk en konsekvent konvensjon (f.eks. `<org>/<repo>/<stack>/<env>.tfstate`) for ryddighet og kollisjonskontroll.

---

## Vanlige spørsmål (FAQ)

**Må App Registration (GitHub Actions) få rettigheter nå?**  
- Hvis studentene **oppretter ressursene med sin bruker** (CLI), må App Registration-en(e) få nødvendige RBAC-roller **etterpå** (på container + KV + ev. mål-RG).  
- Faglig ryddigst er å kjøre **bootstrap i en workflow** med den samme App Registration – da «eier» den ressursene fra start og har allerede riktige roller.

**Hvorfor så mange sikkerhetsinnstillinger på Storage Account?**  
- Terraform-state kan referere til sensitive id-er/egenskaper. Versjonering + soft delete gjør gjenoppretting mulig, og AAD-krav minsker nøkkelbruk.

**Kan vi bruke én SA/container for hele klassen?**  
- Ja – la hver stack/miljø/student få sin **unikke `key`**. Det er vanlig og effektivt i undervisning.

---

## Oppsummert

- **Variabler** gir studentene enkel konfigurasjon i `terraform.tfvars`.  
- **`locals`** samler navnelogikk og RBAC-principals for renere kode.  
- **Storage Account + container** utgjør Terraform-backenden – hardenes for sikkerhet og robusthet (versjonering, soft delete).  
- **Key Vault** bevares gjennom semesteret og styres med RBAC.  
- **RBAC** tildeles både til innlogget bruker og eventuelle App Registrations (for CI).  
- **`backend.hcl`** genereres fra outputs og brukes i `terraform init` (med egen `key`) for å migrere eller sette opp state.
