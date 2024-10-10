//
//  WebSocketManager.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation
import OSLog

class WebSocketManager {
    static let shared = WebSocketManager()
    
    private var serviceUrl = "wss://api.quarkshub.com/ws?_id=1001"
    private var task: URLSessionWebSocketTask?
    private let urlSession = URLSession(configuration: .default)
    private var webSocketURL: URL?
    private let logger = Logger()
    
    private init() {
        guard let url = URL(string: serviceUrl) else { return }
        self.webSocketURL = url
    }
    
    func connect() {
        guard let url = self.webSocketURL else { return }
        self.task = urlSession.webSocketTask(with: url)
        self.task?.resume()
        
        
        sendMessage(text: "{\"join\":\"general\", \"notifyjoin\":true, \"notifyleave\":true}")
        fetchMessages(channel: "general")
        listenForMessages()
           
    }
    
    func disconnect() {
        self.task?.cancel(with: .normalClosure, reason: nil)
        self.task = nil
    }
    
    
    private func listenForMessages() {
        task?.receive(completionHandler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .data(_):
                    logger.info("Received Message as Binary data type ")
                case .string(let message):
                    print(message)
                    self.handleMessage(message)
                @unknown default:
                    logger.error("Unknown Message Type")
                }
            case .failure(let failure):
                logger.error("Error in receiving message: \(failure.localizedDescription)")
                disconnect()
            }
            self.listenForMessages()
        })
    }
    
    func handleMessage(_ message: String) {
        
        guard let data = message.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let replyGetKeys = json["replygetkeys"] as? [[String: Any]] else {
            logger.error("Failed to parse replygetkeys")
            return
        }
        
        for entry in replyGetKeys {
            guard let key = entry["key"] as? String,
                  let value = entry["value"] as? [String: Any],
                  let jsonData = try? JSONSerialization.data(withJSONObject: value) else {
                logger.error("Failed to parse entry")
                continue
            }
            do {
                let decoder = JSONDecoder()
                let messageDetails = try decoder.decode(MessageDetails.self, from: jsonData)
                
                print("Key: \(key)")
                print("Message: \(messageDetails.message)")
                print("Room: \(messageDetails.room)")
                print("Timestamp: \(messageDetails.timestamp)")
                print("From: \(messageDetails.from)")
                
            } catch {
                logger.error("Failed to decode value for key \(key): \(error)")
            }
        }
    }
    
    private func sendMessage(text: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        task?.send(message) { error in
            guard let error else { return }
            self.logger.error("Failed to send message due to \(error.localizedDescription)")
        }
    }
    
    func fetchMessages(channel: String) {
         let fetchMessage = "{\"getkeys\":\"\(channel)_*\", \"skip\":0, \"limit\":100}"
         sendMessage(text: fetchMessage)
     }
       
}
