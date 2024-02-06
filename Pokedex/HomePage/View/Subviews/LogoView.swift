//
//  LogoView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import SwiftUI

struct LogoView: View {
    let geo: GeometryProxy
    
    var body: some View {
        HStack {
            Text("Pokedex")
                .font(.largeTitle)
                .foregroundStyle(.red)
                .padding(.leading)
                .shadow(radius: 3)
            Image(.pokedexImg)
                .resizable()
                .scaledToFit()
                .frame(height: geo.size.height * 0.1)
        }
        .background(.white)
        .cornerRadius(15)
        .shadow(color: .red, radius: 5, x: geo.size.width * 0.03, y: geo.size.width * 0.03)
        .shadow(color: .blue, radius: 5, x: -geo.size.width * 0.03, y: -geo.size.width * 0.03)
    }
}

#Preview {
    GeometryReader { geo in
        LogoView(geo: geo)
    }
}
