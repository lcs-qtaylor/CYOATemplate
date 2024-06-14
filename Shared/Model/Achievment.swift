//
//  Achievment.swift
//  CYOATemplate
//
//  Created by Quinlan Daniel Taylor on 2024-06-11.
//

import Foundation

struct Achievement: Identifiable, Codable {
    var id: Int
    var pageId: Int?
    var achievementName: String?
    var achievementDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case pageId = "page_id"
        case achievementName = "achievement_Name"
        case achievementDescription = "achievement_Description"
    }
}
