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
    
    @Published var page = 0
    var pageLimit = 20
    var maxPage: Int = -1
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    
    @Published var pokemonItems: [PokemonItem] = []
    var pokedex: [PokemonReference: PokemonDetails] = [:]
    var pokemons: [PokemonReference] = []
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
    var filteredAndpaginatedPokemons: [PokemonReference] {
        get {
            let minIndex = page * pageLimit
            let maxIndex = minIndex + pageLimit - 1
            var paged = [PokemonReference]()
            for i in minIndex...maxIndex {
                if i <= filteredPokemons.count - 1 {
                    paged.append(filteredPokemons[i])
                }
            }
            return paged
        }
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
    
    func populatePokemonItems() {
        self.isLoading = true
        fetchPokemonItem(index: 0)
    }
    
    func computePokemonsFilteringAndPaging() -> [PokemonReference] {
        maxPage = computeMaxPage()
        canGoBack = computeCanGoBack()
        canGoForward = computeCanGoForward()
        return filteredAndpaginatedPokemons
    }
    
    func fetchPokemonItem(index: Int, loadingId: Int? = nil, pokemonItemsBuffer: [PokemonItem] = [], filteredAndpaginatedPokemons: [PokemonReference] = []) {
        loadingQueue.async {
            self.loadingSemaphore.wait()
            var loadingId = loadingId
            var filteredAndpaginatedPokemons = filteredAndpaginatedPokemons
            if loadingId == nil {
                self.loadingId += 1
                filteredAndpaginatedPokemons = self.computePokemonsFilteringAndPaging()
                loadingId = self.loadingId
            }
            if loadingId! < self.loadingId {
                self.loadingSemaphore.signal()
                return
            }
            var pokemonItemsBuffer = pokemonItemsBuffer
            if index >= filteredAndpaginatedPokemons.count {
                DispatchQueue.main.async {
                    self.loadingSemaphore.signal()
                    self.pokemonItems = pokemonItemsBuffer
                    self.isLoading = false
                }
                return
            }
            let reference = filteredAndpaginatedPokemons[index]
            if let details = self.pokedex[reference] {
                pokemonItemsBuffer.append(PokemonItem(reference: reference, details: details))
                self.loadingSemaphore.signal()
                self.fetchPokemonItem(index: index + 1, loadingId: loadingId, pokemonItemsBuffer: pokemonItemsBuffer, filteredAndpaginatedPokemons: filteredAndpaginatedPokemons)
            } else {
                HomeNetwork.shared.fetchPokemonDetails(pokemonName: reference.name) { details in
                    if let details = details {
                        pokemonItemsBuffer.append(PokemonItem(reference: reference, details: details))
                        self.pokedex[reference] = details
                        self.loadingSemaphore.signal()
                        self.fetchPokemonItem(index: index + 1, loadingId: loadingId, pokemonItemsBuffer: pokemonItemsBuffer, filteredAndpaginatedPokemons: filteredAndpaginatedPokemons)
                    }
                }
            }
        }
    }
    
    func onSearchTextChanged() {
        page = 0
        populatePokemonItems()
    }
    
    func computeCanGoBack() -> Bool {
        return page > 0
    }
    
    func computeCanGoForward() -> Bool {
        return page < maxPage
    }
    
    func computeMaxPage() -> Int {
        Int((Double(filteredPokemons.count) / Double(pageLimit)).rounded(.up)) - 1
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
