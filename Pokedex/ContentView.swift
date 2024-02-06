//
//  ContentView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geo in
            Image(.pokewallpaper)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height * 1.1, alignment: .center)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
