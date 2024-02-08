//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import SwiftUI
import SDWebImageSVGCoder

@main
struct PokedexApp: App {
    
    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
