//
//  DetailsTypesView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct DetailsTypesView: View {
    let geo: GeometryProxy
    
    var types: [PokeTypeWrapper]
    
    var body: some View {
        VerticalListSection(geo: geo, title: "Types", data: types.map({$0.type.name}))
    }
}
