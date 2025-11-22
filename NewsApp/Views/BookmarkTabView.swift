//
//  BookmarkTabView.swift
//  NewsApp
//
//  Created by Александр Мельников on 22.11.2025.
//

import SwiftUI

struct BookmarkTabView: View {
    
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    
    var body: some View {
        NavigationView {
            ArticlesListView(articles: bookmarkViewModel.bookmarks)
                .overlay(overlayView(isEmpty: bookmarkViewModel.bookmarks.isEmpty))
                .navigationTitle("Saved Articles")
        }
    }
    
    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceHolderView(text: "No saved Bookmarks", image: Image(systemName: "bookmark"))
        }
    }
}

#Preview {
    @Previewable @StateObject var bookmarkViewModel = BookmarkViewModel.shared
    BookmarkTabView().environmentObject(bookmarkViewModel)
}
