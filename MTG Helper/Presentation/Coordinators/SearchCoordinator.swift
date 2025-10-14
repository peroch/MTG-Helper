//
//  SearchCoordinator.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 15/09/2025.
//

import SwiftUI

final class SearchCoordinator: ObservableObject {
    @Published var path: [Destination] = []
    private let repository: CardRepository
    
    enum Destination: Hashable {
        case cardSearch(query: String)
        case cardDetail(id: String)
    }
    
    init(repository: CardRepository) {
        self.repository = repository
    }
    
    func makeView() -> some View {
        SearchAndFilterView(onSearch: { searchEntry in
            
        })
    }
    
    }

