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
    var maxPage: Int = 0
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    
    @Published var pokemonItems: [PokemonItem] = []
    var pokedex: [PokemonReference: PokemonDetails] = [:]
    var pokemons: [PokemonReference] = []
    var filteredPokemons: [PokemonReference] = []
    var paginatedPokemons: [PokemonReference] = []
    
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
    
    func populateFilteredPokemons() -> [PokemonReference] {
        if searchText.isEmpty {
            return pokemons
        }
        let filtered = pokemons.filter() {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        return filtered
    }
    
    func populatePagedPokemons() -> [PokemonReference] {
        return pagePokemons(pokemons: filteredPokemons)
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
    
    func populatePokemonItems() {
        self.isLoading = true
        fetchPokemonItem(index: 0, loadingId: nil, pokemonItemsBuffer: [])
    }
    
    func computePokemonsFilteringAndPaging() {
        filteredPokemons = populateFilteredPokemons()
        paginatedPokemons = populatePagedPokemons()
        maxPage = computeMaxPage()
        canGoBack = computeCanGoBack()
        canGoForward = computeCanGoForward()
    }
    
    func fetchPokemonItem(index: Int, loadingId: Int?, pokemonItemsBuffer: [PokemonItem]) {
        loadingQueue.async {
            self.loadingSemaphore.wait()
            var loadingId = loadingId
            if loadingId == nil {
                self.loadingId += 1
                self.computePokemonsFilteringAndPaging()
                loadingId = self.loadingId
            }
            if loadingId! < self.loadingId {
                self.loadingSemaphore.signal()
                return
            }
            var pokemonItemsBuffer = pokemonItemsBuffer
            if index >= self.paginatedPokemons.count {
                DispatchQueue.main.async {
                    self.loadingSemaphore.signal()
                    self.pokemonItems = pokemonItemsBuffer
                    self.isLoading = false
                }
                return
            }
            let reference = self.paginatedPokemons[index]
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
