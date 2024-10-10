//
//  RealmChatMessageStore.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation
import RealmSwift

class RealmChatMessageStore: ChatMessageStore {
    let realm: Realm
    
    init?() {
        do {
            realm = try Realm()
        } catch {
            print("Failed to open Realm: \(error)")
            return nil
        }
    }
    
    func saveChatMessage(_ message: ChatMessage) throws {
        try realm.write {
            realm.add(message, update: .all)
        }
    }
    
    func getMessage(withKey key: String) -> ChatMessage? {
        return realm.object(ofType: ChatMessage.self, forPrimaryKey: key)
    }
    
    func getAllMessages() -> [ChatMessage] {
        return Array(realm.objects(ChatMessage.self))
    }
}
