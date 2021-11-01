//
//  RepoSetView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 1.11.21.
//

import SwiftUI

struct RepoSetView: View {
    let viewModel: RepoSetViewModel
        
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
    
    var body: some View {
        VStack {
            TextField("URL", text: $gitURL)
                .textFieldStyle(.roundedBorder)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Button(action: pullPressed) {
                Text("Pull")
                    .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .alert(item: $errorToShow) { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .cancel())
            }
        }
    }
    
    private func pullPressed() {
        do {
            try viewModel.pullNewGit(gitURL)
        } catch let error as RepoSetViewModel.Error {
            errorToShow = error
        } catch {
            print("Unknown error")
            assertionFailure()
        }
    }
}

struct RepoSetView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSetView(viewModel: RepoSetViewModel())
    }
}
