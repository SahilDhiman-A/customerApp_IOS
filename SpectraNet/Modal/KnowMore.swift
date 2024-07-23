//
//  KnowMore.swift
//  My Spectra
//
//  Created by Chakshu on 26/10/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import Foundation
import Foundation

// MARK: - Welcome
struct KnowMore: Codable {
    let status: String
    let response: Response
    let message: String
}

// MARK: - Response
struct Response: Codable {
    let planID, planDescription: String
    let contentText: [ContentText]

    enum CodingKeys: String, CodingKey {
        case planID = "planId"
        case planDescription, contentText
    }
}

// MARK: - ContentText
struct ContentText: Codable {
    let iconID, title, content: String

    enum CodingKeys: String, CodingKey {
        case iconID = "iconId"
        case title, content
    }
}
