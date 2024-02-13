//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    @Published var isLoading = false
    var loadingId = 0
    let loadingQueue = DispatchQueue(label: "loadingQueue")
    let loadingSemaphore = DispatchSemaphore(value: 1)
    
    var page = -1
    var pageLimit = 20
    var maxPage: Int = -1
    var canGoBack: Bool = false
    var canGoForward: Bool = false
    
    @Published var pokemonItems: [PokemonItem] = []
    var pokedex: [PokemonReference: PokemonDetails] = [:]
    var pokemons: [PokemonReference] = []
    
    @Published var isDetailsPagePresented = false
    var detailsViewModel: DetailsViewModel?
    
    func navigateToDetailsPage(pokemonItem: PokemonItem) {
        detailsViewModel = DetailsViewModel(pokemonDetails: pokemonItem.details)
        isDetailsPagePresented = true
    }
    
    init() {
        loadData()
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
    
    func loadData() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            HomeNetwork.shared.fetchPokemonsReferences(url: HomeNetwork.URLs.pokemonsReferences.rawValue, items: []) { pokemons in
                if let pokemons = pokemons {
                    DispatchQueue.main.async {
                        self.pokemons = pokemons
                        self.isLoading = false
                        //self.populatePokemonItems()
                    }
                }
            }
        }
    }
    
    func loadMoreData() {
        populatePokemonItems(page: page + 1)
    }
    
    func populatePokemonItems(page: Int = 0) {
        //self.isLoading = true
        fetchPokemonItem(page: page, index: 0)
    }
    
    func computePokemonsFilteringAndPaging(page: Int) -> [PokemonReference] {
        let filteredPokemons = filterPokemons(searchText: searchText)
        let filteredAndPaginatedPokemons = pagePokemons(page: page, pokemons: filterPokemons(searchText: searchText))
        maxPage = computeMaxPage(filteredPokemons: filteredPokemons)
        canGoBack = computeCanGoBack(page: page)
        canGoForward = computeCanGoForward(page: page)
        return filteredAndPaginatedPokemons
    }
    
    func fetchPokemonItem(page: Int, index: Int, loadingId: Int? = nil, pokemonItemsBuffer: [PokemonItem] = [], filteredAndpaginatedPokemons: [PokemonReference] = []) {
        loadingQueue.async {
            self.loadingSemaphore.wait()
            var loadingId = loadingId
            var filteredAndpaginatedPokemons = filteredAndpaginatedPokemons
            if let loadingId = loadingId {
                if loadingId < self.loadingId {
                    self.loadingSemaphore.signal()
                    return
                }
            } else {
                self.loadingId += 1
                filteredAndpaginatedPokemons = self.computePokemonsFilteringAndPaging(page: page)
                loadingId = self.loadingId
                if loadingId! < self.loadingId {
                    self.loadingSemaphore.signal()
                    return
                }
                DispatchQueue.main.async {
                    self.page = page
                }
            }
            var pokemonItemsBuffer = pokemonItemsBuffer
            if index >= filteredAndpaginatedPokemons.count {
                DispatchQueue.main.async {
                    self.loadingSemaphore.signal()
                    self.pokemonItems.append(contentsOf: pokemonItemsBuffer)
                    self.isLoading = false
                }
                return
            }
            let reference = filteredAndpaginatedPokemons[index]
            if let details = self.pokedex[reference] {
                pokemonItemsBuffer.append(PokemonItem(reference: reference, details: details))
                self.loadingSemaphore.signal()
                self.fetchPokemonItem(page: page, index: index + 1, loadingId: loadingId, pokemonItemsBuffer: pokemonItemsBuffer, filteredAndpaginatedPokemons: filteredAndpaginatedPokemons)
            } else {
                HomeNetwork.shared.fetchPokemonDetails(pokemonName: reference.name) { details in
                    if let details = details {
                        pokemonItemsBuffer.append(PokemonItem(reference: reference, details: details))
                        self.pokedex[reference] = details
                        self.loadingSemaphore.signal()
                        self.fetchPokemonItem(page: page, index: index + 1, loadingId: loadingId, pokemonItemsBuffer: pokemonItemsBuffer, filteredAndpaginatedPokemons: filteredAndpaginatedPokemons)
                    }
                }
            }
        }
    }
    
    func onSearchTextChanged() {
        populatePokemonItems(page: 0)
    }
    
    func computeCanGoBack(page: Int) -> Bool {
        return page > 0
    }
    
    func computeCanGoForward(page: Int) -> Bool {
        return page < maxPage
    }
    
    func computeMaxPage(filteredPokemons: [PokemonReference]) -> Int {
        Int((Double(filteredPokemons.count) / Double(pageLimit)).rounded(.up)) - 1
    }
    
    func goBack() {
        populatePokemonItems(page: page - 1)
    }
    
    func goForward() {
        populatePokemonItems(page: page + 1)
    }
}
