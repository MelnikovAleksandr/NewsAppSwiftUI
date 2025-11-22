//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import SwiftUI

@main
struct NewsAppApp: App {
    
    @StateObject var bookmarkViewModel = BookmarkViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarkViewModel)
        }
    }
}
