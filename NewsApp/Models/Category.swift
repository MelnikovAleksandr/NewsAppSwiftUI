//
//  Category.swift
//  NewsApp
//
//  Created by Александр Мельников on 20.11.2025.
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertaiment
    case sports
    case science
    case health
    
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: Self { self }
}
