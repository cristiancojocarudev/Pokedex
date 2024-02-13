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
                                List {
                                    ForEach(homeViewModel.pokemonItems, id: \.self) { pokemonItem in
                                        PokemonCellView(geo: geo, pokemonItem: pokemonItem) {
                                            homeViewModel.navigateToDetailsPage(pokemonItem: pokemonItem)
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        Text("Loading...")
                                        Spacer()
                                    }
                                    .onAppear() {
                                        print("Load more data")
                                        homeViewModel.loadMoreData()
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
