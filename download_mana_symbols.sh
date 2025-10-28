#!/bin/bash

# Script pour télécharger les symboles de mana depuis Scryfall
# et les convertir en PNG pour iOS

SYMBOLS_DIR="/Users/dperocheau/SandBox/MTG Helper/MTG Helper/Assets.xcassets/ManaSymbols.imageset/symbols"

# Liste des symboles de mana principaux à télécharger
SYMBOLS=(
    "W" "U" "B" "R" "G" "C"  # Couleurs de base
    "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  # Mana générique
    "X" "Y" "Z"  # Mana variable
    "T" "Q"  # Tap/Untap
    "S"  # Snow mana
    "P"  # Phyrexian mana
    "H"  # Hybrid mana
)

echo "Téléchargement des symboles de mana..."

for symbol in "${SYMBOLS[@]}"; do
    echo "Téléchargement du symbole {$symbol}..."
    
    # Télécharger le SVG
    curl -s "https://svgs.scryfall.io/card-symbols/${symbol}.svg" -o "${SYMBOLS_DIR}/${symbol}.svg"
    
    if [ -f "${SYMBOLS_DIR}/${symbol}.svg" ]; then
        echo "  ✓ SVG téléchargé pour {$symbol}"
        
        # Convertir en PNG avec différentes tailles
        # 1x (16x16)
        rsvg-convert -w 16 -h 16 "${SYMBOLS_DIR}/${symbol}.svg" -o "${SYMBOLS_DIR}/${symbol}-16.png" 2>/dev/null || echo "  ⚠️ rsvg-convert non disponible, utilisation d'ImageMagick"
        
        # 2x (32x32)
        rsvg-convert -w 32 -h 32 "${SYMBOLS_DIR}/${symbol}.svg" -o "${SYMBOLS_DIR}/${symbol}-32.png" 2>/dev/null || echo "  ⚠️ rsvg-convert non disponible, utilisation d'ImageMagick"
        
        # 3x (48x48)
        rsvg-convert -w 48 -h 48 "${SYMBOLS_DIR}/${symbol}.svg" -o "${SYMBOLS_DIR}/${symbol}-48.png" 2>/dev/null || echo "  ⚠️ rsvg-convert non disponible, utilisation d'ImageMagick"
        
        # Essayer avec ImageMagick si rsvg-convert n'est pas disponible
        if [ ! -f "${SYMBOLS_DIR}/${symbol}-16.png" ]; then
            convert "${SYMBOLS_DIR}/${symbol}.svg" -resize 16x16 "${SYMBOLS_DIR}/${symbol}-16.png" 2>/dev/null || echo "  ⚠️ ImageMagick non disponible"
        fi
        
        if [ ! -f "${SYMBOLS_DIR}/${symbol}-32.png" ]; then
            convert "${SYMBOLS_DIR}/${symbol}.svg" -resize 32x32 "${SYMBOLS_DIR}/${symbol}-32.png" 2>/dev/null || echo "  ⚠️ ImageMagick non disponible"
        fi
        
        if [ ! -f "${SYMBOLS_DIR}/${symbol}-48.png" ]; then
            convert "${SYMBOLS_DIR}/${symbol}.svg" -resize 48x48 "${SYMBOLS_DIR}/${symbol}-48.png" 2>/dev/null || echo "  ⚠️ ImageMagick non disponible"
        fi
        
    else
        echo "  ✗ Échec du téléchargement pour {$symbol}"
    fi
done

echo "Téléchargement terminé !"
echo "Symboles disponibles dans: ${SYMBOLS_DIR}"
