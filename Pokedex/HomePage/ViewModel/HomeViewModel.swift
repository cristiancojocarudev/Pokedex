//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    @Published var pokemons: [PokemonReference] = []
    var filteredPokemons: [PokemonReference] {
        get {
            if searchText.isEmpty {
                return pokemons
            }
            return pokemons.filter() {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func loadData() {
        Task {
            pokemons = try await HomeNetwork.shared.fetchPokemonsReferences(url: HomeNetwork.URLs.pokemonsReferences.rawValue, items: [])
        }
    }
}
