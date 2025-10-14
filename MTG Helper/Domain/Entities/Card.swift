//
//  Card.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

struct Card: Identifiable {
    var id: String
    var name: String
    var oracleText: String?
    var imageUrl: String?
}

protocol CardRepository {
    func search(query: String) async throws -> [Card]
    func getDetail(id: String) async throws -> Card
}

struct SearchCardsUseCase {
    private let repository: CardRepository
    
    init(repository: CardRepository) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [Card] {
        try await repository.search(query: query)
    }
}

struct GetCardDetailUseCase {
    private let repository: CardRepository
    
    init(repository: CardRepository) {
        self.repository = repository
    }
    
    func execute(id: String) async throws -> Card {
        try await repository.getDetail(id: id)
    }
}
