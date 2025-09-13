# Tasks: Application mobile Flutter Android Fintech

**Input**: Design documents from `/specs/001-créer-une-application/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)

```
1. Charger plan.md, extraire stack Flutter, structure mobile
2. Charger data-model.md, extraire entités
3. Charger contracts/, lister endpoints à tester
4. Charger research.md, intégrer décisions techniques
5. Charger quickstart.md, scénarios de test
6. Générer tâches par catégorie et dépendances
7. Marquer [P] pour tâches parallèles
8. Valider la complétude
```

## Phase 3.1: Setup

- [ ] T001 Créer la structure du projet Flutter dans `mobile/`
- [ ] T002 Initialiser le projet Flutter avec les dépendances nécessaires (http, provider, etc.)
- [ ] T003 [P] Configurer les outils de linting et formatage (`mobile/analysis_options.yaml`)

## Phase 3.2: Tests First (TDD)

- [ ] T004 [P] Test de contrat : chargement de la liste des comptes depuis l'URL dans `mobile/test/contract/test_load_accounts.dart`
- [ ] T005 [P] Test de contrat : initiation d'un retrait dans `mobile/test/contract/test_withdrawal.dart`
- [ ] T006 [P] Test d'intégration : connexion avec mot de passe dans `mobile/test/integration/test_login.dart`
- [ ] T007 [P] Test d'intégration : affichage des comptes et soldes dans `mobile/test/integration/test_home_screen.dart`
- [ ] T008 [P] Test d'intégration : consultation des détails d'un compte dans `mobile/test/integration/test_account_details.dart`
- [ ] T009 [P] Test d'intégration : validation d'un retrait dans `mobile/test/integration/test_withdrawal_flow.dart`

## Phase 3.3: Core Implementation

- [ ] T010 [P] Créer le modèle `CompteUtilisateur` dans `mobile/lib/models/compte_utilisateur.dart`
- [ ] T011 [P] Créer le modèle `CompteBancaire` dans `mobile/lib/models/compte_bancaire.dart`
- [ ] T012 [P] Créer le modèle `Retrait` dans `mobile/lib/models/retrait.dart`
- [ ] T013 Créer le service de gestion des comptes dans `mobile/lib/services/compte_service.dart`
- [ ] T014 Créer le service de gestion des retraits dans `mobile/lib/services/retrait_service.dart`
- [ ] T015 Implémenter l'écran d'accueil dans `mobile/lib/screens/home_screen.dart`
- [ ] T016 Implémenter l'écran de liste des comptes dans `mobile/lib/screens/accounts_list_screen.dart`
- [ ] T017 Implémenter l'écran de détails d'un compte dans `mobile/lib/screens/account_details_screen.dart`
- [ ] T018 Implémenter l'écran de retrait dans `mobile/lib/screens/withdrawal_screen.dart`
- [ ] T019 Implémenter la logique de validation du mot de passe dans `mobile/lib/services/auth_service.dart`

## Phase 3.4: Integration

- [ ] T020 Connecter le service de comptes à la source de données (API ou fichier) dans `mobile/lib/services/compte_service.dart`
- [ ] T021 Connecter le service de retraits à l'API dans `mobile/lib/services/retrait_service.dart`
- [ ] T022 Ajouter la gestion des erreurs réseau et des messages utilisateur dans `mobile/lib/utils/error_handler.dart`
- [ ] T023 Ajouter le logging des opérations dans `mobile/lib/utils/logger.dart`

## Phase 3.5: Polish

- [ ] T024 [P] Ajouter des tests unitaires pour la validation des entrées dans `mobile/test/unit/test_validation.dart`
- [ ] T025 [P] Ajouter des tests de performance dans `mobile/test/performance/test_performance.dart`
- [ ] T026 [P] Mettre à jour la documentation dans `mobile/README.md`
- [ ] T027 Vérifier la conformité du design et intégrer les images fournies dans `mobile/assets/`
- [ ] T028 Effectuer des tests manuels et valider le parcours utilisateur dans `mobile/test/manual-testing.md`

## Dependencies

- T004-T009 (tests) avant T010-T019 (implémentation)
- T010-T012 (modèles) avant T013-T014 (services)
- T013-T014 avant T015-T019 (UI)
- T020-T023 (intégration) après services et UI
- T024-T028 (polish) après tout le reste

## Exemple d'exécution parallèle

```
# Lancer T004-T009 ensemble :
- Test de contrat : chargement des comptes
- Test de contrat : retrait
- Test d'intégration : login
- Test d'intégration : home screen
- Test d'intégration : account details
- Test d'intégration : withdrawal flow
```

## Notes

- Les tâches [P] peuvent être réalisées en parallèle+
- Chaque tâche indique le chemin exact du fichier concerné
- Commiter après chaque tâche
- Valider que les tests échouent avant d'implémenter
- Éviter les conflits sur les mêmes fichiers pour les tâches parallèles
