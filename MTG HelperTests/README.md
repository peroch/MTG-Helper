# Tests Unitaires - MTG Helper

Ce répertoire contient l'ensemble des tests unitaires pour l'application MTG Helper.

## Structure des Tests

```
MTG HelperTests/
├── Mocks/                      # Mocks des repositories
│   ├── MockCardRepository.swift
│   └── MockDeckRepository.swift
├── Helpers/                    # Utilitaires de test
│   └── TestDataFactory.swift
├── ViewModels/                 # Tests des ViewModels
│   ├── CardSearchViewModelTests.swift
│   ├── CardDetailViewModelTests.swift
│   └── DeckCardsViewModelTests.swift
└── UseCases/                   # Tests des UseCases
    ├── SearchCardsUseCaseTests.swift
    ├── GetCardDetailUseCaseTests.swift
    ├── AddCardToDeckUseCaseTests.swift
    ├── RemoveCardFromDeckUseCaseTests.swift
    └── GetDecksContainingCardUseCaseTests.swift
```

## Couverture des Tests

### ViewModels
- **CardSearchViewModel**: Tests de recherche, gestion des erreurs, état de chargement
- **CardDetailViewModel**: Tests de chargement de carte, gestion des decks, ajout de cartes
- **DeckCardsViewModel**: Tests de chargement et suppression de cartes, modes d'affichage

### UseCases
- **SearchCardsUseCase**: Tests de recherche avec différentes requêtes
- **GetCardDetailUseCase**: Tests de récupération de détails de cartes
- **AddCardToDeckUseCase**: Tests d'ajout de cartes aux decks
- **RemoveCardFromDeckUseCase**: Tests de suppression de cartes des decks
- **GetDecksContainingCardUseCase**: Tests de recherche de decks contenant une carte

## Mocks et Helpers

### MockCardRepository
Mock du `CardRepository` pour tester les interactions avec les cartes sans dépendance réseau.

**Fonctionnalités:**
- Simulation de recherche de cartes
- Simulation de récupération de détails de carte
- Gestion des erreurs simulées
- Comptage des appels pour vérification

### MockDeckRepository
Mock du `DeckRepository` pour tester les interactions avec les decks sans dépendance à la base de données.

**Fonctionnalités:**
- Simulation de récupération de tous les decks
- Simulation de récupération des cartes d'un deck
- Simulation d'ajout/suppression de cartes
- Simulation de recherche de decks contenant une carte
- Gestion des erreurs simulées
- Comptage des appels pour vérification

### TestDataFactory
Factory pour créer des données de test réutilisables.

**Méthodes disponibles:**
- `createCard()`: Crée une carte de test avec des valeurs personnalisables
- `createDeck()`: Crée un deck de test
- `createDeckCard()`: Crée une carte de deck
- `createCards(count:)`: Crée plusieurs cartes uniques
- `createDecks(count:)`: Crée plusieurs decks uniques

## Conventions de Test

### Nommage
Les tests suivent la convention **Given-When-Then**:
```swift
func testMethodName_WithSpecificCondition_ShouldExpectedBehavior() {
    // Given - Configuration initiale
    // When - Action à tester
    // Then - Vérifications
}
```

### Organisation
Chaque fichier de test est organisé avec des `MARK:` pour regrouper les tests par catégorie:
- Tests de succès
- Tests de gestion d'erreur
- Tests de l'état initial
- Tests de délégation
- etc.

### Assertions
Les tests utilisent des messages descriptifs pour faciliter le débogage:
```swift
XCTAssertEqual(result, expected, "Message descriptif du test")
```

## Exécution des Tests

### Depuis Xcode
1. Ouvrir le projet dans Xcode
2. Sélectionner le schéma de test
3. Appuyer sur `Cmd + U` pour exécuter tous les tests
4. Ou cliquer sur le diamant à côté d'un test spécifique

### En ligne de commande
```bash
xcodebuild test -scheme "MTG Helper" -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

## Bonnes Pratiques

1. **Isolation**: Chaque test est indépendant et peut être exécuté seul
2. **Rapidité**: Les tests n'effectuent aucun appel réseau ou I/O réel
3. **Clarté**: Les noms de tests décrivent clairement ce qui est testé
4. **Maintenabilité**: Utilisation de factories pour éviter la duplication de code
5. **Couverture**: Tests des cas nominaux ET des cas d'erreur

## Ajout de Nouveaux Tests

Pour ajouter de nouveaux tests:

1. Créer un nouveau fichier dans le dossier approprié (`ViewModels/` ou `UseCases/`)
2. Importer `XCTest` et `@testable import MTG_Helper`
3. Créer une classe héritant de `XCTestCase`
4. Implémenter `setUp()` et `tearDown()` pour la configuration
5. Écrire les tests en suivant les conventions établies
6. Utiliser `TestDataFactory` pour créer les données de test

### Exemple de Structure
```swift
import XCTest
@testable import MTG_Helper

final class MyComponentTests: XCTestCase {
    private var sut: MyComponent!
    private var mockDependency: MockDependency!
    
    override func setUp() {
        mockDependency = MockDependency()
        sut = MyComponent(dependency: mockDependency)
    }
    
    override func tearDown() {
        sut = nil
        mockDependency = nil
    }
    
    // MARK: - Tests
    
    func testMyMethod_WithValidInput_ShouldSucceed() async {
        // Given
        // When
        // Then
    }
}
```

## Notes Importantes

- Les tests sont exécutés sur le **main actor** pour les ViewModels (annotation `@MainActor`)
- Les mocks enregistrent tous les appels pour permettre les vérifications
- Utiliser `async/await` pour les tests asynchrones
- Les erreurs sont testées avec des blocs `do-catch`
