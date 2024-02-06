//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    var pokemons: [String] = []
    var filteredPokemons: [String] {
        get {
            if searchText.isEmpty {
                return pokemons
            }
            return pokemons.filter() {
                $0.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func laodData() {
        pokemons = ["Bulbasaur", "Charizard", "Phickachu"]
    }
}
