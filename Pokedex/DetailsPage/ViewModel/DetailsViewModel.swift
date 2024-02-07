//
//  DetailsViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 07/02/24.
//

import Foundation

struct PokeStat: Hashable {
    var name: String
    var value: Int
}

class DetailsViewModel: ObservableObject {
    var pokemonDetails: PokemonDetails
    
    var mainStatsTable: [[PokeStat]] = []
    
    init(pokemonDetails: PokemonDetails) {
        self.pokemonDetails = pokemonDetails
        populateMainStatsTable()
    }
    
    private func populateMainStatsTable() {
        let rowLength = 3
        mainStatsTable.append([
            PokeStat(name: "height", value: pokemonDetails.height),
            PokeStat(name: "weight", value: pokemonDetails.weight),
            PokeStat(name: "base experience", value: pokemonDetails.base_experience)
        ])
        var rowBuffer: [PokeStat] = []
        for stat in pokemonDetails.stats {
            let value = stat.base_stat
            let name = stat.stat.name
            let pokeStat = PokeStat(name: name, value: value)
            rowBuffer.append(pokeStat)
            if rowBuffer.count == rowLength {
                mainStatsTable.append(rowBuffer)
                rowBuffer = []
            }
        }
    }
}
