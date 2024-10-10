//
//  ChatMessage.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation
import RealmSwift

class ChatMessage: Object {
    @Persisted(primaryKey: true) var key: String
    @Persisted var message: String = ""
    @Persisted var room: String = ""
    @Persisted var timestamp: Int64 = 0
    @Persisted var from: String = ""
    @Persisted var isUploaded: Bool = false
    
    convenience init(key: String, message: String, room: String, timestamp: Int64, from: String, isUploaded: Bool = false) {
        self.init()
        self.key = key
        self.message = message
        self.room = room
        self.timestamp = timestamp
        self.from = from
        self.isUploaded = isUploaded
    }
}
