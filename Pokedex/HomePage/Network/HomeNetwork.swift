//
//  Network.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

struct PokemonsReferencesFetchable: DataFetchable {
    typealias Response = PokemonsList
    
    var url: String = "https://pokeapi.co/api/v2/pokemon"
    
    var method: HTTPMethod = .get
}

struct PokemonDetailsFetchable: DataFetchable {
    typealias Response = PokemonDetails
    
    let baseUrl: String = "https://pokeapi.co/api/v2/pokemon/"
    var url: String
    
    var method: HTTPMethod = .get
    
    init(pokemonName: String) {
        self.url = baseUrl + pokemonName
    }
}
