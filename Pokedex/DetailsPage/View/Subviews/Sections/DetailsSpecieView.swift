//
//  DetailsSpecieView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct DetailsSpecieView: View {
    let geo: GeometryProxy
    
    @State var specie: String?
    
    var body: some View {
        HStack {
            Text("Specie:")
                .font(.title2)
                .padding(.horizontal)
            Text(specie ?? "unknown")
            Spacer()
        }
    }
}
