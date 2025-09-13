# Recherche technique

## Points à explorer

- Bonnes pratiques Flutter pour la sécurité par mot de passe
- Gestion des erreurs réseau et format de données
- UI/UX fintech moderne (exemples d’images à demander)
- Structuration des entités (CompteUtilisateur, CompteBancaire, Retrait)
- Approche pour la gestion des retraits et validation

## Décisions à prendre

- Méthode de stockage du mot de passe
- Format et parsing du fichier de comptes
- Endpoints API à définir



## Réponses

- Le mot de passe doit être une suite de 6 caractères numériques;
- Le flow d'exécution est le suivant, lorsqu'un utilisateur initie un retrait, l'application se connecte en utilisant le numéro de téléphone et le mot de passe du comptebancaire sélectionné. Une fois le token obtenu, 