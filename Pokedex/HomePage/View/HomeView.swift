//
//  ContentView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 06/02/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        
        NavigationStack {
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
                            LogoView(geo: geo)
                            Spacer()
                        }
                        
                        SearchBar(text: $homeViewModel.searchText)
                            .padding()
                            .shadow(radius: 5)
                        
                        HStack {
                            Spacer()
                            ScrollView {
                                VStack {
                                    ForEach(homeViewModel.filteredPokemons, id: \.self) { pokemon in
                                        HStack {
                                            Text(pokemon.name)
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
        }
        .onAppear() {
            homeViewModel.loadData()
        }
    }
}

#Preview {
    HomeView()
}
