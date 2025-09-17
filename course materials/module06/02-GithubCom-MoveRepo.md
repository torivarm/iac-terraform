# Veiviser: Migrere et GitHub-repository til en organisasjon

Denne guiden viser deg hvordan du flytter et eksisterende repository til en organisasjon du har opprettet i GitHub.  

---

## 1. Forberedelser
- Sørg for at du er **eier** eller har tilstrekkelig rettigheter i organisasjonen.
- Sørg for at du har **admin-rettigheter** på repositoryet du vil flytte.
- Åpne repositoryet du ønsker å migrere (fra din egen brukerprofil).

---

## 2. Overfør repository til organisasjon
1. Gå inn på repositoryet du vil flytte.
2. Klikk på **Settings** (øverst i menyen).
   1. ![alt text](img/settingmoverepo.png)
3. Scroll ned til seksjonen **Danger Zone**.
4. Velg **Transfer ownership**.
   1. ![alt text](img/dangerzone.png)
5. Skriv inn navnet på organisasjonen du vil flytte til.
6. Bekreft overføringen ved å skrive inn repository-navnet.
7. Klikk **I understand, transfer this repository**.

Repositoryet vil nå ligge under organisasjonen i stedet for din personlige GitHub-konto.

---

## 3. Oppdatere lokal tilkobling i VS Code
Når du flytter et repository, endres **URL-en** til `origin` i Git.  
Dette betyr at din lokale klone i VS Code fortsatt peker på den gamle adressen.

### Sjekk gjeldende URL
Åpne terminalen i VS Code og kjør:
```bash
git remote -v
```
Du vil deretter se noe som dette:
```bash
origin  https://github.com/ditt-brukernavn/repo-navn.git (fetch)
origin  https://github.com/ditt-brukernavn/repo-navn.git (push)
```

### Oppdater URL til den nye organisasjonen
Kjør følgende kommando for å oppdatere origin til den nye plasseringen:
```bash
git remote set-url origin https://github.com/<org-navn>/<repo-navn>.git
```
Bekreft endringen:
```bash
git remote -v
```