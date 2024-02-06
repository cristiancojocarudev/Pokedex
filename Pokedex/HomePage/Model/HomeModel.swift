//
//  Model.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

struct PokemonsReferences: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonReference]
}

struct PokemonReference: Decodable, Hashable {
    var name: String
    var url: String
}
