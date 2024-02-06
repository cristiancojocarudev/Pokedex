//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

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
            pokemons = try await HomeNetwork.shared.fetchPokemonsReferences(url: HomeNetwork.URLs.pokemonsReferences.rawValue, items: [])
        }
    }
    
    func goBack() {
        page -= 1
    }
    
    func goForward() {
        page += 1
    }
}
