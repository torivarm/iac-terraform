#!/usr/bin/env bash
set -euo pipefail

# Parametre
KV_NAME="${1:-}"       # Key Vault-navn
SECRET_NAME="${2:-}"   # f.eks. "tfvars-dev"
FILE_PATH="${3:-}"     # f.eks. "./dev.tfvars"
SUBSCRIPTION_ID="${4:-}"  # valgfritt

if [[ -z "$KV_NAME" || -z "$SECRET_NAME" || -z "$FILE_PATH" ]]; then
  echo "Bruk: $0 <kv-name> <secret-name> <path-to-dev.tfvars> [subscription-id]" >&2
  exit 1
fi
if [[ ! -f "$FILE_PATH" ]]; then
  echo "Fant ikke fil: $FILE_PATH" >&2
  exit 1
fi

# 1) Logg inn/sett subscription (hopp over az login i CI med OIDC)
if [[ -n "${SUBSCRIPTION_ID}" ]]; then
  az account set --subscription "$SUBSCRIPTION_ID"
fi

# 2) (Valgfritt) størrelsessjekk
BYTES=$(wc -c < "$FILE_PATH" | tr -d ' ')
if (( BYTES > 24500 )); then
  echo "Advarsel: Innholdet er ~${BYTES} byte (> ~25 KB). Vurder å splitte eller lagre per-variabel." >&2
fi

# 3) Sett secret fra fil (bevarer linjeskift)
#   --file leser hele filen som secret-verdi.
az keyvault secret set \
  --vault-name "$KV_NAME" \
  --name "$SECRET_NAME" \
  --file "$FILE_PATH" \
  --content-type 'application/tfvars; charset=utf-8' \
  --only-show-errors \
  --query '{id:id, name:name, contentType:contentType}'

# 4) (Valgfritt) verifiser
# az keyvault secret show --vault-name "$KV_NAME" --name "$SECRET_NAME" --query "id" -o tsv

# I terminalen:
# Logg inn med az login
# Sett chmod +x på scriptet
# Kjør scriptet, f.eks.:
# ./set-tfvars-secret.sh kv-navn tfvars-dev ./dev.tfvars
# eller med subscription:
# ./set-tfvars-secret.sh kv-navn tfvars-dev ./dev.tfvars 00000000-0000-0000-0000-000000000000