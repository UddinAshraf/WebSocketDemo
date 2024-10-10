//
//  BackupOperation.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation
import RealmSwift
import OSLog

class BackupOperation: Operation {
    override func main() {
        guard !isCancelled else { return }

        do {
            let realm = try Realm()
            let messages = Array(realm.objects(ChatMessage.self))

            let backupManager = BackupFileManager.shared
            if let backupFileURL = backupManager.createBackUpFile(from: messages) {
                let uploader = BackupUploader.shared
                uploader.uploadBackupFile(backupFileURL) { success in
                    if success {
                        Logger().info("Backup file uploaded successfully!")
                    } else {
                        Logger().error("Failed to upload backup.")
                    }
                }
            } else {
                Logger().info("No backup file was created; there may be no messages to back up.")
            }
        } catch {
            Logger().error("Error initializing Realm: \(error.localizedDescription)")
        }
    }
}


