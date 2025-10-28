#!/bin/bash

# Script pour convertir les symboles SVG en PNG pour iOS

SYMBOLS_DIR="MTG Helper/Assets.xcassets/ManaSymbols.imageset/symbols"

echo "Conversion des SVG en PNG..."

# Compter le nombre de fichiers SVG
total=$(ls -1 "$SYMBOLS_DIR"/*.svg 2>/dev/null | wc -l)
current=0

for svg_file in "$SYMBOLS_DIR"/*.svg; do
    if [ -f "$svg_file" ]; then
        current=$((current + 1))
        filename=$(basename "$svg_file" .svg)
        
        echo "[$current/$total] Conversion de ${filename}.svg..."
        
        # Créer une version PNG temporaire avec qlmanage
        qlmanage -t -s 128 -o "$SYMBOLS_DIR" "$svg_file" > /dev/null 2>&1
        
        # Renommer et convertir en PNG propre
        if [ -f "$SYMBOLS_DIR/${filename}.svg.png" ]; then
            # Convertir en PNG avec fond transparent et taille optimale
            sips -s format png -z 64 64 "$SYMBOLS_DIR/${filename}.svg.png" --out "$SYMBOLS_DIR/${filename}.png" > /dev/null 2>&1
            rm "$SYMBOLS_DIR/${filename}.svg.png"
            echo "  ✓ PNG créé pour ${filename} (64x64)"
        else
            echo "  ⚠️ Échec de conversion pour ${filename}"
        fi
    fi
done

echo ""
echo "Conversion terminée !"
ls -1 "$SYMBOLS_DIR"/*.png 2>/dev/null | wc -l | xargs echo "Nombre de fichiers PNG créés:"
