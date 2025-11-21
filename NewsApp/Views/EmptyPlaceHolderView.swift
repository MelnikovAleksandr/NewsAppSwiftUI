//
//  EmptyPlaceHolderView.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import SwiftUI

struct EmptyPlaceHolderView: View {
    let text: String
    let image: Image?
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            if let image = self.image {
                image.imageScale(.large).font(.system(size: 52))
            }
            Text(text)
            Spacer()
        }
    }
}


#Preview {
    EmptyPlaceHolderView(text: "No Bookmarks", image: Image(systemName: "bookmark"))
}
