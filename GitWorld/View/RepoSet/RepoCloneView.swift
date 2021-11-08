//
//  RepoCloneView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 2021-11-08.
//

import SwiftUI

struct RepoCloneView: View {
    @State var cloneProgress: Float
    @State var clonedCount: Int
    @State var toCloneCount: Int
    
    var body: some View {
        VStack {
            ProgressView("Cloning...", value: cloneProgress)
                .padding()
            Text("\(clonedCount)/\(toCloneCount)")
        }
    }
}

struct RepoCloneView_Previews: PreviewProvider {
    static var previews: some View {
        RepoCloneView(cloneProgress: 0, clonedCount: 0, toCloneCount: 0)
    }
}
