//
//  ArticleRowView.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import SwiftUI

struct ArticleRowView: View {
    
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    
    let article: Article
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure(_):
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large)
                        Spacer()
                    }
                @unknown default:
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large)
                        Spacer()
                    }
                }
            }
            .frame(minHeight: 200, maxHeight: 300)
            .background(Color.gray.opacity(0.3))
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Spacer()
                    
                    Button {
                        toogleBookmark(for: article)
                    } label: {
                        Image(systemName: bookmarkViewModel.isBookmark(for: article) ? "bookmark.fill" : "bookmark")
                    }.buttonStyle(.bordered)
                    
                    Button {
                        presentShareSheet(url: article.articleURL)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }.buttonStyle(.bordered)
                    
                }
                
            }.padding([.horizontal, .bottom])
        }
    }
    
    private func toogleBookmark(for article: Article) {
        if bookmarkViewModel.isBookmark(for: article) {
            bookmarkViewModel.removeBookmark(for: article)
        } else {
            bookmarkViewModel.addBookmark(for: article)
        }
    }
    
}

extension View {
    
    func presentShareSheet(url: URL) {
        let acticityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?.rootViewController?.present(acticityVC, animated: true)
    }
}

#Preview {
    @Previewable @StateObject var bookmarkViewModel = BookmarkViewModel.shared

    NavigationView {
        List {
            ArticleRowView(article: .previewData[0])
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
    .environmentObject(bookmarkViewModel)
}
