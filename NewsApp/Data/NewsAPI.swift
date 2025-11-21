//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import Foundation


struct NewsAPI {
    
    static let shared = NewsAPI()
    private init() {}
    
    private let apiKey = "7958a49bb5f244408e2b604d629f40a9"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetch(from category: Category) async throws -> [Article] {
        let url = generateNewsURL(from: category)
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw generateError(message: "Bad Response")
        }
        switch response.statusCode {
        case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(ArticleResponse.self, from: data)
            if apiResponse.status == "ok" {
                print("fetch ok, articles size - \(String(describing: apiResponse.articles?.count))")
                return apiResponse.articles ?? []
            } else {
                throw generateError(message: apiResponse.message ?? "A server error occurred")
            }
            
        default:
            throw generateError(message: "A server error occurred")
        }
    }
    
    private func generateError(code: Int = -1, message: String) -> Error {
        return NSError(domain: "NewsApi", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)!
    }
    
}
