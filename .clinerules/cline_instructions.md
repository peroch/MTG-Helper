# Cline Instructions — MTG Helper

Ce fichier sert d'index pour les instructions Cline du projet **MTG Helper**.

---

## Structure des règles

Les règles ont été divisées en deux fichiers pour une meilleure organisation :

### 1. Règles Génériques
**Fichier** : `generic_rules.md`

Contient toutes les règles et bonnes pratiques applicables à **tout projet Swift/SwiftUI**, incluant :
- Principes généraux de développement
- Conventions de nommage (classes, structs, enums, etc.)
- Principes de Clean Architecture
- Documentation et commentaires
- Bonnes pratiques Swift/SwiftUI
- Style général de code
- Approche des tests unitaires

Ces règles peuvent être réutilisées dans n'importe quel projet Swift/SwiftUI.

### 2. Règles Spécifiques au Projet
**Fichier** : `project_specific_rules.md`

Contient les règles spécifiques au projet **MTG Helper**, incluant :
- Présentation du projet
- Environnement technique (SwiftUI, SwiftData, API Scryfall)
- Architecture MVVMC détaillée
- Structure de dossiers du projet
- Coordinators spécifiques (Search, Decks, Game)
- Repositories et Use Cases existants
- Spécificités métier Magic: The Gathering
- Entités principales (Card, Deck, Player, Game)

---

## Utilisation

Pour travailler sur ce projet, Cline doit respecter :
1. **Les règles génériques** définies dans `generic_rules.md`
2. **Les règles spécifiques** définies dans `project_specific_rules.md`

En cas de conflit entre les deux fichiers, les règles spécifiques au projet prévalent.

---

Fichier d'index pour Cline.
Ne pas modifier sans validation.
