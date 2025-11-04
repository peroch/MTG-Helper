# CardMarket Feature

This document describes the CardMarket feature implementation in MTG Helper.

## Overview

The CardMarket feature provides users with pricing information for Magic: The Gathering cards by combining:
- **Scryfall API**: For card data and new spoilers
- **CardMarket API**: For pricing information (currently mock implementation)

## Architecture

The feature follows the MVVMC architecture pattern:

### Domain Layer

#### Entities
- `CardMarketPrice`: Represents price information from CardMarket
- `CardWithPrice`: Combines a Card with its CardMarket price

#### Repositories
- `CardMarketRepository` (protocol): Defines the contract for CardMarket API interactions

#### Use Cases
- `GetNewSpoilersWithPricesUseCase`: Fetches latest spoiled cards with prices
- `SearchCardsWithPricesUseCase`: Searches for cards and fetches their prices

### Data Layer

#### API Client
- `CardMarketAPIClient`: Handles CardMarket API communication
  - **Note**: Currently a mock implementation
  - Requires OAuth 1.0 authentication
  - To use the real API, configure credentials via `configure()` method

#### DTOs
- `CardMarketProductDTO`: Product data from CardMarket API
- `CardMarketSearchResponseDTO`: Search response structure
- `CardMarketArticleDTO`: Seller offer data

#### Repository Implementation
- `CardMarketRepositoryImpl`: Concrete implementation of CardMarketRepository

### Presentation Layer

#### Coordinator
- `CardMarketCoordinator`: Manages navigation and view creation for CardMarket feature

#### ViewModels
- `CardMarketSpoilersViewModel`: Handles spoilers tab logic
- `CardMarketSearchViewModel`: Handles search tab logic

#### Views
- `CardMarketView`: Main view with two tabs (Spoilers and Search)
- `CardWithPriceRowView`: Reusable component displaying a card with its price

## Features

### 1. New Spoilers Tab
- Displays the latest spoiled/newly released cards
- Shows CardMarket prices for each card (lowest price and trend price)
- Pull-to-refresh functionality
- Automatic loading on first view

### 2. Search Tab
- Text search for cards by name
- Displays matching cards with their CardMarket prices
- Search button to trigger the search
- Clear error messaging

## CardMarket API Integration

### Current Status
The CardMarket API integration is currently a **mock implementation**. To enable real API calls:

1. Create an app at https://www.cardmarket.com/en/Magic/Account/API
2. Obtain your OAuth credentials:
   - App Token
   - App Secret
   - Access Token
   - Access Token Secret
3. Configure the API client:
   ```swift
   let apiClient = CardMarketAPIClient()
   apiClient.configure(
       appToken: "YOUR_APP_TOKEN",
       appSecret: "YOUR_APP_SECRET",
       accessToken: "YOUR_ACCESS_TOKEN",
       accessTokenSecret: "YOUR_ACCESS_TOKEN_SECRET"
   )
   ```
4. Implement OAuth 1.0 signature generation in `CardMarketAPIClient`

### API Endpoints Used
- `GET /products` - Search for products by name
- `GET /products/{productId}` - Get specific product details
- `GET /articles/{productId}` - Get available sellers for a product

## File Structure

```
MTG Helper/
├── Domain/
│   ├── Entities/
│   │   ├── CardMarketPrice.swift
│   │   └── CardWithPrice.swift
│   ├── Repositories/
│   │   └── CardMarketRepository.swift
│   └── UseCases/
│       ├── GetNewSpoilersWithPricesUseCase.swift
│       └── SearchCardsWithPricesUseCase.swift
├── Data/
│   ├── API/
│   │   └── CardMarketAPIClient.swift
│   ├── DTOs/
│   │   └── CardMarketProductDTO.swift
│   └── Repositories/
│       └── CardMarketRepositoryImpl.swift
└── Presentation/
    ├── Coordinators/
    │   └── CardMarketCoordinator.swift
    ├── ViewModels/
    │   ├── CardMarketSpoilersViewModel.swift
    │   └── CardMarketSearchViewModel.swift
    └── Views/
        ├── CardMarketView.swift
        └── Components/
            └── CardWithPriceRowView.swift
```

## Usage

The CardMarket tab appears in the main tab bar with a Euro sign icon. Users can:
1. Browse new spoilers with prices on the first tab
2. Search for specific cards and see their prices on the second tab

## Future Enhancements

- Implement real CardMarket API OAuth authentication
- Add filtering options (condition, language, seller type)
- Add sorting options (price, seller rating)
- Cache price data to reduce API calls
- Add price history/trends
- Display multiple sellers with different prices
- Add direct links to CardMarket product pages

## Testing

To test the feature:
1. Navigate to the CardMarket tab in the app
2. The Spoilers tab will attempt to load new cards from Scryfall
3. Use the Search tab to look up specific cards
4. Note: Prices will not display until the real API is implemented

## Dependencies

- Scryfall API (for card data)
- CardMarket API (for pricing - currently mocked)
- SwiftUI (for UI)
- Combine (for reactive programming)
