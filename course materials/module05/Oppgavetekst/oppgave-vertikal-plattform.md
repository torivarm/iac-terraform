# Oppgave: Vertikal tjenesteplattform med Terraform på Azure

Bygg en liten, driftsklar **vertikal plattform** for en enkel web‑tjeneste i **to miljøer (dev og test)** (Eventuelt bygg videre på allerede utviklet miljø og kode for dev, test og prod fra sist uke). Oppgaven trener på god praksis fra **kapittel 9 (integrering av stacks)** og **kapittel 10 (design av kodebibliotek/moduler)**. Vi kjører fortsatt `terraform apply` lokalt men skal nå ta i bruk **AzureRM backend** for state per miljø.

---

## Læringsmål
- Videre fokus på designe **små, gjenbrukbare Terraform‑moduler** med utgangspunkt i teori (Facade/Bundle) med få, fornuftige input‑variabler og tydelige outputs.
- Integrere moduler gjennom en **komposisjon (root)** (som vi omtalte stacks sist uke) som «wirer» outputs → inputs på en oversiktlig måte.
- Konfigurere **AzureRM backend** for lagring av state med **separate keys per miljø** (dev/test/prod).

---

> Tips: Dersom tfstate‑lager ikke finnes, lag en egen liten bootstrap (Bash/PowerShell) som oppretter RG, Storage Account og Container for state, og tildeler egne rettigheter (f.eks. **Storage Blob Data Contributor**).

---

## Arkitektur (god praksis, enkelt og vertikalt)
- **Modul `network` (Facade):** Oppretter VNet, ett Subnet og en enkel NSG som tillater HTTP (80) og SSH (22) fra egen IP. (RG kan opprettes i modulen eller mottas utenfra – velg én praksis og dokumentér den.)
- **Modul `compute` (Facade/lett Bundle):** Oppretter en Linux VM med NIC i gitt subnet og Public IP. Cloud‑init installerer NGINX og eksponerer en enkel nettside som viser miljønavn.
- **Komposisjon per miljø (root):** Kaller `network` og `compute` og kobler `subnet_id` fra `network` → `compute` (resource discovery via komposisjon = løs kobling).
- **AzureRM backend:** Én **state key per miljø** (f.eks. `platform-dev.tfstate` og `platform-test.tfstate`).

---

## Mappestruktur (foreslått)
```
/modules
  /network
    main.tf
    variables.tf
    outputs.tf
  /compute
    main.tf
    variables.tf
    outputs.tf

/composition
  /dev
    main.tf
    providers.tf
    backend.hcl
    variables.tf   (valgfritt)
  /test
    main.tf
    providers.tf
    backend.hcl

/README.md
```

---

## Krav til modulene

### `modules/network` (Facade)
**Inputs (få og fornuftige):**
- `name_prefix` (string) – brukes i navning av ressurser
- `location` (string)
- `address_space` (CIDR, f.eks. `10.30.0.0/16`)
- `subnet_prefix` (CIDR, f.eks. `10.30.1.0/24`)

**Ressurser:**
- `azurerm_virtual_network`, `azurerm_subnet`
- `azurerm_network_security_group` + `azurerm_subnet_network_security_group_association`
  - Tillat innkommende TCP 80 (HTTP) fra alle
  - Tillat innkommende TCP 22 (SSH) fra egen IP (parameter eller hentet ved behov)

**Outputs:**
- `vnet_id`
- `subnet_id`

**Standardisering:**
- Konsistente `tags` (minst `environment`, `owner`), enkel navnestandard med `name_prefix`.

### `modules/compute` (Facade/Bundle)
**Inputs:**
- `name_prefix` (string)
- `location` (string)
- `subnet_id` (string) – **kobles fra `network` via komposisjon**
- `vm_size` (string, f.eks. `Standard_B2s`)
- `admin_username` (string)
- `admin_ssh_public_key` (path/string)

**Ressurser:**
- `azurerm_public_ip`, `azurerm_network_interface`, `azurerm_linux_virtual_machine`
- Cloud‑init installerer NGINX og lager enkel index‑side som viser miljønavn (dev/test)

