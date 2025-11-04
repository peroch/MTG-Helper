//
//  CardMarketAPIClient.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// API client for CardMarket interactions
/// Note: This is a mock implementation. Real CardMarket API requires OAuth 1.0 authentication
/// To use the real API, you need to:
/// 1. Create an app at https://www.cardmarket.com/en/Magic/Account/API
/// 2. Get your App Token, App Secret, Access Token, and Access Token Secret
/// 3. Implement OAuth 1.0 signature generation
class CardMarketAPIClient {
    private let baseURL = "https://api.cardmarket.com/ws/v2.0"
    private let session: URLSession
    
    // OAuth credentials (to be configured by the user)
    private var appToken: String?
    private var appSecret: String?
    private var accessToken: String?
    private var accessTokenSecret: String?
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Configure OAuth credentials
    /// - Parameters:
    ///   - appToken: Your App Token from CardMarket
    ///   - appSecret: Your App Secret from CardMarket
    ///   - accessToken: Your Access Token from CardMarket
    ///   - accessTokenSecret: Your Access Token Secret from CardMarket
    func configure(
        appToken: String,
        appSecret: String,
        accessToken: String,
        accessTokenSecret: String
    ) {
        self.appToken = appToken
        self.appSecret = appSecret
        self.accessToken = accessToken
        self.accessTokenSecret = accessTokenSecret
    }
    
    /// Searches for products by name
    /// - Parameter query: Search term
    /// - Returns: Search response DTO
    func searchProducts(query: String) async throws -> CardMarketSearchResponseDTO {
        // Mock implementation - returns empty results
        // TODO: Implement real API call with OAuth authentication
        return CardMarketSearchResponseDTO(product: [])
    }
    
    /// Fetches a specific product by ID
    /// - Parameter productId: The product ID
    /// - Returns: Product DTO
    func getProduct(id productId: Int) async throws -> CardMarketProductDTO {
        // Mock implementation
        // TODO: Implement real API call with OAuth authentication
        throw CardMarketError.notImplemented
    }
    
    /// Fetches articles (sellers) for a product
    /// - Parameter productId: The product ID
    /// - Returns: Array of articles
    func getArticles(for productId: Int) async throws -> [CardMarketArticleDTO] {
        // Mock implementation
        // TODO: Implement real API call with OAuth authentication
        return []
    }
}

/// Errors that can occur when interacting with CardMarket API
enum CardMarketError: LocalizedError {
    case notImplemented
    case authenticationRequired
    case invalidResponse
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "CardMarket API not yet implemented. OAuth credentials required."
        case .authenticationRequired:
            return "CardMarket API requires OAuth authentication"
        case .invalidResponse:
            return "Invalid response from CardMarket API"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

/// DTO for CardMarket article (seller offer)
struct CardMarketArticleDTO: Codable {
    let idArticle: Int
    let seller: Seller
    let price: Double
    let condition: String?
    let language: Language?
    
    struct Seller: Codable {
        let username: String
        let reputation: Int?
    }
    
    struct Language: Codable {
        let idLanguage: Int
        let languageName: String
    }
}
