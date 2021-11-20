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
        
    @State private var gitURL: String
    @State private var errorToShow: RepoSetViewModel.Error?
    
    private var showCancel: Bool { viewModel.cloneProgress != nil || viewModel.analyzeProgress != nil }
    
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
                .disabled(showCancel)
            
            Button(action: buttonPressed) {
                if showCancel {
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
            if let progress = viewModel.cloneProgress {
                RepoProgressView(title: "Cloning...", progress: progress)
            }
            if let progress = viewModel.analyzeProgress {
                RepoProgressView(title: "Repo analyzing...", progress: progress)
            }
        }
    }
    
    private func buttonPressed() {
        if showCancel {
            viewModel.cancelProcess()
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
