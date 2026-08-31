# Veiviser: Opprettelse av Organisasjon, repository og environments på git.ntnu.no

Denne veiviseren viser deg hvordan du setter opp en organisasjon i Git.ntnu.no, oppretter et repository og konfigurerer environments og secrets for bruk med Azure.

---

## 1. Opprett en organisasjon
1. Gå til [https://git.ntnu.no/account/organizations/new](https://git.ntnu.no/account/organizations/new).
2. Skriv inn:
   1. Et ønsket unikt navn på organisasjonen (kan være hva som helst, kom på en eksempelorganisasjon).
3. Fullfør opprettelsen.

---

**MERK 1: HVIS DU ØNSKER Å FORTSETTE Å BRUKE ET EKSISTERENDE GIT REPOSITORY KAN DETTE MIGRERES OVER TIL NYLIG OPPRETTE ORGANISASJON. STOPP HER OG SE EGEN VEVISER**

---

**MERK 2: DU MÅ ENDRE STIEN TIL REPOET PÅ NYTT I VS CODE**

---

## 2. Opprett et nytt repository
1. Gå inn i organisasjonen din og deretter Repository.
   1. ![alt text](img/newrepo.png)
2. Klikk på **New** for å opprette et nytt repository.
3. Gi repository et navn
4. Velg **Public** eller **Private** etter behov.
   1. Public: pass på hvilken informasjon du legger ut, men du får mer funksjonalitet. Vi skal ikke legge ut noe sensitiv i fagopplegget.
   2. Private: Ingen på internettet kan se det, mer begrenset funksjonalitet, vanskelig å dele med faglærer / læringsassistent.
5. Velg Terraform som .gitignore
   1. ![alt text](img/gitignore.png)
6. Klikk på **Create repository**.

---

## 3. Opprett environments (dev, test, prod)
1. Gå inn i repository.
2. Klikk på **Settings** → **Environments**.
   1. ![alt text](img/env.png)
3. Klikk på **New environment**.
   - Gi navnet `dev`.
   - Lagre.
4. Gjenta prosessen og opprett environments `test` og `prod`.
   1. ![alt text](img/envcreate.png)

---

## 4. Legg til Repository Secrets
For å kunne bruke Github Actions mot Azure, må du legge inn nødvendige secrets.

1. Gå til repository → **Settings** → **Secrets and variables** → **Actions**.
2. Klikk **New repository secret**.
3. ![alt text](img/actionsecrets.png)
4. Opprett følgende secrets (navn må være nøyaktig som skrevet under):
   - `AZURE_CLIENT_ID` → Lim inn DIN APP REGISTRATION Client ID fra Azure.
     - ![alt text](img/clientidgithub.png)
     - ![alt text](img/clientIDazure.png)
   - `AZURE_SUBSCRIPTION_ID` → Lim inn Subscription ID fra Azure.
   - `AZURE_TENANT_ID` → Lim inn Tenant ID fra Azure.
   - Når du er ferdig vil det se ut som dette (MERK, kan kun editeres i etterkant, en kan ikke vise verdien til en secret, som er hele poenget med en secret):
   - ![alt text](img/allsecrets.png)
5. Nå kan workflow-filer bruke disse secrets i GitHub Actions.

---

✅ Du har nå:
- En organisasjon
- Et repository
- Tre environments (`dev`, `test`, `prod`)
- Repository secrets for Azure

Neste steg blir opprette Federated Credentials mellom din App Registration og Git.ntnu.no organisasjonen, repo og miljø (egen veiviser).
**MERK:** om du har et eksisterende repository på git.ntnu,no som du ønsker å fortsette å bruke i faget, kan du også migrere dette over til din nylige opprette organisasjon (se egen veiviser). 
