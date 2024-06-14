//
//  Reader.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//

import Foundation

struct Reader: Identifiable, Codable {
    
    var id: Int?
    var name: String?
    var prefersDarkMode: Bool
    var lastPageReadId: Int?
    var fontSize: Int?
    // When decoding and encoding from JSON, translate snake_case
    // column names into camelCase
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case prefersDarkMode = "prefers_dark_mode"
        case lastPageReadId = "last_page_read_id"
        case fontSize = "font_size"
    }
    
}
