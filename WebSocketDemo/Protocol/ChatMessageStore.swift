//
//  ChatMessageStore.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation

protocol ChatMessageStore {
    func saveChatMessage(_ message: ChatMessage) throws
    func getMessage(withKey key: String) -> ChatMessage?
    func getAllMessages() -> [ChatMessage]
}
