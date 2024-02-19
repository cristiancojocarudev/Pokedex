//
//  LoadingView.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 15/02/24.
//

import SwiftUI

struct LoadingView: View {
    let geo: GeometryProxy
    
    @State var dotsCounter = 3
    @State var firstLoading = true
    
    func tick() {
        if dotsCounter == 3 {
            dotsCounter = 0
        } else {
            dotsCounter += 1
        }
    }
    
    func loadingString() -> String {
        var string = "Loading"
        for _ in 0..<dotsCounter {
            string += "."
        }
        return string
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text(loadingString())
                .foregroundStyle(.white)
            Spacer()
        }
        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.1)
        .background(.blue)
        .cornerRadius(15)
        .onAppear() {
            if firstLoading {
                firstLoading = false
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    self.tick()
                }
            }
        }
    }
}
