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
                                            NavigationLink {
                                                let detailsViewModel = DetailsViewModel(pokemonDetails: pokemonItem.details)
                                                DetailsView(detailsViewModel: detailsViewModel)
                                            } label: {
                                                HStack {
                                                    ZStack {
                                                        HStack {
                                                            if let imageUrl = pokemonItem.details.sprites.front_default {
                                                                AsyncImage(url: URL(string: imageUrl)) { image in
                                                                    image
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                                                                        .padding(.leading)
                                                                } placeholder: {
                                                                    ProgressView()
                                                                }
                                                            }
                                                            Spacer()
                                                        }
                                                        HStack {
                                                            Spacer()
                                                            Text(pokemonItem.reference.name)
                                                                .padding(.leading, geo.size.width * 0.07)
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.1)
                                                .background(.white)
                                                .cornerRadius(15)
                                                .shadow(radius: 5)
                                            }
                                        }
                                    }
                                }
                                .frame(height: geo.size.height * 0.6)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundStyle(homeViewModel.canGoBack ? .black : Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                                .onTapGesture {
                                    if homeViewModel.canGoBack {
                                        homeViewModel.goBack()
                                    }
                                }
                            Spacer()
                            Text("Page \(homeViewModel.filteredAndPaginatedPokemons.count > 0 ? homeViewModel.page + 1 : 0) of \(homeViewModel.maxPage + 1)")
                            Spacer()
                            Image(systemName: "arrow.right")
                                .padding()
                                .foregroundStyle(homeViewModel.canGoForward ? .black : Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                                .onTapGesture {
                                    if homeViewModel.canGoForward {
                                        homeViewModel.goForward()
                                    }
                                }
                            Spacer()
                        }
                        .ignoresSafeArea()
                        .frame(width: geo.size.width * 0.65, height: geo.size.height * 0.1)
                        .background(.white)
                        .cornerRadius(15)
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
            homeViewModel.page = 0
            homeViewModel.populatePokemonItems()
        }
    }
}

#Preview {
    HomeView()
}
