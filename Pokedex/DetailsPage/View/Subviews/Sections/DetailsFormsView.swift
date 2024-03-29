//
//  DetailsFormsView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct DetailsFormsView: View {
    let geo: GeometryProxy
    
    var forms: [PokeForm]
    
    var body: some View {
        VerticalListSection(geo: geo, title: "Forms", data: forms.map({$0.name}))
    }
}
