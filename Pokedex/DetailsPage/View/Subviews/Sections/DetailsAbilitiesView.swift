//
//  DetailsAbilitiesView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct DetailsAbilitiesView: View {
    let geo: GeometryProxy
    
    var abilities: [AbilityWrapper]
    
    var body: some View {
        HorizontalScrollViewSection(geo: geo, title: "Abilities", data: abilities.map({$0.ability.name}))
    }
}
