//
//  ContentView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image(.pokewallpaper)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height * 1.1, alignment: .center)
                    .ignoresSafeArea()
            }
            
            GeometryReader { geo in
                VStack {
                    HStack {
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
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: geo.size.height * 0.1)
                    
                    HStack {
                        Spacer()
                        ScrollView {
                            VStack {
                                ForEach(viewModel.pokemons, id: \.self) { pokemon in
                                    HStack {
                                        Text(pokemon)
                                            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.1)
                                            .background(.white)
                                            .cornerRadius(15)
                                    }
                                    .shadow(radius: 5)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .padding()
            }
        }
        
        .onAppear() {
            viewModel.laodData()
        }
    }
}

#Preview {
    ContentView()
}
