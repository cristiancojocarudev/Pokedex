//
//  DetailsView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 07/02/24.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var detailsViewModel: DetailsViewModel
    
    var body: some View {
        Text(detailsViewModel.pokemonDetails.name)
    }
}

struct DetailsView_Preview: PreviewProvider {
    static var pokemonDetails: PokemonDetails{
        get {
            let abilities: [AbilityWrapper] = [
                AbilityWrapper(ability: Ability(name: "overgrow")),
                AbilityWrapper(ability: Ability(name: "chlorophyll"))
            ]
            let base_experience: Int = 64
            let forms: [Form] = [Form(name: "bulbasaur")]
            let game_indices: [GameIndex] = [
                GameIndex(version: Game(name: "red")),
                GameIndex(version: Game(name: "blue")),
                GameIndex(version: Game(name: "heartgold"))
            ]
            let height: Int = 7
            var moves: [MoveWrapper] = []
            for _ in 0...85 {
                moves.append(MoveWrapper(move: Move(name: "razor-wind")))
            }
            let name: String = "bulbasaur"
            let specie: Specie = Specie(name: "bulbasaur")
            let stats: [StatWrapper] = [
                StatWrapper(base_stat: 45, effort: 0, stat: Stat(name: "hp")),
                StatWrapper(base_stat: 40, effort: 0, stat: Stat(name: "attack")),
                StatWrapper(base_stat: 49, effort: 0, stat: Stat(name: "defense")),
                StatWrapper(base_stat: 65, effort: 1, stat: Stat(name: "special-attack")),
                StatWrapper(base_stat: 65, effort: 0, stat: Stat(name: "special-defense")),
                StatWrapper(base_stat: 45, effort: 0, stat: Stat(name: "speed"))
            ]
            let types: [PokeTypeWrapper] = [
                PokeTypeWrapper(type: PokeType(name: "grass")),
                PokeTypeWrapper(type: PokeType(name: "poison"))
            ]
            let sprites: SpritesWrapper = SpritesWrapper(back_default: "https://raw.githubuserco…rites/pokemon/back/1.png", front_default: "https://raw.githubuserco…er/sprites/pokemon/1.png", other: OtherSpritesWrapper(dream_world: FrontSprite(front_default: "https://raw.githubuserco…/other/dream-world/1.svg"), home: FrontSprite(front_default: "https://raw.githubuserco…pokemon/other/home/1.png"), showdown: FrontAndBackSprite(front_default: "https://raw.githubuserco…mon/other/showdown/1.gif", back_default: "https://raw.githubuserco…ther/showdown/back/1.gif")))
            let weight: Int = 69
            return PokemonDetails(abilities: abilities, base_experience: base_experience, forms: forms, game_indices: game_indices, height: height, moves: moves, name: name, species: specie, stats: stats, types: types, weight: weight, sprites: sprites)
        }
    }
    
    static var previews: some View {
        DetailsView(detailsViewModel: DetailsViewModel(pokemonDetails: pokemonDetails))
    }
}
