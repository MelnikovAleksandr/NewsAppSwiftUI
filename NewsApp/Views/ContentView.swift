//
//  ContentView.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            SearchTabView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            BookmarkTabView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
    }
}

#Preview {
    @Previewable @StateObject var bookmarkViewModel = BookmarkViewModel.shared
    ContentView().environmentObject(bookmarkViewModel)
}
