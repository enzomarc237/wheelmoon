# Modélisation des données

## Entités principales

- **CompteUtilisateur**

  - numéro de téléphone : string
  - nom : string
  - comptes bancaires : [CompteBancaire]

- **CompteBancaire**

  - numéro de compte : string
  - type de compte : enum (CHEQUES, EPARGNE SUR LIVRET)
  - solde : float

- **Retrait**
  - compte source : CompteBancaire
  - montant : float
  - numéro bénéficiaire : string
  - statut : enum (en attente, validé, refusé)
