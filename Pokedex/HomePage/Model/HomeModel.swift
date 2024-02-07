//
//  Model.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

struct PokemonItem: Hashable {
    var reference: PokemonReference
    var details: PokemonDetails
    
    static func == (lhs: PokemonItem, rhs: PokemonItem) -> Bool {
        return lhs.reference.name == rhs.reference.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reference)
    }
}

struct PokemonsReferences: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonReference]
}

struct PokemonReference: Decodable, Hashable {
    var id: Int?
    var name: String
    var url: String
}

struct PokemonDetails: Decodable {
    /*var abilities: [AbilityWrapper]
    var base_experience: Int
    var forms: [Form]
    var game_indices: [GameIndex]
    var height: Int
    var moves: [MoveWrapper]
    var name: String
    var species: Specie
    var sprites: SpritesWrapper
    var stats: [StatWrapper]
    var types: [PokeTypeWrapper]
    var weight: Int*/
}

struct AbilityWrapper: Decodable {
    var ability: Ability
}

struct Ability: Decodable {
    var name: String
}

struct Form: Decodable {
    var name: String
}

struct GameIndex: Decodable {
    var version: Game
}

struct Game: Decodable {
    var name: String
}

struct MoveWrapper: Decodable {
    var move: Move
}

struct Move: Decodable {
    var name: String
}

struct Specie: Decodable {
    var name: String
}

struct SpritesWrapper: Decodable {
    var back_default: String
    var front_default: String
    var other: [OtherSpritesWrapper]
}

struct OtherSpritesWrapper: Decodable {
    var dream_world: FrontSprite
    var home: FrontSprite
    var official_atrwork: FrontSprite
    var showdown: FrontAndBackSprite
}

struct FrontSprite: Decodable {
    var front_default: String
}

struct FrontAndBackSprite: Decodable {
    var front_default: String
    var back_default: String
}

struct StatWrapper: Decodable {
    var base_stat: Int
    var effort: Int
    var stat: Stat
}

struct Stat: Decodable {
    var name: String
}

struct PokeTypeWrapper: Decodable {
    var type: PokeType
}

struct PokeType: Decodable {
    var name: String
}
