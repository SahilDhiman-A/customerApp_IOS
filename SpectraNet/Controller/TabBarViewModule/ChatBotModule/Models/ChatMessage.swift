//
//  ChatMessage.swift
//  My Spectra
//
//  Created by Ashish on 11/1/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation

class ChatMessage {
    var message = ""
    var type = MessageType.User
    init(message: String, type: MessageType) {
        self.message = message
        self.type = type
    }
}

enum MessageType {
    case User
    case Bot
}
