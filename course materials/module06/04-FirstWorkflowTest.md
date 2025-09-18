# Veiviser: Test av Federated Credentials med GitHub Actions

Når du har satt opp **federated credentials** mellom GitHub og Azure, bør du teste at tilkoblingen fungerer. Denne guiden viser deg hvordan du gjør det med en enkel workflow-fil.

---

## 1. Opprett workflow-fil
1. Gå til ditt repository i GitHub.
2. Klikk på **Actions** i menyen.
   1. ![alt text](img/actions.png)
3. Opprett en ny workflow eller velg **set up a workflow yourself**.
   1. ![alt text](img/setupworkflow.png)
4. Lag en fil med navnet:  
   `.github/workflows/azure-login-test.yml`
5. Lim inn følgende innhold:
   1. ![alt text](img/newyaml.png)

```yaml
name: Run Azure Login with OpenID Connect
on: [push]

jobs:
  test:
    # Viktig: gi jobben et miljønavn som matcher federated credential i Azure
    environment: dev

    permissions:
      id-token: write
      contents: read

    runs-on: ubuntu-latest
    steps:
      - name: Azure Login
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          enable-AzPSSession: true

      - name: Azure CLI script
        uses: azure/cli@v2
        with:
          azcliversion: latest
          inlineScript: |
            az account show
```
---


