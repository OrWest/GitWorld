//
//  RepoSetViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 1.11.21.
//

import Foundation
import SwiftUI

class RepoSetViewModel {
    enum Error: String, LocalizedError, Identifiable {
        var id: String { self.rawValue }
        
        case emptyURL
        case invalidURL
        
        var errorDescription: String? {
            switch self {
                case .emptyURL:
                    return "Please, fill field with URL"
                case .invalidURL:
                    return "Invalid link. Check it starts with http or https"
            }
        }
    }
    
    @AppStorage(AppStorageKey.gitURL) var gitURLInSettings: String?
    
    func pullNewGit(_ url: String) throws {
        guard !url.isEmpty else {
            throw Error.emptyURL
        }
        
        guard let urlObject = URL(string: url),
              urlObject.scheme == "http" ||
                urlObject.scheme == "https"
        else {
            throw Error.invalidURL
        }
        
        gitURLInSettings = url
    }
}
