//
//  DetailsModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import Foundation
import SwiftUI

struct PokeStat: Hashable {
    var name: String
    var value: Int
}

struct ColoredGameIndex: Hashable {
    var gameIndex: GameIndex
    var coloration: Coloration
    
    static func == (lhs: ColoredGameIndex, rhs: ColoredGameIndex) -> Bool {
        return lhs.gameIndex.version.name == rhs.gameIndex.version.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(gameIndex)
    }
}

typealias Coloration = (background: Color, foreground: Color)

var gameColor: [String: Coloration] = [
    "green": (.green, .black),
    "red": (.red, .black),
    "blue": (.blue, .white),
    "yellow": (.yellow, .black),
    "gold": (Color(red: 207 / 255, green: 181 / 255, blue: 57 / 255), .black),
    "silver": (Color(red: 192 / 255, green: 192 / 255, blue: 192 / 255), .black),
    "crystal": (Color(red: 167 / 255, green: 216 / 255, blue: 222 / 255), .black),
    "ruby": (Color(red: 155 / 255, green: 17 / 255, blue: 30 / 255), .white),
    "sapphire": (.blue, .black),
    "emerald": (.green, .black),
    "white": (.white, .black)
]
