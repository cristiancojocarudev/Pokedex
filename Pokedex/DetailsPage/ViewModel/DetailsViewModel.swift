//
//  DetailsViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 07/02/24.
//

import Foundation

class DetailsViewModel: ObservableObject {
    var pokemonDetails: PokemonDetails
    
    init(pokemonDetails: PokemonDetails) {
        self.pokemonDetails = pokemonDetails
    }
}
