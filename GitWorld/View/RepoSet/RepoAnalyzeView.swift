//
//  RepoAnalyzeView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 2021-11-08.
//

import SwiftUI

struct RepoAnalyzeView: View {
    @State var progress: Float
    @State var analyzedCount: Int
    @State var toAnalyzeCount: Int
    
    var body: some View {
        VStack {
            ProgressView("Analyze repo...", value: progress)
                .padding()
            Text("\(analyzedCount)/\(toAnalyzeCount)")
        }
    }
}

struct RepoAnalyzeView_Previews: PreviewProvider {
    static var previews: some View {
        RepoAnalyzeView(progress: 0, analyzedCount: 0, toAnalyzeCount: 0)
    }
}
