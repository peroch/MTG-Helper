//
//  SearchCoordinator.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 15/09/2025.
//

import SwiftUI

final class SearchCoordinator: ObservableObject {
    private let repository: CardRepository
    
    enum Destination: Hashable {
        case cardSearch(query: String)
        case cardDetail(id: String)
    }
    
    init(repository: CardRepository) {
        self.repository = repository
    }
    
    func makeView() -> some View {
        SearchCoordinatorView(repository: repository)
    }
}

struct SearchCoordinatorView: View {
    @State private var path = NavigationPath()
    private let repository: CardRepository
    
    init(repository: CardRepository) {
        self.repository = repository
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            SearchAndFilterView(onSearch: { searchEntry in
                path.append(SearchCoordinator.Destination.cardSearch(query: searchEntry))
            })
            .navigationDestination(for: SearchCoordinator.Destination.self) { destination in
                switch destination {
                case .cardSearch(let query):
                    let vm = CardSearchViewModel(searchCards: SearchCardsUseCase(repository: repository))
                    CardSearchView(viewModel: vm, onClick: { id in
                        path.append(SearchCoordinator.Destination.cardDetail(id: id))
                    }, initialQuery: query)
                case .cardDetail(let id):
                    let vm = CardDetailViewModel(getCardDetail: GetCardDetailUseCase(repository: repository))
                    CardDetailView(viewModel: vm, cardId: id)
                }
            }
        }
    }
    
    }

