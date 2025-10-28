# Cline Instructions — SwiftUI Side Project -> MTG Helper

## 1. Objectif général

Ce projet est une application iOS écrite en **Swift** avec le framework **SwiftUI**.  
L’objectif est de maintenir un **code clair, robuste et facilement extensible**, conforme aux bonnes pratiques d’architecture et de nommage.

Toutes les suggestions, corrections ou propositions de code doivent **respecter les conventions** et les choix structurels suivants.

---

## 2. Environnement technique

- **Langage** : Swift  
- **UI framework** : SwiftUI  
- **Architecture** : MVVMC (Model – View – ViewModel – Coordinator) + Repository pattern  
- **Stockage local** : SwiftData  
- **Plateforme cible** : iOS (versions récentes uniquement)  

---

## 3. Règles générales

- Ne **jamais utiliser d’emojis**.  
- Préférer la **clarté** à la concision (le code doit être lisible et auto-documenté).  
- Toujours **commenter les fonctions publiques** avec une description claire de leur rôle, des paramètres et de la valeur de retour.  
- Éviter **toute dépendance externe inutile** : privilégier les solutions natives SwiftUI / Foundation.  
- **Ne jamais exécuter, compiler ou lancer le simulateur** sauf demande explicite.  
- Favoriser la **simplicité et la maintenabilité** plutôt que la micro-optimisation.

---

## 4. Architecture

### MVVMC + Repository pattern

- **Model** : Structures de données et entités métier (SwiftData, Codable, etc.).
- **View** : Composants SwiftUI responsables de l’affichage uniquement.
- **ViewModel** : Gère la logique de présentation et les transformations des données.
- **Coordinator** : Responsable de la navigation et de la création des vues.  
  - Chaque flux principal (authentification, dashboard, paramètres, etc.) a son propre coordinator.
- **Repository** : Interagit avec les sources de données (SwiftData, API REST, etc.).  
  - Les ViewModels ne communiquent **jamais directement** avec SwiftData ni le réseau.

#### Exemple de structure de dossiers

Sources/
Models/
Views/
ViewModels/
Coordinators/
Repositories/
Resources/


---

## 5. Conventions de nommage

### Fichiers et types
| Élément | Convention | Exemple |
|----------|-------------|----------|
| Classe | PascalCase | `UserProfileViewModel` |
| Struct | PascalCase | `User` |
| Enum | PascalCase | `AppRoute` |
| Protocol | PascalCase + suffixe descriptif | `RepositoryProtocol` |
| Fonction / propriété | camelCase | `loadUserData()` |
| Constante | camelCase | `maxRetryCount` |
| Vue SwiftUI | Suffixe `View` | `LoginView` |
| ViewModel | Suffixe `ViewModel` | `LoginViewModel` |
| Coordinator | Suffixe `Coordinator` | `AppCoordinator` |

### Divers
- Les noms doivent être **explicites** et décrire la responsabilité de l’élément.  
- Éviter les abréviations (préférer `userProfile` à `usrProf`).  
- Les fichiers doivent porter **le même nom** que la classe principale qu’ils contiennent.

---

## 6. Clean architecture (dans la mesure du possible)

- Séparer clairement les **couches de responsabilité** :
  - `Domain` : logique métier pure, indépendante des frameworks.
  - `Data` : implémentations concrètes (SwiftData, API, persistence).
  - `Presentation` : SwiftUI + ViewModels + Coordinators.
- Les dépendances doivent toujours aller **de haut niveau vers bas niveau** (jamais l’inverse).
- Favoriser l’injection de dépendances (par constructeur ou protocol).
- Éviter toute logique métier dans les `Views`.
- Le `ViewModel` ne doit jamais connaître le `View` spécifique.

---

## 7. Documentation & commentaires

- Utiliser les **doc comments Swift** `///` pour toutes les fonctions publiques :
  ```swift
  /// Charge les données utilisateur depuis le dépôt principal.
  /// - Parameter userId: Identifiant de l’utilisateur à charger.
  /// - Returns: Une instance `User` ou `nil` si l’utilisateur n’existe pas.
  func loadUserData(for userId: String) -> User?
- Ajouter une brève description en en-tête de chaque fichier, précisant son rôle.


---

## 8. Bonnes pratiques additionnelles

- Utiliser @MainActor pour tout code UI.
- Centraliser les constantes dans un fichier Constants.swift.
- Toujours utiliser des Task {} ou async/await pour les opérations asynchrones.
- Organiser le code avec des MARK: et // TODO: si besoin.
- Les tests unitaires (si présents) doivent viser la logique des ViewModels et Repositories uniquement.

## 9. Style général de code

- Indentation : 4 espaces (pas de tabulations).
- Espacement : une ligne vide entre chaque fonction.
- Les closures doivent utiliser [weak self] si elles capturent self dans un contexte asynchrone.
- Les imports doivent être triés et minimisés.

Fichier de référence pour Cline.
Ne pas modifier sans accord global du projet.