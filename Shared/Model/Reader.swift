//
//  Reader.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//

import Foundation
import SwiftUI

struct Reader: Identifiable, Codable {
    
    var id: Int?
    var name: String?
    var prefersDarkMode: Bool
    var lastPageReadId: Int?
    var fontSize: Int
    var primaryColor: String?
    var secondaryColor: String?
    // When decoding and encoding from JSON, translate snake_case
    // column names into camelCase
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case prefersDarkMode = "prefers_dark_mode"
        case lastPageReadId = "last_page_read_id"
        case fontSize = "font_size"
        case primaryColor = "primary_color"
        case secondaryColor = "secondary_color"
    }
    
}
