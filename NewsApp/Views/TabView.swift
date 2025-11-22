//
//  TabView.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var vm = ArticlesViewModel()
    
    var body: some View {
        NavigationView {
            
            ArticlesListView(articles: articles)
                .overlay(content: {
                    overlayView
                })
                .task(id: vm.fetchDataToken, {
                    loadTask()
                })
                .refreshable(action: refreshTask)
                .navigationTitle(vm.fetchDataToken.category.text)
                .navigationBarItems(trailing: menu)
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch vm.phase {
        case .empty: ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceHolderView(text: "No articles", image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()
        }
    }
    
    private var articles: [Article] {
        if case let .success(articles) = vm.phase {
            return articles
        } else {
            return []
        }
    }
    
    private func loadTask() {
        Task {
            await vm.loadArticles()
        }
    }
    
    private var menu: some View {
        Menu {
            Picker("Category", selection: $vm.fetchDataToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel").imageScale(.large)
        }
    }
    
    private func refreshTask() {
        Task {
            vm.fetchDataToken = FetchDataToken(category: vm.fetchDataToken.category, token: Date())
        }
    }
}

#Preview {
    @Previewable @StateObject var bookmarkViewModel = BookmarkViewModel.shared
    NewsTabView(
        vm: ArticlesViewModel(articles: Article.previewData)
    ).environmentObject(bookmarkViewModel)
}
