//
//  PageHandlerView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct PageHandlerView: View {
    let geo: GeometryProxy
    
    var page: Int
    var maxPage: Int
    var canGoBack: Bool
    var canGoForward: Bool
    
    var goBack: () -> Void
    var goForward: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "arrow.left")
                .padding()
                .foregroundStyle(canGoBack ? .black : Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                .onTapGesture {
                    if canGoBack {
                        goBack()
                    }
                }
            Spacer()
            Text("Page \(maxPage + 1 > 0 ? page + 1 : 0) of \(maxPage + 1)")
            Spacer()
            Image(systemName: "arrow.right")
                .padding()
                .foregroundStyle(canGoForward ? .black : Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                .onTapGesture {
                    if canGoForward {
                        goForward()
                    }
                }
            Spacer()
        }
        .ignoresSafeArea()
        .frame(width: geo.size.width * 0.65, height: geo.size.height * 0.1)
        .background(.white)
        .cornerRadius(15)
    }
}
