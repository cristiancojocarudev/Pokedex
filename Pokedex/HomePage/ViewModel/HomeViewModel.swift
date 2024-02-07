//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

typealias PokemonItem = (reference: PokemonReference, details: PokemonDetails)

class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
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
    
    @Published var pokemons: [PokemonReference] = []
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
    /*var filteredAndPaginatedAndDetailedPokemons: [PokemonItem] {
        get {
            let references = filteredAndPaginatedPokemons
            var result = [PokemonItem]()
            for reference in references {
                if let details = pokedex[reference] {
                    result.append(PokemonItem(reference: reference, details: details))
                } else {
                    if let pokemonId = reference.id {
                        Task {
                            let details = try await HomeNetwork.shared.fetchPokemonDetails(pokemonId: pokemonId)
                            result.append(PokemonItem(reference: reference, details: details))
                        }
                    }
                }
            }
        }
    }*/
    
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
        Task {
            let fetchedPokemons = try await HomeNetwork.shared.fetchPokemonsReferences(url: HomeNetwork.URLs.pokemonsReferences.rawValue, items: [])
            pokemons = pokemonsWithId(pokemons: fetchedPokemons)
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
