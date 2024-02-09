//
//  VerticalListSection.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI

struct VerticalListSection: View {
    let geo: GeometryProxy
    
    var title: String
    var data: [String]
    
    var body: some View {
        HStack {
            Text("\(title):")
                .font(.title2)
                .padding(.horizontal)
            VStack {
                ForEach(data, id: \.self) { text in
                    HStack {
                        Text(text)
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
}
