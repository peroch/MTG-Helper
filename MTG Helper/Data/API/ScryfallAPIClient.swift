//
//  ScryfallAPIClient.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// Protocol définissant les opérations API pour l'accès aux données Scryfall.
protocol ScryfallAPI {
    /// Recherche des cartes via l'API Scryfall.
    /// - Parameter query: Texte de recherche pour filtrer les cartes
    /// - Returns: Tableau de cartes correspondant aux critères de recherche
    /// - Throws: Une erreur si la requête échoue
    func searchCards(query: String) async throws -> [Card]
    
    /// Récupère les détails d'une carte via l'API Scryfall.
    /// - Parameter id: Identifiant unique de la carte
    /// - Returns: La carte correspondante avec tous ses détails
    /// - Throws: Une erreur si la requête échoue
    func getCardDetails(id: String) async throws -> Card
    
    /// Récupère les rulings d'une carte via l'API Scryfall.
    /// - Parameter id: Identifiant unique de la carte
    /// - Returns: Tableau des commentaires de rulings
    /// - Throws: Une erreur si la requête échoue
    func getRulings(id: String) async throws -> [String]
}

/// Client API pour les requêtes vers l'API Scryfall.
/// Gère les appels réseau, la désérialisation JSON et le mapping vers les entités domain.
final class ScryfallAPIClient: ScryfallAPI {
    private let baseURL = "https://api.scryfall.com"
    
    /// Erreurs potentielles lors des appels API.
    enum APIError: Error, LocalizedError {
        case invalidURL
        case http(status: Int)
        case missingData
        
        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid URL"
            case .http(let status): return "Request failed with status code \(status)"
            case .missingData: return "Missing data in response"
            }
        }
    }
    
    /// Recherche des cartes via l'endpoint de recherche Scryfall.
    /// - Parameter query: Texte de recherche pour filtrer les cartes
    /// - Returns: Tableau de cartes correspondant aux critères de recherche
    /// - Throws: APIError si l'URL est invalide, si le statut HTTP est incorrect, ou si le parsing échoue
    func searchCards(query: String) async throws -> [Card] {
        var components = URLComponents(string: "\(baseURL)/cards/search")
        components?.queryItems = [URLQueryItem(name: "q", value: query)]
        guard let url = components?.url else { throw APIError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.http(status: http.statusCode)
        }
        let dto = try JSONDecoder().decode(CardSearchResponseDTO.self, from: data)
        return dto.data.map { CardMapper.map($0) }
    }
    
    /// Récupère les détails complets d'une carte via son identifiant.
    /// - Parameter id: Identifiant unique de la carte
    /// - Returns: La carte correspondante avec tous ses détails
    /// - Throws: APIError si l'URL est invalide, si le statut HTTP est incorrect, ou si le parsing échoue
    func getCardDetails(id: String) async throws -> Card {
        guard let url = URL(string: "\(baseURL)/cards/\(id)") else { throw APIError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.http(status: http.statusCode)
        }
        let dto = try JSONDecoder().decode(CardDTO.self, from: data)
        
        // Récupère les rulings pour cette carte
        let rulings = (try? await getRulings(id: id)) ?? []
        
        return CardMapper.map(dto, rulings: rulings)
    }
    
    /// Récupère les rulings d'une carte via l'endpoint rulings de Scryfall.
    /// - Parameter id: Identifiant unique de la carte
    /// - Returns: Tableau des commentaires de rulings
    /// - Throws: APIError si l'URL est invalide, si le statut HTTP est incorrect, ou si le parsing échoue
    func getRulings(id: String) async throws -> [String] {
        guard let url = URL(string: "\(baseURL)/cards/\(id)/rulings") else { throw APIError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.http(status: http.statusCode)
        }
        let dto = try JSONDecoder().decode(CardRulingsResponseDTO.self, from: data)
        return dto.data.map { $0.comment }
    }
}
