//
//  ArticlesListView.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import SwiftUI

struct ArticlesListView: View {
    
    let articles: [Article]
    @State private var selectionArticle: Article?
    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectionArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $selectionArticle) {
            SafariView(url: $0.articleURL)
                .edgesIgnoringSafeArea(.bottom)
        }
        
    }
    
}

#Preview {
    @Previewable @StateObject var bookmarkViewModel = BookmarkViewModel.shared
    NavigationView {
        ArticlesListView(articles: Article.previewData)
            .environmentObject(bookmarkViewModel)
    }
}
