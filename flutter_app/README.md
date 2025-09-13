# WheelMoon Fintech App

Une application mobile Flutter Android pour la gestion de comptes bancaires et les retraits d'argent.

## Fonctionnalités

- **Authentification sécurisée** : Connexion avec mot de passe à 6 chiffres
- **Dashboard** : Vue d'ensemble des comptes avec solde total
- **Liste des comptes** : Affichage de tous les comptes utilisateurs
- **Détails des comptes** : Informations détaillées par compte avec comptes bancaires associés
- **Retrait d'argent** : Processus complet de retrait vers un numéro de téléphone
- **Interface moderne** : Design inspiré des meilleures pratiques fintech
- **Gestion des erreurs** : Validation des données et feedback utilisateur
- **Stockage des préférences** : État de connexion persistant

## Architecture

L'application suit une architecture claire avec séparation des responsabilités :

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/                   # Modèles de données
│   ├── compte_utilisateur.dart
│   └── retrait.dart
├── services/                 # Services API et données
│   ├── api_service.dart
│   └── data_service.dart
└── screens/                  # Écrans de l'application
    ├── login_screen.dart
    ├── dashboard_screen.dart
    ├── accounts_list_screen.dart
    ├── account_detail_screen.dart
    └── withdrawal_screen.dart
```

## Modèles de données

### CompteUtilisateur
- `numeroTelephone`: Numéro de téléphone du titulaire
- `motDePasse`: Mot de passe (6 chiffres)
- `nom`: Nom complet du titulaire
- `comptesBancaires`: Liste des comptes bancaires associés

### CompteBancaire
- `numeroCompte`: Numéro unique du compte
- `typeCompte`: Type (CHEQUES, EPARGNE SUR LIVRET)
- `solde`: Solde actuel du compte

## API Integration

L'application intègre les APIs Afriland First Bank :

1. **Authentification** : `/user-management/api-public/auth/login`
2. **Bank to Wallet** : `/wallet-management/api/wallets/topUp/afriland`
3. **Wallet to Phone** : `/gimac/customer/v2/doTransferToOtherWallet`

## Processus de retrait

1. L'utilisateur sélectionne un compte bancaire avec solde positif
2. Saisit le montant à retirer et le numéro bénéficiaire
3. L'app se connecte avec les identifiants du compte
4. Effectue un transfert Bank → Wallet
5. Puis un transfert Wallet → Téléphone bénéficiaire

## Installation et lancement

```bash
# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

# Lancer avec une URL de comptes personnalisée
flutter run --dart-define=ACCOUNTS_URL=https://example.com/accounts.txt
```

## Configuration

### URL des comptes
L'application peut charger les données de comptes depuis une URL externe en utilisant la variable d'environnement `ACCOUNTS_URL` :

```bash
# Exemple avec URL personnalisée
flutter run --dart-define=ACCOUNTS_URL=https://votre-serveur.com/comptes.txt

# Build de production avec URL
flutter build apk --dart-define=ACCOUNTS_URL=https://api.production.com/accounts
```

Si aucune URL n'est fournie, l'application utilise les données d'exemple intégrées.

## Sécurité

- Authentification par mot de passe à 6 chiffres
- Validation des montants et soldes
- Gestion des erreurs réseau et API
- Validation des formats de données avant envoi API

## Design

L'interface suit les principes de design moderne avec :
- Thème sombre pour l'authentification et les retraits
- Thème clair pour le dashboard et la navigation
- Cards et animations fluides
- Feedback visuel pour toutes les actions
