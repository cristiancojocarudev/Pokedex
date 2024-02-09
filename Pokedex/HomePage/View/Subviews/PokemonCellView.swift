//
//  PokemonCellView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct PokemonCellView: View {
    let geo: GeometryProxy
    
    @State var pokemonItem: PokemonItem
    
    var body: some View {
        NavigationLink {
            let detailsViewModel = DetailsViewModel(pokemonDetails: pokemonItem.details)
            DetailsView(detailsViewModel: detailsViewModel)
        } label: {
            HStack {
                ZStack {
                    HStack {
                        if let imageUrl = pokemonItem.details.sprites.front_default {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                                    .padding(.leading)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(pokemonItem.reference.name)
                            .padding(.leading, geo.size.width * 0.07)
                        Spacer()
                    }
                }
            }
            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.1)
            .background(.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}