**Outputs:**
- `public_ip_address`
- `nginx_url` (f.eks. `http://<public_ip>`)

**Standardisering:**
- Deaktivér passordinnlogging, bruk SSH‑nøkkel, konsistente `tags`.

---

## Komposisjon per miljø (root)
Eksempel for **dev** (samme for `test` med andre verdier):

**`/composition/dev/main.tf`**
```hcl
module "network" {
  source        = "../../modules/network"
  name_prefix   = "demo-dev"
  location      = "westeurope"
  address_space = "10.30.0.0/16"
  subnet_prefix = "10.30.1.0/24"
  # tags = { environment = "dev", owner = "student-<navn>" }
}

module "compute" {
  source               = "../../modules/compute"
  name_prefix          = "demo-dev"
  location             = "westeurope"
  subnet_id            = module.network.subnet_id   # ← wiring (resource discovery)
  vm_size              = "Standard_B2s"
  admin_username       = "ops"
  admin_ssh_public_key = file("~/.ssh/id_rsa.pub")
}
```

**`/composition/dev/providers.tf`**
```hcl
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" { features {} }
```

**`/composition/dev/backend.hcl`**
```hcl
resource_group_name  = "rg-tfstate-<din>"
storage_account_name = "sttf<din>"
container_name       = "tfstate"
key                  = "platform-dev.tfstate"
```

> God praksis: **Komposisjonen** eier koblingen mellom moduler. Hvert miljø har egen **state key**. Hold variablene få og fornuftige, og outputs tydelige.

---

## AzureRM backend – init
I hver komposisjon:
```bash
cd composition/dev
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
terraform output
```

Gjør tilsvarende i `composition/test` med egen `backend.hcl` (f.eks. `key = "platform-test.tfstate"` og andre CIDR‑verdier).

---

## Arbeidsflyt (anbefalt)
1. **Klargjør tfstate‑backend** (én gang per student): RG + Storage Account + Container + rettigheter.
2. Implementer `modules/network` og `modules/compute` etter spesifikasjonene.
3. Lag komposisjon for `dev` og `test` (egen mappe per miljø).
4. `terraform init` med `-backend-config=backend.hcl` i hvert miljø.
5. `terraform apply` i `dev` og `test` – noter `nginx_url` fra outputs.
6. Verifisér i Azure Portal at ressursene finnes, er tagget riktig, og at `dev` og `test` er **separate**.
7. Skriv kort **README** (se Leveranser).

---

## Leveranser
- **Kode** (moduler + komposisjoner) i foreslått mappestruktur.
- **README** som beskriver:
  - Forhåndskrav og bootstrap av tfstate‑backend
  - Hvordan kjøre `dev` og `test` (init/plan/apply)
  - Kort forklaring av modul‑inputs/outputs og komposisjonens «wiring»
  - Navne‑ og tagg‑standard dere har valgt
- **Skjermbilder** fra Azure Portal som viser ressursgrupper for dev og test
- **Output** fra `terraform output` for `nginx_url` i begge miljøer

---

## Vurderingskriterier
- **Moduldesign (40%)** – Små, rene Facade‑moduler, gode defaults, få men nyttige variabler, klare outputs, konsistente tags/navn.
- **Integrasjon via komposisjon (30%)** – Tydelig wiring mellom moduler; løs kobling; lett å forstå hvordan miljø settes opp.
- **State‑oppsett (20%)** – AzureRM backend fungerer; separate keys for dev/test; init‑prosess er dokumentert.
- **Dokumentasjon (10%)** – Kort, presis README som en medstudent kan følge.

---

## Tips (frivillig)
- Vis miljønavn (dev/test) på NGINX startsiden via cloud‑init.
- Kjør `terraform fmt -check` og `terraform validate` før levering.
- Legg på enkel NSG‑regel for HTTP/SSH (gjerne minimer SSH‑eksponering i README‑refleksjon).

Lykke til! 🎯
