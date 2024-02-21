//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    var loadingId = 0
    let serialPokemonItemsLoadingQueue = DispatchQueue(label: "serialPokemonItemsLoadingQueue")
    let concurrentPokemonItemsLoadingQueue = DispatchQueue(label: "concurrentPokemonItemsLoadingQueue", attributes: .concurrent)
    
    var page = -1
    var pageLimit = 20
    var maxPage: Int = -1
    var canGoForward: Bool = true
    
    @Published var pokemonItems: [PokemonItem] = []
    var pokedex: [PokemonReference: PokemonDetails] = [:]
    var pokemons: [PokemonReference] = []
    
    @Published var isDetailsPagePresented = false
    var detailsViewModel: DetailsViewModel?
    
    func navigateToDetailsPage(pokemonItem: PokemonItem) {
        detailsViewModel = DetailsViewModel(pokemonDetails: pokemonItem.details!)
        isDetailsPagePresented = true
    }
    
    func filterPokemons(searchText: String) -> [PokemonReference] {
        if searchText.isEmpty {
            return pokemons
        }
        let filtered = pokemons.filter() {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        return filtered
    }
    func pagePokemons(page: Int, pokemons: [PokemonReference]) -> [PokemonReference] {
        let minIndex = page * pageLimit
        let maxIndex = minIndex + pageLimit - 1
        var paged = [PokemonReference]()
        for i in minIndex...maxIndex {
            if i <= pokemons.count - 1 {
                paged.append(pokemons[i])
            }
        }
        return paged
    }
    
    func loadMoreData() {
        if pokemons.isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                let fetchable = PokemonsReferencesFetchable()
                DefaultNetworkService().fetchDataSerially(fetchable: fetchable, items: [PokemonReference]()) { result in
                    switch result {
                    case .success(let pokemons):
                        self.serialPokemonItemsLoadingQueue.async {
                            self.pokemons = pokemons
                            self.page += 1
                            self.populatePokemonItems(searchText: "", page: 0, loadingId: self.loadingId)
                        }
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
            }
        } else if canGoForward {
            serialPokemonItemsLoadingQueue.async {
                self.loadingId += 1
                self.page += 1
                self.populatePokemonItems(searchText: self.searchText, page: self.page, loadingId: self.loadingId)
            }
        }
    }
    
    func populatePokemonItems(searchText: String, page: Int, loadingId: Int) {
        let filteredPokemons = self.filterPokemons(searchText: searchText)
        let filteredAndPaginatedPokemons = self.pagePokemons(page: page, pokemons: filteredPokemons)
        var pokemonItems: [PokemonItem] = []
        for pokemon in filteredAndPaginatedPokemons {
            pokemonItems.append(PokemonItem(reference: pokemon, details: nil))
        }
        let pokemonItemsLoadingDispatchGroup = DispatchGroup()
        for _ in 0..<pokemonItems.count {
            pokemonItemsLoadingDispatchGroup.enter()
        }
        pokemonItemsLoadingDispatchGroup.notify(queue: .main) {
            if loadingId < self.loadingId {
                return
            }
            if page == 0 {
                self.pokemonItems = pokemonItems
            } else {
                self.pokemonItems.append(contentsOf: pokemonItems)
            }
            self.maxPage = self.computeMaxPage(filteredPokemons: filteredPokemons)
            self.canGoForward = self.computeCanGoForward(page: page)
        }
        for i in 0..<pokemonItems.count {
            self.fetchPokemonDetails(pokemon: pokemonItems[i].reference) { details in
                self.serialPokemonItemsLoadingQueue.async {
                    pokemonItems[i].details = details
                    pokemonItemsLoadingDispatchGroup.leave()
                }
            }
        }
    }
    
    func fetchPokemonDetails(pokemon: PokemonReference, onCompletion: @escaping (PokemonDetails) -> Void) {
        concurrentPokemonItemsLoadingQueue.async {
            if let details = self.pokedex[pokemon] {
                onCompletion(details)
            } else {
                let fetchable = PokemonDetailsFetchable(pokemonName: pokemon.name)
                DefaultNetworkService().fetchData(dataFetchable: fetchable) { result in
                    switch result {
                    case .success(let details):
                        onCompletion(details)
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
            }
        }
    }
    
    func onSearchTextChanged(newValue: String) {
        serialPokemonItemsLoadingQueue.async {
            self.loadingId += 1
            self.populatePokemonItems(searchText: newValue, page: 0, loadingId: self.loadingId)
        }
    }
    
    func computeCanGoForward(page: Int) -> Bool {
        return page < maxPage
    }
    
    func computeMaxPage(filteredPokemons: [PokemonReference]) -> Int {
        Int((Double(filteredPokemons.count) / Double(pageLimit)).rounded(.up)) - 1
    }
}
