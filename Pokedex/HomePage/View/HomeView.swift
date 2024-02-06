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
                                    ForEach(homeViewModel.filteredAndPaginatedPokemons, id: \.self) { pokemon in
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
                            .frame(height: geo.size.height * 0.6)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundStyle(homeViewModel.canGoBack ? .black : .gray)
                                .onTapGesture {
                                    homeViewModel.goBack()
                                }
                            Spacer()
                            Spacer()
                            Image(systemName: "arrow.right")
                                .padding()
                                .foregroundStyle(homeViewModel.canGoForward ? .black : .gray)
                                .onTapGesture {
                                    homeViewModel.goForward()
                                }
                            Spacer()
                        }
                        .ignoresSafeArea()
                        .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.1)
                        .background(.green)
                        .cornerRadius(15)
                    }
                    .padding()
                }
            }
        }
        .onAppear() {
            homeViewModel.loadData()
        }
        .onChange(of: homeViewModel.searchText) { oldValue, newValue in
            homeViewModel.page = 0
        }
    }
}

#Preview {
    HomeView()
}
