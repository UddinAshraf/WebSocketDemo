//
//  ViewController.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import UIKit
import RealmSwift
import OSLog

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }


    @IBAction func fetchMessage(_ sender: UIButton) {
        WebSocketManager.shared.connect()
    }
    
    @IBAction func uploadBackUp(_ sender: UIButton) {
          let queue = OperationQueue()
          queue.maxConcurrentOperationCount = 1
          let operation = BackupOperation()
          operation.completionBlock = {
              print("Backup operation completed.")
          }
          queue.addOperation(operation)
    }
    
    @IBAction func deleteMessage(_ sender: UIButton) {
        let realm = try! Realm()
         try? realm.write {
             let allMessages = realm.objects(ChatMessage.self)
             realm.delete(allMessages)
             Logger().info("Chat Messages is deleted")
         }
    }
  
}

