//
//  Network.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

class HomeNetwork {
    static let shared = HomeNetwork()
    
    private init() {}
    
    enum URLs: String {
        case pokemonsReferences = "https://pokeapi.co/api/v2/pokemon"
        case pokemonDetails = "https://pokeapi.co/api/v2/pokemon/"
    }
    
    enum StatusError: Error {
        case error
    }
    
    func fetchPokemonsReferences(url: String, items: [PokemonReference]) async throws -> [PokemonReference] {
        guard let url = URL(string: url) else {
            fatalError("Cannot build URL")
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let reponse = response as? HTTPURLResponse, (200...299).contains(reponse.statusCode) else {
            print("Error with the response, unexpected status code: \(String(describing: response))")
            throw StatusError.error
        }

        let pokemonsReferences = try JSONDecoder().decode(PokemonsReferences.self, from: data)
        var items = items
        for reference in pokemonsReferences.results {
            items.append(reference)
        }
        if let next = pokemonsReferences.next {
            return try await fetchPokemonsReferences(url: next, items: items)
        } else {
            return items
        }
    }
    
    func fetchPokemonDetails(pokemonId: Int) async throws -> PokemonDetails {
        let url = URLs.pokemonDetails.rawValue + String(pokemonId)
        guard let url = URL(string: url) else {
            fatalError("Cannot build URL")
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let reponse = response as? HTTPURLResponse, (200...299).contains(reponse.statusCode) else {
            print("Error with the response, unexpected status code: \(String(describing: response))")
            throw StatusError.error
        }

        let pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
        return pokemonDetails
    }
}
