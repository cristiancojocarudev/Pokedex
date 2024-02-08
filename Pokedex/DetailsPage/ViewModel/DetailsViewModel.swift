//
//  DetailsViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 07/02/24.
//

import Foundation
import SwiftUI

struct PokeStat: Hashable {
    var name: String
    var value: Int
}

class DetailsViewModel: ObservableObject {
    var pokemonDetails: PokemonDetails
    
    var imagesGallery: [[URL?]] = []
    
    var mainStatsTable: [[PokeStat]] = []
    
    var gameColor: [String: (background: Color, foreground: Color)] = [
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
    
    init(pokemonDetails: PokemonDetails) {
        self.pokemonDetails = pokemonDetails
        populateImagesGallery()
        populateMainStatsTable()
    }
    
    private func populateImagesGallery() {
        imagesGallery.append([
            URL(string: pokemonDetails.sprites.front_default), 
            URL(string: pokemonDetails.sprites.back_default),
        ])
        imagesGallery.append([
            URL(string: pokemonDetails.sprites.other.home.front_default),
            URL(string: pokemonDetails.sprites.other.dream_world.front_default),
        ])
        imagesGallery.append([
            URL(string: pokemonDetails.sprites.other.showdown.front_default),
            URL(string: pokemonDetails.sprites.other.showdown.back_default),
        ])
    }
    
    private func populateMainStatsTable() {
        let rowLength = 3
        mainStatsTable.append([
            PokeStat(name: "height", value: pokemonDetails.height),
            PokeStat(name: "weight", value: pokemonDetails.weight),
            PokeStat(name: "base experience", value: pokemonDetails.base_experience)
        ])
        var rowBuffer: [PokeStat] = []
        for stat in pokemonDetails.stats {
            let value = stat.base_stat
            let name = stat.stat.name
            let pokeStat = PokeStat(name: name, value: value)
            rowBuffer.append(pokeStat)
            if rowBuffer.count == rowLength {
                mainStatsTable.append(rowBuffer)
                rowBuffer = []
            }
        }
    }
    
    func getGameColor(game: String) -> (background: Color, foreground: Color) {
        for key in gameColor.keys {
            if game.contains(key) {
                return gameColor[key]!
            }
        }
        return (Color.black, Color.white)
    }
}
