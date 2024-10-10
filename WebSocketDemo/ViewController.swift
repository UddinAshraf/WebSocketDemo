//
//  ViewController.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }


    @IBAction func fetchMessage(_ sender: UIButton) {
        WebSocketManager.shared.connect()
    }
}

