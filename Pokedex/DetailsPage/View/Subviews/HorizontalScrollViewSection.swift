//
//  HorizontalScrollViewSection.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct HorizontalScrollViewSection: View {
    let geo: GeometryProxy
    
    var title: String
    var data: [String]
    
    var body: some View {
        Text(title)
            .font(.title2)
            .padding(.horizontal)
            .padding(.bottom, geo.size.height * 0.01)
            .frame(width: geo.size.width, alignment: .leading)
        ScrollView(.horizontal) {
            HStack {
                ForEach(data, id: \.self) { text in
                    Text(text)
                        .padding()
                        .background(.black)
                        .foregroundStyle(.white)
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)
        }
    }
}
