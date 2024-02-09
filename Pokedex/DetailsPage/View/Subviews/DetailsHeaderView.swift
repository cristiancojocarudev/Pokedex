//
//  DetailsHeaderView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 07/02/24.
//

import SwiftUI

struct DetailsHeaderView: View {
    let geo: GeometryProxy
    
    let details: PokemonDetails
    
    var body: some View {
        HStack {
            ZStack {
                HStack {
                    Spacer()
                    if let profileImage = details.sprites.other.home.front_default {
                        AsyncImage(url: URL(string: profileImage)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width / 2, height: geo.size.height * 0.2)
                                .padding(.top, geo.size.height * 0.03)
                                .ignoresSafeArea()
                                .shadow(color: .red, radius: 5, x: geo.size.width * 0.03, y: geo.size.width * 0.03)
                                .shadow(color: .blue, radius: 5, x: -geo.size.width * 0.03, y: -geo.size.width * 0.03)
                                .padding()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                
                HStack {
                    Text(details.name)
                        .font(.title)
                        .padding()
                        .background(.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.blue, lineWidth: 5)
                        )
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.25, alignment: .bottomLeading)
                .padding(.leading, geo.size.width * 0.2)
                .padding(.bottom, geo.size.height * 0.05)
            }
        }
        .frame(width: geo.size.width, height: geo.size.height * 0.25)
        .background(.white)
        .cornerRadius(36)
        .overlay(
            RoundedRectangle(cornerRadius: 36)
                .stroke(.red, lineWidth: 5)
        )
        .ignoresSafeArea()
    }
}
