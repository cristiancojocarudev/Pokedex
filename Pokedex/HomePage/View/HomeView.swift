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
                            if homeViewModel.isLoading {
                                VStack {
                                    Spacer()
                                    ProgressView()
                                        .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.3)
                                        .background(.white)
                                        .cornerRadius(20)
                                        .shadow(radius: 5)
                                    Spacer()
                                }
                                .frame(height: geo.size.height * 0.6)
                            } else {
                                ScrollView {
                                    VStack {
                                        ForEach(homeViewModel.pokemonItems, id: \.self) { pokemonItem in
                                            PokemonCellView(geo: geo, pokemonItem: pokemonItem)
                                        }
                                    }
                                }
                                .frame(height: geo.size.height * 0.6)
                            }
                            Spacer()
                        }
                        
                        PageHandlerView(geo: geo, page: homeViewModel.page, maxPage: homeViewModel.maxPage, canGoBack: homeViewModel.canGoBack, canGoForward: homeViewModel.canGoForward, goBack: homeViewModel.goBack, goForward: homeViewModel.goForward)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear() {
            homeViewModel.loadData()
        }
        .onChange(of: homeViewModel.searchText) { oldValue, newValue in
            homeViewModel.onSearchTextChanged()
        }
    }
}

#Preview {
    HomeView()
}
