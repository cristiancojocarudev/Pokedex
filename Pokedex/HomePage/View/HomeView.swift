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
                                .padding()
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            SearchBar(text: $homeViewModel.searchText)
                                .padding(.horizontal)
                                .shadow(radius: 5)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            List {
                                ForEach(homeViewModel.pokemonItems, id: \.self) { pokemonItem in
                                    PokemonCellView(geo: geo, pokemonItem: pokemonItem) {
                                        homeViewModel.navigateToDetailsPage(pokemonItem: pokemonItem)
                                    }
                                    .listRowInsets(EdgeInsets.init(top:  geo.size.height * 0.01, leading: 5, bottom: 0, trailing: 5))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                                if homeViewModel.canGoForward {
                                    HStack {
                                        Spacer()
                                        LoadingView(geo: geo)
                                        Spacer()
                                    }
                                    .listRowInsets(EdgeInsets.init(top:  geo.size.height * 0.01, leading: 5, bottom: 0, trailing: 5))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                    .onAppear() {
                                        homeViewModel.loadMoreData()
                                    }
                                }
                            }
                            .environment(\.defaultMinListRowHeight, geo.size.height * 0.1)
                            .scrollContentBackground(.hidden)
                            .frame(width: geo.size.width * 0.92, height: geo.size.height * 0.8)
                            Spacer()
                        }
                    }
                    .frame(width: geo.size.width)
                }
            }
            .navigationDestination(isPresented: $homeViewModel.isDetailsPagePresented) {
                if let detailsViewModel = homeViewModel.detailsViewModel {
                    DetailsView(detailsViewModel: detailsViewModel, isPresented: $homeViewModel.isDetailsPagePresented)
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: homeViewModel.searchText) { oldValue, newValue in
            homeViewModel.onSearchTextChanged()
        }
    }
}

#Preview {
    HomeView()
}
