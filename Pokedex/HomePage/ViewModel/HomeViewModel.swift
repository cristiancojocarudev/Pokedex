//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    @Published var isLoading = true
    var loadingId = 0
    let loadingQueue = DispatchQueue(label: "loadingQueue")
    let loadingSemaphore = DispatchSemaphore(value: 1)
    
    let pageLimit = 20
    @Published var page = 0
    var maxPage: Int {
        get {
            Int((Double(filteredPokemons.count) / Double(pageLimit)).rounded(.up)) - 1
        }
    }
    var canGoBack: Bool {
        get {
            page > 0
        }
    }
    var canGoForward: Bool {
        get {
            page <= maxPage
        }
    }
    
    var pokemons: [PokemonReference] = []
    var pokedex: [PokemonReference: PokemonDetails] = [:]
    
    var filteredPokemons: [PokemonReference] {
        get {
            if searchText.isEmpty {
                return pokemons
            }
            let filtered = pokemons.filter() {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            return filtered
        }
    }
    var filteredAndPaginatedPokemons: [PokemonReference] {
        get {
            pagePokemons(pokemons: filteredPokemons)
        }
    }

    @Published var pokemonItems: [PokemonItem] = []
    
    func populatePokemonItems() {
        isLoading = true
        loadingId += 1
        fetchPokemonItem(index: 0, loadingId: loadingId, pokemonItemsBuffer: [])
    }
    
    func fetchPokemonItem(index: Int, loadingId: Int, pokemonItemsBuffer: [PokemonItem]) {
        loadingQueue.async {
            self.loadingSemaphore.wait()
            if loadingId < self.loadingId {
                self.loadingSemaphore.signal()
                return
            }
            var pokemonItemsBuffer = pokemonItemsBuffer
            if index >= self.filteredAndPaginatedPokemons.count {
                DispatchQueue.main.async {
                    self.loadingSemaphore.signal()
                    self.pokemonItems = pokemonItemsBuffer
                    self.isLoading = false
                }
                return
            }
            let reference = self.filteredAndPaginatedPokemons[index]
            if let details = self.pokedex[reference] {
                pokemonItemsBuffer.append(PokemonItem(reference: reference, details: details))
                self.loadingSemaphore.signal()
                self.fetchPokemonItem(index: index + 1, loadingId: loadingId, pokemonItemsBuffer: pokemonItemsBuffer)
            } else {
                HomeNetwork.shared.fetchPokemonDetails(pokemonName: reference.name) { details in
                    if let details = details {
                        pokemonItemsBuffer.append(PokemonItem(reference: reference, details: details))
                        self.pokedex[reference] = details
                        self.loadingSemaphore.signal()
                        self.fetchPokemonItem(index: index + 1, loadingId: loadingId, pokemonItemsBuffer: pokemonItemsBuffer)
                    }
                }
            }
        }
    }
    
    func pagePokemons(pokemons: [PokemonReference]) -> [PokemonReference] {
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
    
    func loadData() {
        HomeNetwork.shared.fetchPokemonsReferences(url: HomeNetwork.URLs.pokemonsReferences.rawValue, items: []) { pokemons in
            if let pokemons = pokemons {
                DispatchQueue.main.async {
                    self.pokemons = pokemons
                    self.populatePokemonItems()
                }
            }
        }
    }
    
    func goBack() {
        page -= 1
        populatePokemonItems()
    }
    
    func goForward() {
        page += 1
        populatePokemonItems()
    }
}
