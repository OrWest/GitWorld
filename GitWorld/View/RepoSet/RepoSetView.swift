//
//  RepoSetView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 1.11.21.
//

import Foundation
import SwiftUI

struct RepoSetView: View {
    @ObservedObject var viewModel: RepoSetViewModel
        
    @State var gitURL: String
    @State var errorToShow: RepoSetViewModel.Error?
    
    init(viewModel: RepoSetViewModel) {
        self.viewModel = viewModel
        if let url = viewModel.gitURLInSettings {
            gitURL = url
        } else {
            gitURL = ""
        }
    }
    
    private let buttonPadding: EdgeInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
    
    var body: some View {
        VStack {
            HStack {
                Text("Git").italic() +
                Text("World").bold()
            }
            .font(.largeTitle)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            TextField("URL", text: $gitURL)
                .textFieldStyle(.roundedBorder)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Button(action: pullPressed) {
                if viewModel.isCloning {
                    Text("Cancel")
                        .padding(buttonPadding)
                } else {
                    Text("Pull")
                        .padding(buttonPadding)
                }
                    
            }
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .alert(item: $errorToShow) { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .cancel())
            }
            if viewModel.isCloning {
                RepoCloneView(
                    cloneProgress: viewModel.cloneProgress,
                    clonedCount: viewModel.clonedCount,
                    toCloneCount: viewModel.toCloneCount
                )
            }
            if viewModel.isAnalyzing {
                RepoAnalyzeView(
                    progress: viewModel.analyzeProgress,
                    analyzedCount: viewModel.analyzedCount,
                    toAnalyzeCount: viewModel.toAnalyzeCount
                )
            }
        }
    }
    
    private func pullPressed() {
        if viewModel.isCloning {
            viewModel.cancelClone = true
        } else {
            do {
                try viewModel.pullNewGit(gitURL) { error in
                    self.errorToShow = error
                }
            } catch let error as RepoSetViewModel.Error {
                errorToShow = error
            } catch {
                print("Unknown error")
                assertionFailure()
            }
        }
    }
}

struct RepoSetView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSetView(viewModel: RepoSetViewModel.stub(cloning: true))
    }
}
