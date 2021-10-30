//
//  ViewController.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 28.10.21.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    let remoteURL = URL(string: "https://github.com/OrWest/SwiftAsyncOp.git")!
    
    var contentView: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let repo = try! Repo(gitURL: remoteURL)
        let fileAnalyzer = RepoAnalyzer(localURL: repo.localURL)
        
        contentView = UIHostingController(rootView: StatsView(viewModel: StatsViewModel(repoTraits: fileAnalyzer.repoTraits)))
        
        addChild(contentView)
        view.addSubview(contentView.view)
        setupContraints()
    }
    
    private func setupContraints() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

