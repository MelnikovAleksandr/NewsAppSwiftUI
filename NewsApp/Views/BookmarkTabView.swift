//
//  BookmarkTabView.swift
//  NewsApp
//
//  Created by Александр Мельников on 22.11.2025.
//

import SwiftUI

struct BookmarkTabView: View {
    
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    @State var searchText: String = ""
    
    var body: some View {
        let articles = self.articles
        
        NavigationView {
            ArticlesListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle("Saved Articles")
        }
        .searchable(text: $searchText)
    }
    
    private var articles: [Article] {
        if searchText.isEmpty {
            return bookmarkViewModel.bookmarks
        }
        return bookmarkViewModel.bookmarks
            .filter {
                $0.title.lowercased().contains(searchText.lowercased()) || $0.descriptionText.lowercased().contains(searchText.lowercased())
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
