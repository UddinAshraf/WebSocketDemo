//
//  BackupFileManager.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation
import Realm
import Zip

class BackupFileManager {
    static let shared = BackupFileManager()
    
    private init() {}
    
    func createBackUpFile(from messages: [ChatMessage]) -> URL? {
        let fileName = "backup.txt"
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        let messageToUpload = messages.filter { !$0.isUploaded }
        guard !messageToUpload.isEmpty else { return nil }
        
        let messagesContent = messageToUpload.map { "key:\($0.key), message:\($0.message),room:\($0.room),from:\($0.from), timestamp:\($0.timestamp)" }.joined(separator: "\n")
        do {
            try messagesContent.write(to: fileURL, atomically: true, encoding: .utf8)
        }catch {
            return nil
        }
        
        do {
            let zipFilePath = try Zip.quickZipFiles([fileURL], fileName: "backup")
            return zipFilePath
            
        } catch {
            return nil
        }
    }
}
