<#
.SYNOPSIS
    Oppretter katalog- og filstruktur for Terraform-stacks.
.DESCRIPTION
    Dette PowerShell-skriptet oppretter nødvendige kataloger og tomme filer for et Terraform-prosjekt med moduler, stacks og miljøer.
    Hvis kataloger eller filer allerede finnes, vil de ikke bli overskrevet.
.NOTES
    For å kjøre dette skriptet, åpne PowerShell og naviger til katalogen der skriptet er lagret.
    Kjør skriptet med kommandoen:
        .\_PWSH-createFilesAndFolders.ps1
    Sørg for at du har de nødvendige tillatelsene (kjør VS Code som administrator) til å opprette filer og kataloger i den aktuelle katalogen.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Directory {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Ensure-File {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        New-Item -ItemType File -Path $Path -Force | Out-Null
    } else {
        # Berør filen uten å endre innhold, for konsistens
        (Get-Item -LiteralPath $Path).LastWriteTime = Get-Date
    }
}

# Kataloger
Ensure-Directory -Path ".\modules\network"
Ensure-Directory -Path ".\modules\compute-vm"
Ensure-Directory -Path ".\stacks"
Ensure-Directory -Path ".\environments\dev"
Ensure-Directory -Path ".\environments\test"
Ensure-Directory -Path ".\environments\prod"

# Filer for modules\network
Ensure-File -Path ".\modules\network\main.tf"
Ensure-File -Path ".\modules\network\variables.tf"
Ensure-File -Path ".\modules\network\outputs.tf"

# Filer for modules\compute-vm
Ensure-File -Path ".\modules\compute-vm\main.tf"
Ensure-File -Path ".\modules\compute-vm\variables.tf"
Ensure-File -Path ".\modules\compute-vm\outputs.tf"

# Filer for stacks
Ensure-File -Path ".\stacks\main.tf"
Ensure-File -Path ".\stacks\variables.tf"
Ensure-File -Path ".\stacks\outputs.tf"

# Filer for environments\dev
Ensure-File -Path ".\environments\dev\main.tf"
Ensure-File -Path ".\environments\dev\dev.tfvars"
Ensure-File -Path ".\environments\dev\backend.tf"

# Filer for environments\test
Ensure-File -Path ".\environments\test\main.tf"
Ensure-File -Path ".\environments\test\test.tfvars"
Ensure-File -Path ".\environments\test\backend.tf"

# Filer for environments\prod
Ensure-File -Path ".\environments\prod\main.tf"
Ensure-File -Path ".\environments\prod\prod.tfvars"
Ensure-File -Path ".\environments\prod\backend.tf"

Write-Host ("Struktur opprettet i: {0}" -f (Get-Location).Path)