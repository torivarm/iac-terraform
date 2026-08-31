[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)] [string] $VaultName,      # Key Vault-navn
  [Parameter(Mandatory=$true)] [string] $SecretName,     # F.eks. "tfvars-dev"
  [Parameter(Mandatory=$true)] [string] $FilePath,       # F.eks. ".\dev.tfvars"
  [string] $SubscriptionId,                              # Valgfritt: velg subscription
  [string] $TenantId,                                    # Valgfritt: velg tenant
  [switch] $UseDeviceCode                                # Valgfritt: bruk Device Code i stedet for nettleser
)

Write-Verbose "Sjekker og laster Az-moduler…"
try {
  if (-not (Get-Module -ListAvailable -Name Az.Accounts)) { Install-Module Az.Accounts -Scope CurrentUser -Force -ErrorAction Stop }
  if (-not (Get-Module -ListAvailable -Name Az.KeyVault)) { Install-Module Az.KeyVault  -Scope CurrentUser -Force -ErrorAction Stop }
  Import-Module Az.Accounts -ErrorAction Stop
  Import-Module Az.KeyVault  -ErrorAction Stop
} catch {
  Write-Error "Kunne ikke installere/laste Az-moduler: $($_.Exception.Message)"
  exit 1
}

# ---- 1) Interaktiv innlogging lokalt (web) ----
try {
  if ($UseDeviceCode) {
    # Terminal-vennlig: skriv kode og gå til https://microsoft.com/devicelogin
    Connect-AzAccount -Tenant $TenantId -UseDeviceCode -ErrorAction Stop | Out-Null
  } else {
    # Standard: åpner nettleser for web-innlogging
    Connect-AzAccount -Tenant $TenantId -ErrorAction Stop | Out-Null
  }
  if ($SubscriptionId) {
    Set-AzContext -Subscription $SubscriptionId -ErrorAction Stop | Out-Null
  }
} catch {
  Write-Error "Azure-innlogging feilet: $($_.Exception.Message)"
  exit 1
}

# ---- 2) Les fil og enkel validering ----
if (-not (Test-Path -Path $FilePath)) {
  Write-Error "Fant ikke fil: $FilePath"
  exit 1
}

try {
  $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
} catch {
  Write-Error "Klarte ikke å lese fil: $($_.Exception.Message)"
  exit 1
}

# Key Vault har praktisk grense rundt 25 KB per secret-verdi
$bytes = [Text.Encoding]::UTF8.GetByteCount($content)
if ($bytes -gt 24500) {
  Write-Warning "Innholdet er ~${bytes} byte (> ~25 KB). Vurder å splitte per variabel eller annen strategi."
}

# ---- 3) Sjekk at Key Vault finnes og at du har tilgang ----
try {
  $kv = Get-AzKeyVault -VaultName $VaultName -ErrorAction Stop
} catch {
  Write-Error "Fikk ikke hentet Key Vault '$VaultName'. Sjekk navn/tilgang/abonnement. Detaljer: $($_.Exception.Message)"
  exit 1
}

# ---- 4) Lagre som secret (bevarer linjeskift) ----
try {
  $secure = ConvertTo-SecureString -String $content -AsPlainText -Force
  $result = Set-AzKeyVaultSecret `
    -VaultName   $VaultName `
    -Name        $SecretName `
    -SecretValue $secure `
    -ContentType 'application/tfvars; charset=utf-8' `
    -ErrorAction Stop

  $result | Select-Object Id, Name, ContentType
  Write-Host "✅ Secret '$SecretName' er lagret i Key Vault '$VaultName'."
} catch {
  Write-Error "Kunne ikke sette secret: $($_.Exception.Message)"
  exit 1
}


<#
Eksempel på bruk (i terminal):

# Standard web-innlogging (åpner nettleser)
.\Set-TfvarsSecret.Local.ps1 -VaultName "kv-mittnavn" -SecretName "tfvars-dev" -FilePath ".\dev.tfvars"

# Velg spesifikk tenant + subscription
.\Set-TfvarsSecret.Local.ps1 -VaultName "kv-mittnavn" -SecretName "tfvars-dev" -FilePath ".\dev.tfvars" `
  -TenantId "11111111-2222-3333-4444-555555555555" -SubscriptionId "00000000-0000-0000-0000-000000000000"

# Device Code (hvis du ikke kan åpne nettleser)
.\Set-TfvarsSecret.Local.ps1 -VaultName "kv-mittnavn" -SecretName "tfvars-dev" -FilePath ".\dev.tfvars" -UseDeviceCode



#>