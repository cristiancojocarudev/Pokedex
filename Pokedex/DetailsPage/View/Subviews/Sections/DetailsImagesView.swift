//
//  DetailsImages.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 09/02/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailsImagesView: View {
    let geo: GeometryProxy
    
    var imagesGallery: [[URL?]]
    
    var body: some View {
        Text("Images")
            .font(.title2)
            .padding()
            .frame(width: geo.size.width, alignment: .leading)
        HStack {
            ForEach(imagesGallery, id: \.self) { urlCouple in
                VStack {
                    ForEach(urlCouple, id: \.self) { url in
                        if let url = url {
                            WebImage(url: url, options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                                .placeholder {ProgressView()}
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width / 4, height: geo.size.height * 0.15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 36)
                                        .stroke(.black, lineWidth: 5)
                                )
                        }
                    }
                }
            }
        }
    }
}
