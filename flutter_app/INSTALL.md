# Installation et Configuration

## Prérequis

1. **Flutter SDK** (version 3.0+)
2. **Android Studio** ou **VS Code** avec extensions Flutter/Dart
3. **Android SDK** (API level 21+)
4. **Appareil Android** ou **Émulateur Android**

## Installation Flutter

### Sur Linux/macOS:
```bash
# Télécharger Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Vérifier l'installation
flutter doctor
```

### Sur Windows:
1. Télécharger Flutter SDK depuis https://flutter.dev
2. Extraire dans C:\flutter
3. Ajouter C:\flutter\bin au PATH
4. Exécuter `flutter doctor`

## Configuration du projet

```bash
# Naviguer vers le répertoire du projet
cd flutter_app

# Installer les dépendances
flutter pub get

# Vérifier la configuration
flutter doctor

# Lister les appareils disponibles
flutter devices
```

## Lancement de l'application

```bash
# Connecter un appareil Android ou démarrer un émulateur
# Puis lancer l'application
flutter run

# Pour un build de release
flutter build apk --release
```

## Configuration Android

L'application est configurée pour:
- **Package**: com.wheelmoon.fintech
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest
- **Permissions**: Internet, Network State

## Dépannage

### Erreur "flutter command not found"
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Erreur de licence Android
```bash
flutter doctor --android-licenses
```

### Problème de dépendances
```bash
flutter clean
flutter pub get
```

## Structure du projet

```
flutter_app/
├── lib/                    # Code source Dart
│   ├── main.dart          # Point d'entrée
│   ├── models/            # Modèles de données
│   ├── services/          # Services API
│   └── screens/           # Écrans UI
├── android/               # Configuration Android
├── assets/                # Ressources (images, etc.)
└── pubspec.yaml          # Configuration Flutter
```

## Tests

```bash
# Exécuter les tests
flutter test

# Analyser le code
flutter analyze
```
