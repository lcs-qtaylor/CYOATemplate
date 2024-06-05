//
//  Edge.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-05-29.
//

import Foundation

struct Edge: Identifiable, Codable {
    
    var id: Int
    var prompt: String
    var fromPage: Int
    var toPage: Int

    // When decoding and encoding from JSON, translate snake_case
    // column names into camelCase
    enum CodingKeys: String, CodingKey {
        case id
        case prompt
        case fromPage = "from_page"
        case toPage = "to_page"
    }
    
}
