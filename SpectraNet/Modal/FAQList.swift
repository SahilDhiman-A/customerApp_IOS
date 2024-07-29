//
//  FAQList.swift
//  My Spectra
//
//  Created by Chakshu on 20/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import Foundation
struct FAQList: Codable {
    let data: [FAQ]?
    let message: String?
    let statusCode: Int?
}

// MARK: - Datum
struct FAQCategory: Codable {
    let id: String?
    let categoryInfo: categoryInfo?
    var faqInfo: [FAQ]?
    
    
    mutating func changeFaqInf0(faqInfoValue:[FAQ]){
        faqInfo?.removeAll()
        faqInfo = faqInfoValue
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryInfo = "category_info"
        case faqInfo = "faq_info"
    }
}
struct FAQFullData: Codable {
    let data: [FAQCategory]?
}

struct categoryInfo: Codable {
    let id, name: String?
    let isDeleted, isActive: Bool?
    let segmentID, createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case isDeleted = "is_deleted"
        case isActive = "is_active"
        case segmentID = "segment_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case v = "__v"
    }
}
struct FAQ: Codable {
    let id, question, answer: String?
    let link, imageURL, videoURL: String?
    let viewCount: Int?
    let isActive: Bool?
    let categoryID: String?
    let thumbUpCount, thumbDownCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case question, answer, link
        case imageURL = "image_url"
        case videoURL = "video_url"
        case viewCount = "view_count"
        case isActive = "is_active"
        case categoryID = "category_id"
        case thumbUpCount = "thumb_up_count"
        case thumbDownCount = "thumb_down_count"
    }
}

