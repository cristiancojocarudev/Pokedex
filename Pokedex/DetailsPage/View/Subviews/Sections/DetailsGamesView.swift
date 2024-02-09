//
//  DetailsGamesView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct DetailsGamesView: View {
    let geo: GeometryProxy
    
    var coloredGameIndices: [ColoredGameIndex]
    
    var body: some View {
        Text("Games")
            .font(.title2)
            .padding(.horizontal)
            .padding(.bottom, geo.size.height * 0.01)
            .frame(width: geo.size.width, alignment: .leading)
        ScrollView(.horizontal) {
            HStack {
                ForEach(coloredGameIndices, id: \.self) { coloredGameIndex in
                    let game = coloredGameIndex.gameIndex.version.name
                    let gameColor = coloredGameIndex.coloration
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
    }
}
