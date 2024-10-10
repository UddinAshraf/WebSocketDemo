//
//  AppDelegate.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import UIKit
import RealmSwift
import OSLog
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let chatBackupTaskIdentifier = "com.WebSocketDemo.chatBackup"
    let timeInterval: Double = 15//2 * 60
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    Logger().info("No Migration needed")
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            let realm = try Realm()
            print("Realm file path: \(realm.configuration.fileURL!)")
        } catch let error {
            Logger().error("Failed to open Realm database: \(error.localizedDescription)")
        }


        BGTaskScheduler.shared.register(forTaskWithIdentifier: chatBackupTaskIdentifier, using: nil) { task in
             self.handleBackgroundBackupTask(task: task as! BGAppRefreshTask)
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    func handleBackgroundBackupTask(task: BGAppRefreshTask) {
        scheduleNextBackupTask()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        let operation = BackupOperation()
        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }

        queue.addOperation(operation)
    }

    func scheduleNextBackupTask() {
        let request = BGAppRefreshTaskRequest(identifier: chatBackupTaskIdentifier)
        //request.requiresNetworkConnectivity = true
        //request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: timeInterval)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule backup task: \(error)")
        }
    }


}

