//
//  SearchHistoryListView.swift
//  NewsApp
//
//  Created by Александр Мельников on 22.11.2025.
//

import SwiftUI

struct SearchHistoryListView: View {
    
    @ObservedObject var vm: SearchViewModel
    let onSubmit: (String) -> ()
    
    var body: some View {
        List {
            HStack {
                Text("Recently Searched")
                Spacer()
                Button("Clear") {
                    vm.removeAllHistory()
                }
                .foregroundColor(.accentColor)
            }
            .listRowSeparator(.hidden)
            
            ForEach(vm.history, id: \.self) { history in
                Button(history) {
                    onSubmit(history)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        vm.removeHistory(history)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchHistoryListView(
        vm: SearchViewModel.shared
    ) { _ in }
}
