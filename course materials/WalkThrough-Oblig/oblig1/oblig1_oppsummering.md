# Oppsummering og begrunnelse for Terraform-løsningen

Dette lille Terraform-oppsettet demonstrerer flere sentrale prinsipper fra *Infrastructure as Code – 3rd edition* av Kief Morris. Valgene vi har gjort følger etablerte mønstre for design, struktur og håndtering av avhengigheter i infrastrukturkode.

---

## CUPID Properties for Design
Boken fremhever fem CUPID-egenskaper som gjør infrastrukturkode “a joy to work with” :

- **Composable**: Modulene `network` og `compute-vm` kan brukes hver for seg eller sammen i en stack. Dette gir isolasjon og gjør endringer enklere å teste.
- **Unix philosophy**: Hver modul gjør én ting – `network` håndterer nettverk, `compute-vm` håndterer VM-oppsett. Dette gir høy *cohesion*.
- **Predictable**: Bruk av `locals`, `variables` og tydelige `outputs` gjør koden forutsigbar. Når man kjører `terraform plan`, ser man klart hva som opprettes.
- **Idiomatic**: Ressursnavn og variabler følger Terraform- og Azure-konvensjoner. Det føles naturlig for en som kjenner verktøyene.
- **Domain-based**: Koden modellerer domenet (nettverk og VM) i stedet for tekniske detaljer. Dette samsvarer med bokas anbefaling om å strukturere rundt kapabiliteter, ikke implementasjon.

---

## Cohesion and Coupling
- **Cohesion**: Hver modul har høy sammenheng – alt i `network` handler om VNet og subnets, alt i `compute-vm` handler om én VM. Dette følger prinsippet om at en komponent bør ha ett formål.
- **Coupling**: Vi reduserer koblinger mellom moduler ved å bruke `outputs` fra `network` og `inputs` til `compute-vm`. Dermed slipper `compute-vm` å vite detaljer om hvordan nettverket er implementert, kun at det mottar et `subnet_id`.

---

## Providers, Consumers, and Interfaces
I designet fungerer:
- `network` som **provider**: Den tilbyr subnets via `outputs`.
- `compute-vm` som **consumer**: Den tar inn `subnet_id` som input.  

Dette tydeliggjør forholdet mellom moduler og følger anbefalingen om å bruke eksplisitte provider–consumer-relasjoner for å unngå skjulte avhengigheter.

---

## Management of Interfaces Between Components
Boken understreker at avhengigheter bør defineres som eksplisitte **interfaces** og ikke som implisitte bindinger.  
I konfigurasjonen oppnår vi dette ved å:
- Eksponere ressurser gjennom `outputs` i modulene.
- Importere nødvendige verdier gjennom `variables` i stack-laget.  

Dette gjør det enkelt å endre implementasjonsdetaljer i en modul uten å måtte endre andre moduler (løst koblet design).

---

## Patterns for Sizing and Structuring Stacks
Oppsettet bruker en **stack** som syr sammen moduler. Dette bygger på mønstrene for å strukturere stacks:
- **Single Service Stack**: Hver stack (f.eks. dev, test, prod) inneholder en RG, nettverk og en VM.
- **Shared Stack** kan introduseres senere dersom flere team deler nettverk eller andre ressurser.
- **Reusable Stack**: Stacken kan enkelt kopieres til nye miljøer ved å bruke andre `tfvars`-filer.

---

## Stack Patterns for Multiple Instances of Infrastructure
Vi har laget egne mapper for `dev`, `test` og `prod`, hver med egne variabler og `tfvars`. Dette følger mønsteret **Stack per Environment**, som gir:
- Konsistens i struktur.
- Mulighet for uavhengige endringer og testing i hvert miljø.
- Bruk av samme modulære kodebase på tvers av instanser.

---

## Patterns for Configuring Stacks
Vi benytter flere konfigurasjonsmønstre beskrevet i boken:
- **Stack Configuration Files**: Hver miljømappe har sin `*.tfvars`-fil for parameterisering (f.eks. IP-adresser, VM-størrelse).
- **Stack Environment Variables** (kan utvides): Miljøvariabler kan supplere eller overstyre konfigurasjon i pipelines.
- **Deployment Wrapper Stack** (videre utvikling): Stack-laget kan senere brukes som et wrapper for mer komplekse tjenester eller CI/CD-integrasjon.

---

## Plassering av Resource Group (RG)

Et sentralt designvalg i Terraform-prosjekter er hvor **Resource Group** skal opprettes.  
Det finnes to vanlige mønstre, og valget avhenger av livssyklus, eierskap og styringsbehov.

### Alternativ A: RG i *stacken*
- **Fordeler**: Høy cohesion – hele stacken (RG, nettverk, VM) eies, endres og slettes samlet.  
  Dette gjør test, opprydding og re-deploy enkelt, spesielt i undervisning og sandkassemiljøer.  
- **Livssyklus**: RG lever og dør med stacken.  
- **God praksis for**: Studentøvinger, små team, og isolerte tjenester.

### Alternativ B: RG i *environment*
- **Fordeler**: Muliggjør sentralisert styring av RG-er (policy, tagging, budsjetter, locks).  
  Stacken blir konsument og får `resource_group_name` som input.  
- **Livssyklus**: RG eies av miljøet, mens applikasjonsstacken kun bruker den.  
- **God praksis for**: Enterprise-miljøer, plattformteam som håndhever standarder, og scenarioer der flere stacks deler RG.

### Tommelfingerregel
- Bruk **RG i stacken** når målet er enkelhet, isolert livssyklus og rask iterasjon (dev/test-lab, kurs).  
- Bruk **RG i environment** når målet er governance, konsistens og kontroll på tvers av applikasjoner.  

> Det viktige er å unngå delt eller uklart eierskap. RG bør alltid eies av den komponenten (stack eller environment) som har det faktiske driftsansvaret for ressursene.


## Oppsummering
Dette oppsettet viser hvordan små, men tydelig strukturerte Terraform-moduler kan designes i tråd med prinsippene fra *Infrastructure as Code*. Gjennom:
- **CUPID-prinsipper** (enkelt, forutsigbart, idiomatisk),
- **Høy cohesion og lav coupling**,
- **Eksplisitte interfaces via variables og outputs**,  
- **Bruk av patterns for stacks og konfigurasjon**,  

oppnår vi en løsning som er lett å forstå, endre, teste og utvide. Dette gir studentene en praktisk øvelse i å anvende teori til en fungerende infrastrukturkode.
