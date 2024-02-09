//
//  DetailsMovesView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct DetailsMovesView: View {
    let geo: GeometryProxy
    
    var moves: [MoveWrapper]
    
    var body: some View {
        HorizontalScrollViewSection(geo: geo, title: "Moves", data: moves.map({$0.move.name}))
    }
}
