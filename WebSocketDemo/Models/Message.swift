//
//  Message.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation
struct MessageDetails: Codable {
    let message: String
    let room: String
    let timestamp: String
    let from: String
}

struct Message: Codable {
    let key: String
    let value: MessageDetails
}
