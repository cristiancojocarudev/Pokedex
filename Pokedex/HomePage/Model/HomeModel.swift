//
//  Model.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import Foundation

struct PokemonItem: Hashable {
    var reference: PokemonReference
    var details: PokemonDetails?
}

struct PokemonsList: Decodable {
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

struct PokemonDetails: Decodable, Hashable {
    var abilities: [AbilityWrapper]
    var base_experience: Int?
    var forms: [PokeForm]
    var game_indices: [GameIndex]
    var height: Int?
    var moves: [MoveWrapper]
    var name: String
    var species: Specie
    var stats: [StatWrapper]
    var types: [PokeTypeWrapper]
    var weight: Int?
    var sprites: SpritesWrapper
}

struct AbilityWrapper: Decodable, Hashable {
    var ability: Ability
}

struct Ability: Decodable, Hashable {
    var name: String
}

struct PokeForm: Decodable, Hashable {
    var name: String
}

struct GameIndex: Decodable, Hashable {
    var version: Game
}

struct Game: Decodable, Hashable {
    var name: String
}

struct MoveWrapper: Decodable, Hashable {
    var move: Move
}

struct Move: Decodable, Hashable {
    var name: String
}

struct Specie: Decodable, Hashable {
    var name: String?
}

struct SpritesWrapper: Decodable, Hashable {
    var back_default: String?
    var front_default: String?
    var other: OtherSpritesWrapper
}

struct OtherSpritesWrapper: Decodable, Hashable {
    var dream_world: FrontSprite
    var home: FrontSprite
    //var official_artwork: FrontSprite
    var showdown: FrontAndBackSprite
}

struct FrontSprite: Decodable, Hashable {
    var front_default: String?
}

struct FrontAndBackSprite: Decodable, Hashable {
    var front_default: String?
    var back_default: String?
}

struct StatWrapper: Decodable, Hashable {
    var base_stat: Int
    var effort: Int
    var stat: Stat
}

struct Stat: Decodable, Hashable {
    var name: String
}

struct PokeTypeWrapper: Decodable, Hashable {
    var type: PokeType
}

struct PokeType: Decodable, Hashable {
    var name: String
}
