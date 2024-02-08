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
    
    var details: PokemonDetails {
        get {
            detailsViewModel.pokemonDetails
        }
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            
            GeometryReader { geo in
                VStack {
                    ScrollView {
                        VStack {}
                            .frame(height: geo.size.height * 0.25)
                        Text("Images")
                            .font(.title2)
                            .padding()
                            .frame(width: geo.size.width, alignment: .leading)
                        HStack {
                            ForEach(detailsViewModel.imagesGallery, id: \.self) { urlCouple in
                                VStack {
                                    ForEach(urlCouple, id: \.self) { url in
                                        if let url = url {
                                            WebImage(url: url, options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                                                .placeholder {ProgressView()}
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geo.size.width / 4, height: geo.size.height * 0.15)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 36)
                                                        .stroke(.black, lineWidth: 5)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        
                        HStack {}
                            .frame(width: geo.size.width, height: geo.size.height * 0.004)
                            .background(.black)
                            .padding(.vertical)
                        
                        Text("Main Stats")
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.bottom, geo.size.height * 0.01)
                            .frame(width: geo.size.width, alignment: .leading)
                        VStack {
                            ForEach(detailsViewModel.mainStatsTable, id: \.self) { row in
                                HStack {
                                    ForEach(row, id: \.name) { pokeStat in
                                        VStack {
                                            Text(pokeStat.name)
                                            Text(String(pokeStat.value))
                                        }
                                        .frame(width: geo.size.width * 0.22, height: geo.size.width * 0.2 * 1)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        
                        if let specie = details.species.name {
                            HStack {}
                                .frame(width: geo.size.width, height: geo.size.height * 0.004)
                                .background(.black)
                                .padding(.vertical)
                            
                            HStack {
                                Text("Specie:")
                                    .font(.title2)
                                    .padding(.horizontal)
                                Text(specie)
                                Spacer()
                            }
                        }
                        
                        HStack {}
                            .frame(width: geo.size.width, height: geo.size.height * 0.004)
                            .background(.black)
                            .padding(.vertical)
                        
                        Text("Moves")
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.bottom, geo.size.height * 0.01)
                            .frame(width: geo.size.width, alignment: .leading)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(details.moves, id: \.self) { move in
                                    Text(move.move.name)
                                        .padding()
                                        .background(.black)
                                        .foregroundStyle(.white)
                                        .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack {}
                            .frame(width: geo.size.width, height: geo.size.height * 0.004)
                            .background(.black)
                            .padding(.vertical)
                        
                        Text("Abilities")
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.bottom, geo.size.height * 0.01)
                            .frame(width: geo.size.width, alignment: .leading)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(details.abilities, id: \.self) { abilityWrapper in
                                    Text(abilityWrapper.ability.name)
                                        .padding()
                                        .background(.black)
                                        .foregroundStyle(.white)
                                        .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack {}
                            .frame(width: geo.size.width, height: geo.size.height * 0.004)
                            .background(.black)
                            .padding(.vertical)
                        
                        HStack {
                            Text("Forms:")
                                .font(.title2)
                                .padding(.horizontal)
                            VStack {
                                ForEach(details.forms, id: \.name) { form in
                                    HStack {
                                        Text(form.name)
                                        Spacer()
                                    }
                                }
                            }
                            Spacer()
                        }
                        
                        HStack {}
                            .frame(width: geo.size.width, height: geo.size.height * 0.004)
                            .background(.black)
                            .padding(.vertical)
                        
                        Text("Games")
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.bottom, geo.size.height * 0.01)
                            .frame(width: geo.size.width, alignment: .leading)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(details.game_indices, id: \.self) { gameIndex in
                                    let game = gameIndex.version.name
                                    let gameColor = detailsViewModel.getGameColor(game: game)
                                    if gameColor.background != .white {
                                        Text(game)
                                            .padding()
                                            .background(gameColor.background)
                                            .foregroundStyle(gameColor.foreground)
                                            .cornerRadius(20)
                                    } else {
                                        Text(game)
                                            .padding()
                                            .background(gameColor.background)
                                            .foregroundStyle(gameColor.foreground)
                                            .cornerRadius(20)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(.black, lineWidth: 2)
                                            }
                                    }
                                }
                            }
                            .frame(height: geo.size.height * 0.1)
                            .padding(.horizontal)
                        }
                        
                        HStack {}
                            .frame(width: geo.size.width, height: geo.size.height * 0.004)
                            .background(.black)
                            .padding(.vertical)
                        
                        HStack {
                            Text("Types:")
                                .font(.title2)
                                .padding(.horizontal)
                            VStack {
                                ForEach(details.types, id: \.self) { typeWrapper in
                                    HStack {
                                        Text(typeWrapper.type.name)
                                        Spacer()
                                    }
                                }
                            }
                            Spacer()
                        }
                        
                        VStack {}
                            .frame(height: geo.size.height * 0.1)
                    }
                }
                .ignoresSafeArea()
            }
            
            GeometryReader { geo in
               DetailsHeaderView(geo: geo, details: details)
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
