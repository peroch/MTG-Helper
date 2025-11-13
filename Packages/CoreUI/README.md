# CoreUI Package

## Description

Le package **CoreUI** contient tous les composants UI réutilisables et le système de design de l'application MTG Helper.

## Contenu

### Theme (`Theme.swift`)
Système de design centralisé incluant :
- **Colors** : Palette de couleurs de l'application
- **Typography** : Styles de police (title, subtitle, body, caption)
- **Spacing** : Espacements standardisés (xs, sm, md, lg, xl)
- **CornerRadius** : Rayons de coins (small, medium, large)
- **PrimaryButtonStyle** : Style de bouton principal

### Composants UI (`Components/`)

#### ToastView & ToastMessage
Système de notifications toast pour afficher des messages temporaires à l'utilisateur.
- **ToastMessage** : Modèle de données pour les messages toast
- **ToastView** : Vue d'affichage du toast
- **ToastModifier** : ViewModifier pour gérer l'apparition/disparition automatique
- Support de la durée d'affichage configurable

#### ComingSoonOverlayView
Vue overlay pour les fonctionnalités à venir.
- Affichage semi-transparent
- Message "Coming Soon" personnalisable
- Design cohérent avec le thème de l'application

#### ManaSymbolHelper & Vues Mana
Gestion et affichage des symboles de mana Magic: The Gathering.
- **ManaSymbolHelper** : Parsing et gestion des symboles (W, U, B, R, G, C, nombres, X, Y, Z, etc.)
- **ManaSymbolView** : Affichage d'un symbole individuel avec fallback vers Scryfall
- **ManaCostView** : Affichage d'un coût de mana complet

## Dépendances

Aucune dépendance externe. Le package utilise uniquement SwiftUI et Foundation.

## Utilisation

### Dans le projet principal

1. Ajoutez `import CoreUI` en haut de vos fichiers SwiftUI
2. Utilisez les composants :

```swift
import SwiftUI
import CoreUI

struct MaVue: View {
    @State private var toastMessage: ToastMessage?
    
    var body: some View {
        VStack {
            Text("Titre")
                .font(Theme.Typography.title)
                .foregroundColor(Theme.Colors.primary)
            
            ManaCostView(manaCost: "{2}{U}{U}", symbolSize: 20)
            
            Button("Show Toast") {
                toastMessage = ToastMessage(message: "Hello!")
            }
        }
        .padding(Theme.Spacing.md)
        .toast($toastMessage)
    }
}
```

### Exemples d'utilisation

#### Theme
```swift
Text("Title")
    .font(Theme.Typography.title)
    .foregroundColor(Theme.Colors.primary)
    
VStack(spacing: Theme.Spacing.md) {
    // content
}
.cornerRadius(Theme.CornerRadius.medium)
```

#### Toast
```swift
@State private var toastMessage: ToastMessage?

// Afficher un toast
toastMessage = ToastMessage(message: "Card added!", duration: 2.0)

// Appliquer le modifier
.toast($toastMessage)
```

#### Mana Symbols
```swift
// Coût de mana complet
ManaCostView(manaCost: "{3}{U}{U}", symbolSize: 20)

// Symbole individuel
ManaSymbolView(symbol: "U", size: 16)
```

#### Coming Soon Overlay
```swift
ZStack {
    MainView()
    
    if showComingSoon {
        ComingSoonOverlayView(message: "Deck Builder")
    }
}
```

## Structure des fichiers

```
CoreUI/
├── Package.swift
├── README.md
├── Sources/
│   └── CoreUI/
│       ├── CoreUI.swift
│       ├── Theme.swift
│       └── Components/
│           ├── ToastView.swift
│           ├── ComingSoonOverlayView.swift
│           └── ManaSymbolHelper.swift
└── Tests/
    └── CoreUITests/
        └── CoreUITests.swift
```

## Notes

- Tous les types et fonctions sont déclarés `public` pour être accessibles depuis l'extérieur du package
- Les initialisateurs des structs sont également marqués `public init()`
- Le package est compatible iOS 17+
- Aucune dépendance externe - utilise uniquement les frameworks système (SwiftUI, Foundation)

## Maintenance

Pour ajouter de nouveaux composants UI :
1. Créer le fichier dans `Sources/CoreUI/Components/`
2. Déclarer tous les types comme `public`
3. Ajouter une section dans ce README
4. Créer des tests dans `Tests/CoreUITests/`
