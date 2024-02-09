//
//  DetailsViewModel.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 07/02/24.
//

import Foundation
import SwiftUI

class DetailsViewModel: ObservableObject {
    @Published var pokemonDetails: PokemonDetails
    
    var imagesGallery: [[URL]] = []
    
    var mainStatsTable: [[PokeStat]] = []
    
    init(pokemonDetails: PokemonDetails) {
        self.pokemonDetails = pokemonDetails
        populateImagesGallery()
        populateMainStatsTable()
    }
    
    private func populateImagesGallery() {
        let rowLength = 3
        let imageReferences: [String?] = [
            pokemonDetails.sprites.front_default,
            pokemonDetails.sprites.other.home.front_default,
            pokemonDetails.sprites.other.showdown.front_default,
            pokemonDetails.sprites.back_default,
            pokemonDetails.sprites.other.dream_world.front_default,
            pokemonDetails.sprites.other.showdown.back_default
        ]
        var rowBuffer: [URL] = []
        for imageReference in imageReferences {
            if let imageReference = imageReference {
                if let imageUrl = URL(string: imageReference) {
                    rowBuffer.append(imageUrl)
                    if rowBuffer.count == rowLength {
                        imagesGallery.append(rowBuffer)
                        rowBuffer = []
                    }
                }
            }
        }
        if !rowBuffer.isEmpty {
            imagesGallery.append(rowBuffer)
        }
    }
    
    private func populateMainStatsTable() {
        let rowLength = 3
        mainStatsTable.append([])
        if let height = pokemonDetails.height {
            mainStatsTable[0].append(PokeStat(name: "height", value: height))
        }
        if let weight = pokemonDetails.height {
            mainStatsTable[0].append(PokeStat(name: "weight", value: weight))
        }
        if let baseExperienceht = pokemonDetails.height {
            mainStatsTable[0].append(PokeStat(name: "base experience", value: baseExperienceht))
        }
        var rowBuffer: [PokeStat] = []
        for stat in pokemonDetails.stats {
            let value = stat.base_stat
            let pokeStat = PokeStat(name: stat.stat.name, value: value)
            rowBuffer.append(pokeStat)
            if rowBuffer.count == rowLength {
                mainStatsTable.append(rowBuffer)
                rowBuffer = []
            }
        }
        if !rowBuffer.isEmpty {
            mainStatsTable.append(rowBuffer)
        }
    }
    
    func getGameColor(game: String) -> Coloration {
        for key in gameColor.keys {
            if game.contains(key) {
                return gameColor[key]!
            }
        }
        return (Color.black, Color.white)
    }
    
    func getColoredGameIndices() -> [ColoredGameIndex] {
        return pokemonDetails.game_indices.map({ColoredGameIndex(gameIndex: $0, coloration: getGameColor(game: $0.version.name))})
    }
}
