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
    @Published var history = [String]()
    private let api = NewsAPI.shared
    private let historyMaxLimit = 10
    private let historyDataStore = PlistDataStore<[String]>(filename: "histories")
    
    static let shared = SearchViewModel()
    
    private init() {
        load()
    }
    
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
            if searchQuery != self.searchQuery {
                return
            }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            if searchQuery != self.searchQuery {
                return
            }
            phase = .failure(error)
        }
    }
    
    func addHistory(_ text: String) {
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased()}) {
            history.remove(at: index)
        } else if history.count - 1 == historyMaxLimit {
            history.remove(at: 0)
        }
        
        history.insert(text, at: 0)
        historiesUpdated()
    }
    
    func removeHistory(_ text: String) {
        guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased()})  else {
            return
        }
        history.remove(at: index)
        historiesUpdated()
    }
    
    func removeAllHistory() {
        history.removeAll()
        historiesUpdated()
    }
    
    private func load() {
        Task {
            self.history = await historyDataStore.load() ?? []
        }
    }
    
    private func historiesUpdated() {
        let history = self.history
        Task {
            await historyDataStore.save(history)
        }
    }
}
