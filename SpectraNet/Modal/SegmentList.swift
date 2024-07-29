//
//  SegmentList.swift
//  My Spectra
//
//  Created by Chakshu on 20/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SegmentList: Codable {
    let data: [Datum]?
    let message: String?
    let statusCode: Int?
    
}

// MARK: - Datum
struct Datum: Codable {
    let name: String?
    let isDeleted, isActive: Bool?
    let id, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case name
        case isDeleted = "is_deleted"
        case isActive = "is_active"
        case id = "_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


