# Symboles de Mana - Guide d'intégration

## 📦 Assets téléchargés

Les symboles de mana ont été téléchargés depuis l'API Scryfall et convertis en PNG pour une utilisation dans l'application iOS.

### Fichiers disponibles
- **35 fichiers SVG** dans `MTG Helper/Assets.xcassets/ManaSymbols.imageset/symbols/`
- **35 fichiers PNG (64x64)** dans le même dossier

### Types de symboles
- Couleurs de base : W, U, B, R, G, C
- Mana générique : 0-20
- Mana variable : X, Y, Z
- Symboles spéciaux : T (tap), Q (untap), S (snow), P (phyrexian), H (hybrid)

## 🔧 Intégration au projet Xcode

Pour que les images PNG soient accessibles via `UIImage(named:)`, vous devez les ajouter au projet Xcode :

### Option 1 : Via Xcode (Recommandé)
1. Ouvrez le projet `MTG Helper.xcodeproj` dans Xcode
2. Cliquez-droit sur le dossier `Assets.xcassets`
3. Sélectionnez "Add Files to MTG Helper..."
4. Naviguez vers `MTG Helper/Assets.xcassets/ManaSymbols.imageset/symbols/`
5. Sélectionnez tous les fichiers `.png`
6. Cochez "Copy items if needed"
7. Cliquez sur "Add"

### Option 2 : Créer un Asset Catalog
1. Dans Xcode, cliquez-droit sur `Assets.xcassets`
2. Sélectionnez "New Folder" et nommez-le "ManaSymbols"
3. Glissez-déposez tous les fichiers PNG dans ce dossier
4. Xcode créera automatiquement les imagesets nécessaires

### Option 3 : Script automatique
Les PNG peuvent aussi être copiés dans un dossier de ressources du bundle :
```bash
# Créer un dossier Resources dans le projet
mkdir -p "MTG Helper/Resources/symbols"

# Copier les PNG
cp "MTG Helper/Assets.xcassets/ManaSymbols.imageset/symbols/"*.png "MTG Helper/Resources/symbols/"
```

Ensuite, ajoutez le dossier Resources au projet Xcode en tant que "folder reference" (dossier bleu, pas jaune).

## 📝 Utilisation dans le code

Le code a été mis à jour pour utiliser les assets locaux avec fallback :

```swift
// Utilisation simple
ManaSymbolView(symbol: "W", size: 20)

// Affichage d'un coût de mana complet
ManaCostView(manaCost: "{2}{U}{U}", symbolSize: 18)
```

Le système fonctionne ainsi :
1. Essaie d'abord de charger l'image locale
2. Si elle n'existe pas, utilise l'URL Scryfall en fallback
3. Si les deux échouent, affiche un placeholder textuel

## 🚀 Scripts disponibles

### `download_mana_symbols.sh`
Télécharge les symboles SVG depuis l'API Scryfall.

```bash
./download_mana_symbols.sh
```

### `convert_svg_to_png.sh`
Convertit les SVG téléchargés en PNG (64x64) pour iOS.

```bash
./convert_svg_to_png.sh
```

### Combinaison des deux
Pour télécharger et convertir en une seule commande :

```bash
./download_mana_symbols.sh && ./convert_svg_to_png.sh
```

## ⚙️ Prérequis

Les scripts utilisent des outils macOS natifs :
- `curl` - téléchargement des fichiers
- `qlmanage` - génération de previews
- `sips` - conversion et redimensionnement d'images

Tous ces outils sont préinstallés sur macOS.

## 📂 Structure des fichiers

```
MTG Helper/
├── Assets.xcassets/
│   └── ManaSymbols.imageset/
│       ├── Contents.json
│       └── symbols/
│           ├── W.svg
│           ├── W.png
│           ├── U.svg
│           ├── U.png
│           └── ... (tous les symboles)
├── Data/
│   └── Helpers/
│       └── ManaSymbolHelper.swift
└── ...
```

## 🔄 Mise à jour des symboles

Pour mettre à jour les symboles (si de nouveaux sont ajoutés à Scryfall) :

1. Éditez `download_mana_symbols.sh` pour ajouter les nouveaux symboles
2. Exécutez les deux scripts :
```bash
./download_mana_symbols.sh && ./convert_svg_to_png.sh
```
3. Ajoutez les nouveaux PNG au projet Xcode
4. Mettez à jour `supportedSymbols` dans `ManaSymbolHelper.swift`

## ✅ Vérification

Pour vérifier que les assets sont correctement intégrés :

1. Buildez le projet dans Xcode
2. Vérifiez qu'il n'y a pas d'avertissements concernant les ressources manquantes
3. Lancez l'app et testez l'affichage des symboles de mana

Si les images locales ne se chargent pas, le système utilisera automatiquement les URLs Scryfall en fallback.
