//
//  ViewController.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 28.10.21.
//

import UIKit

class ViewController: UIViewController {

    let remoteURL = URL(string: "https://github.com/OrWest/SwiftAsyncOp.git")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let repo = try! Repo(gitURL: remoteURL)
        
        print(123)
    }
}

