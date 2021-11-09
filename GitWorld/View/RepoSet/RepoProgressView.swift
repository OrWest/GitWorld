//
//  RepoProgressView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 2021-11-08.
//

import SwiftUI

struct RepoProgressView: View {
    @ObservedObject var progress: RepoSetViewModel.Progress
    let title: String
    
    init(title: String, progress: RepoSetViewModel.Progress) {
        self.title = title
        self.progress = progress
    }
    
    var body: some View {
        VStack {
            ProgressView(title, value: progress.progress)
                .padding()
            Text("\(progress.madeCount)/\(progress.amount)")
        }
    }
}

struct RepoCloneView_Previews: PreviewProvider {
    static var previews: some View {
        RepoProgressView(title: "Titititititit", progress: .init())
    }
}
