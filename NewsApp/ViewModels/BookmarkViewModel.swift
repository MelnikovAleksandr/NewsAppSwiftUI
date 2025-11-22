//
//  BookmarkViewModel.swift
//  NewsApp
//
//  Created by Александр Мельников on 22.11.2025.
//

import SwiftUI
internal import Combine

@MainActor
class BookmarkViewModel: ObservableObject {
    
    @Published private(set) var bookmarks: [Article] = []
    private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")
    
    static let shared = BookmarkViewModel()
    private init() {
        Task {
            await load()
        }
    }
    
    func isBookmark(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }
    
    func addBookmark(for article: Article) {
        guard !isBookmark(for: article) else {
            return
        }
        
        bookmarks.insert(article, at: 0)
        bookmarkUpdate()
    }
    
    func removeBookmark(for article: Article) {
        guard let index = bookmarks.firstIndex(where: {
            $0.id == article.id
        }) else {
            return
        }
        bookmarks.remove(at: index)
        bookmarkUpdate()
    }
    
    private func load() async {
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    private func bookmarkUpdate() {
        let bookmarks = self.bookmarks
        Task {
            await bookmarkStore.save(bookmarks)
        }
    }
}
