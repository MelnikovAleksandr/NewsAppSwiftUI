//
//  Article.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import Foundation

fileprivate let realetiveDateFormetter = RelativeDateTimeFormatter()

struct ArticleResponse: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?

}

struct Article: Codable, Equatable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name) · \(realetiveDateFormetter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
}

extension Article: Identifiable {
    var id: String { url }
}

extension Article {
    
    static var previewData: [Article] {
        let previewDataUrl = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataUrl)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let apiResponse = try! jsonDecoder.decode(ArticleResponse.self, from: data)
        return apiResponse.articles ?? []
    }
    
}

struct Source: Codable, Equatable {
    let id: String?
    let name: String
}
