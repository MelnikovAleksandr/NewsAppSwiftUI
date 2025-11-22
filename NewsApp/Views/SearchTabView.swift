//
//  SearchTabView.swift
//  NewsApp
//
//  Created by Александр Мельников on 22.11.2025.
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var vm = SearchViewModel()
    
    var body: some View {
        NavigationView {
            ArticlesListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $vm.searchQuery)
        .onChange(of: vm.searchQuery, { oldValue, newValue in
            if newValue.isEmpty {
                vm.phase = .empty
            }
        })
        .onSubmit(of: .search, search)
    }
    
    
    private var articles: [Article] {
        if case let .success(articles) = vm.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch vm.phase {
        case .empty:
            if !vm.searchQuery.isEmpty {
                ProgressView()
            } else {
                EmptyPlaceHolderView(text: "Type your query to search", image: Image(systemName: "magnifyingglass"))
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceHolderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
            
        case .failure(let error):
            RetryView(text: error.localizedDescription) {
                search()
            }
        default: EmptyView()
        }
    }
    
    private func search() {
        Task {
            await vm.searchArticles()
        }
    }
}

#Preview {
    @Previewable @StateObject var bookmarkViewModel = BookmarkViewModel.shared
    SearchTabView().environmentObject(bookmarkViewModel)
}
