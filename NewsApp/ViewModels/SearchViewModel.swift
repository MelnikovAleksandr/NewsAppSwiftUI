//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Александр Мельников on 22.11.2025.
//

import SwiftUI
internal import Combine

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var searchQuery = ""
    private let api = NewsAPI.shared
    
    func searchArticles() async {
        if Task.isCancelled { return }
        
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await api.search(for: searchQuery)
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            phase = .failure(error)
        }
    }
}
