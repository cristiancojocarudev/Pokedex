//
//  DetailsDivider.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct DetailsDivider: View {
    let geo: GeometryProxy
    
    var body: some View {
        HStack {}
            .frame(width: geo.size.width, height: geo.size.height * 0.004)
            .background(.black)
            .padding(.vertical)
    }
}
