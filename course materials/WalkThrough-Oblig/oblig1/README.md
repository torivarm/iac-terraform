# Terraform Azure – modul- og miljøstruktur

Dette repoet følger et enkelt mønster:
- `modules/` inneholder gjenbrukbare moduler (nettverk, VM).
- `stacks/` er et komposisjonslag som syr sammen moduler til en deploybar stack.
- `environments/{dev,test,prod}` er egne **root modules** med backend og provider.
  Hvert miljø peker på `../../stacks` og leverer inn sine variabler (via tfvars).
