#!/bin/bash

# Script pour convertir les symboles SVG en PDF pour iOS

SYMBOLS_DIR="MTG Helper/Assets.xcassets/ManaSymbols.imageset/symbols"
PDF_DIR="MTG Helper/Assets.xcassets/ManaSymbols.imageset/pdf"

# Créer le dossier PDF s'il n'existe pas
mkdir -p "$PDF_DIR"

echo "Conversion des SVG en PDF..."

# Compter le nombre de fichiers SVG
total=$(ls -1 "$SYMBOLS_DIR"/*.svg 2>/dev/null | wc -l)
current=0

for svg_file in "$SYMBOLS_DIR"/*.svg; do
    if [ -f "$svg_file" ]; then
        current=$((current + 1))
        filename=$(basename "$svg_file" .svg)
        pdf_file="$PDF_DIR/${filename}.pdf"
        
        echo "[$current/$total] Conversion de ${filename}.svg en PDF..."
        
        # Utiliser qlmanage pour convertir SVG en PDF
        qlmanage -t -s 512 -o "$PDF_DIR" "$svg_file" > /dev/null 2>&1
        
        # Renommer le fichier généré
        if [ -f "$PDF_DIR/$(basename "$svg_file").png" ]; then
            # Si qlmanage a créé un PNG, le convertir en PDF avec sips
            sips -s format pdf "$PDF_DIR/$(basename "$svg_file").png" --out "$pdf_file" > /dev/null 2>&1
            rm "$PDF_DIR/$(basename "$svg_file").png"
            echo "  ✓ PDF créé pour ${filename}"
        elif [ -f "$pdf_file" ]; then
            echo "  ✓ PDF créé pour ${filename}"
        else
            echo "  ⚠️ Échec de conversion pour ${filename}"
        fi
    fi
done

echo ""
echo "Conversion terminée !"
echo "Fichiers PDF disponibles dans: $PDF_DIR"
ls -1 "$PDF_DIR"/*.pdf 2>/dev/null | wc -l | xargs echo "Nombre de fichiers PDF créés:"
