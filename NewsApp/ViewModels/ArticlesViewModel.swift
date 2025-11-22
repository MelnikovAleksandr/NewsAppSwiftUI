//
//  ArticlesViewModel.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import SwiftUI
internal import Combine

enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
}

struct FetchDataToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor
class ArticlesViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var fetchDataToken: FetchDataToken
    
    private let api = NewsAPI.shared
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        self.fetchDataToken = FetchDataToken(category: selectedCategory, token: Date())
        
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
    }
    
    func loadArticles() async {
        if Task.isCancelled { return }
        phase = .empty
        do {
            let articles = try await api.fetch(from: fetchDataToken.category)
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            print("Fetch error - \(error)")
            phase = .failure(error)
        }
    }
    
}
