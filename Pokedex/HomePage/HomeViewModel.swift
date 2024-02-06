//
//  ViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var pokemons: [String] = []
    
    func laodData() {
        pokemons = ["Bulbasaur", "Charizard", "Phickachu"]
    }
}
