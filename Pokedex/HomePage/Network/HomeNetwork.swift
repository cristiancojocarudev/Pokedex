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
    
    func fetchPokemonsReferences(url: String, items: [PokemonReference], completion: @escaping ([PokemonReference]?) -> Void) {
        guard let url = URL(string: url) else {
            fatalError("Cannot build URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let reponse = response as? HTTPURLResponse, (200...299).contains(reponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                completion(nil)
                return
            }
            if let data = data {
                do {
                    let pokemonsReferences = try JSONDecoder().decode(PokemonsList.self, from: data)
                    var items = items
                    for reference in pokemonsReferences.results {
                        items.append(reference)
                    }
                    if let next = pokemonsReferences.next {
                        self.fetchPokemonsReferences(url: next, items: items) { items in
                            completion(items)
                        }
                    } else {
                        completion(items)
                    }
                } catch {
                    print("JSON Conversion error \(error) \(url)")
                    completion(nil)
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchPokemonDetails(pokemonName: String, completion: @escaping (PokemonDetails?) -> Void) {
        let url = URLs.pokemonDetails.rawValue + pokemonName
        guard let url = URL(string: url) else {
            fatalError("Cannot build URL")
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let reponse = response as? HTTPURLResponse, (200...299).contains(reponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                completion(nil)
                return
            }
            if let data = data {
                do {
                    let pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
                    completion(pokemonDetails)
                } catch {
                    print("JSON Conversion error \(error) \(url)")
                    completion(nil)
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
