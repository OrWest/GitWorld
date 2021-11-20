//
//  DebugView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 14.11.21.
//

import SwiftUI

struct DebugView: View {
    enum Tab: Int, CaseIterable {
        case analyzer
        case world
        
        var name: String {
            switch self {
                case .analyzer: return "Analyzer"
                case .world: return "World"
            }
        }
    }
    
    @State var selectedTabIndex = 0
    var selectedTab: Tab { Tab(rawValue: selectedTabIndex)! }
    
    let context: AppContext
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTabIndex) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.name)
                        .tag(tab.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            switch selectedTab {
                case .analyzer:
                    StatsView(viewModel: RepoStatsViewModel(analyzer: context.analyzer))
                case .world:
                    WorldStatsView(viewModel: WorldStatsViewModel(world: context.world))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DebugView(context: .stub)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
        }
        .previewDevice("iPhone 11")
    }
}
