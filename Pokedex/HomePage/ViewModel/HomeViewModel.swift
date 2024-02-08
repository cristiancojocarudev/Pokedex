//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    @Published var isDetailsShown = false
    
    let pageLimit = 20
    @Published var page = 0
    var canGoBack: Bool {
        get {
            page > 0
        }
    }
    var canGoForward: Bool {
        get {
            (page + 1) * pageLimit < filteredPokemons.count
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
    
    var pokemonItemsBuffer: [PokemonItem] = []
    @Published var pokemonItems: [PokemonItem] = []
    
    func populatePokemonItems() {
        pokemonItemsBuffer = []
        fetchPokemonItem(index: 0)
    }
    
    func fetchPokemonItem(index: Int) {
        if index >= pageLimit {
            DispatchQueue.main.async {
                self.pokemonItems = self.pokemonItemsBuffer
            }
            return
        }
        let reference = filteredAndPaginatedPokemons[index]
        if let details = pokedex[reference] {
            pokemonItemsBuffer.append(PokemonItem(reference: reference, details: details))
            fetchPokemonItem(index: index + 1)
        } else {
            if let pokemonId = reference.id {
                HomeNetwork.shared.fetchPokemonDetails(pokemonId: pokemonId) { details in
                    if let details = details {
                        self.pokemonItemsBuffer.append(PokemonItem(reference: reference, details: details))
                        self.fetchPokemonItem(index: index + 1)
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
                    self.pokemons = self.pokemonsWithId(pokemons: pokemons)
                    self.populatePokemonItems()
                }
            }
        }
    }
    
    func pokemonsWithId(pokemons: [PokemonReference]) -> [PokemonReference] {
        var pokemons = pokemons
        for i in 0..<pokemons.count {
            pokemons[i].id = i + 1
        }
        return pokemons
    }
    
    func goBack() {
        page -= 1
    }
    
    func goForward() {
        page += 1
    }
}
