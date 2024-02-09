//
//  DetailsMainStatsView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct DetailsMainStatsView: View {
    let geo: GeometryProxy
    
    var mainStatsTable: [[PokeStat]]
    
    var body: some View {
        Text("Main Stats")
            .font(.title2)
            .padding(.horizontal)
            .padding(.bottom, geo.size.height * 0.01)
            .frame(width: geo.size.width, alignment: .leading)
        VStack {
            ForEach(mainStatsTable, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.name) { pokeStat in
                        VStack {
                            Text(pokeStat.name)
                            Text(String(pokeStat.value))
                        }
                        .frame(width: geo.size.width * 0.22, height: geo.size.width * 0.2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                    let emptyViewsCounter = Array((0..<(3 - row.count)))
                    ForEach(emptyViewsCounter, id: \.self) { _ in
                        VStack {}
                            .frame(width: geo.size.width * 0.22, height: geo.size.width * 0.2)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}
