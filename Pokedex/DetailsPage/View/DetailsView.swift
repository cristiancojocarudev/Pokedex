//
//  DetailsView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 07/02/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailsView: View {
    @ObservedObject var detailsViewModel: DetailsViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            
            GeometryReader { geo in
                VStack {
                    ScrollView {
                        VStack {}
                            .frame(height: geo.size.height * 0.25)
                        
                        DetailsImagesView(geo: geo, imagesGallery: detailsViewModel.imagesGallery)
                        
                        DetailsDivider(geo: geo)
                        
                        DetailsMainStatsView(geo: geo, mainStatsTable: detailsViewModel.mainStatsTable)
                        
                        DetailsDivider(geo: geo)
                        
                        DetailsSpecieView(geo: geo, specie: detailsViewModel.pokemonDetails.species.name)
                        
                        DetailsDivider(geo: geo)
                        
                        DetailsMovesView(geo: geo, moves: detailsViewModel.pokemonDetails.moves)
                        
                        DetailsDivider(geo: geo)
                        
                        DetailsAbilitiesView(geo: geo, abilities: detailsViewModel.pokemonDetails.abilities)
                        
                        DetailsDivider(geo: geo)
                        
                        DetailsFormsView(geo: geo, forms: detailsViewModel.pokemonDetails.forms)
                        
                        DetailsDivider(geo: geo)
                        
                        DetailsGamesView(geo: geo, coloredGameIndices: detailsViewModel.getColoredGameIndices())
                        
                        DetailsDivider(geo: geo)
                        
                        DetailsTypesView(geo: geo, types: detailsViewModel.pokemonDetails.types)
                        
                        VStack {}
                            .frame(height: geo.size.height * 0.1)
                    }
                }
                .ignoresSafeArea()
            }
            
            GeometryReader { geo in
                DetailsHeaderView(geo: geo, details: detailsViewModel.pokemonDetails)
            }
            
            GeometryReader { geo in
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.black)
                                .frame(width: geo.size.width * 0.07, height: geo.size.width * 0.07)
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.03, height: geo.size.width * 0.03)
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
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
            let forms: [Form] = [Form(name: "bulbasaur"), Form(name: "bulbasaur2"), Form(name: "bulbasaur3")]
            var game_indices: [GameIndex] = []
            for _ in 0...85 {
                game_indices.append(GameIndex(version: Game(name: "green")))
            }
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
            let sprites: SpritesWrapper = SpritesWrapper(back_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png", front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png", other: OtherSpritesWrapper(dream_world: FrontSprite(front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg"), home: FrontSprite(front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png"), showdown: FrontAndBackSprite(front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/1.gif", back_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/back/1.gif")))
            let weight: Int = 69
            return PokemonDetails(abilities: abilities, base_experience: base_experience, forms: forms, game_indices: game_indices, height: height, moves: moves, name: name, species: specie, stats: stats, types: types, weight: weight, sprites: sprites)
        }
    }
    
    static var previews: some View {
        DetailsView(detailsViewModel: DetailsViewModel(pokemonDetails: pokemonDetails))
    }
}
