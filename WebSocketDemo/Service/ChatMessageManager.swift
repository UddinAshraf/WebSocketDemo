//
//  ChatMessageManager.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation
import OSLog


class ChatMessageManager {
    private let store: ChatMessageStore
    private let logger = Logger()
    
    init(store: ChatMessageStore) {
        self.store = store
    }
    
    func saveMessage(chatMessage: ChatMessage) {
        guard store.getMessage(withKey: chatMessage.key) == nil else {
            logger.info("Message with key \(chatMessage.key) already exists.")
            return
        }
        
        do {
            try store.saveChatMessage(chatMessage)
            logger.info("Saved new message with key: \(chatMessage.key)")
        } catch {
            logger.error("Error saving message: \(error)")
        }
    }

    
    func fetchAllMessages() -> [ChatMessage] {
        return store.getAllMessages()
    }
    
}
