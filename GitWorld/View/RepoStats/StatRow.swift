//
//  StatRow.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 30.10.21.
//

import SwiftUI

struct StatRow: View {
    var row: StatsViewModel.Row
    
    var body: some View {
        HStack {
            Text(row.text)
            Spacer()
            if let rightText = row.rightText {
                Text(rightText)
                    .bold()
            }
            if let name = row.imageName {
                Image(name)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
    }
}

struct StatRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatRow(row: StatsViewModel.Row(text: "Swift", imageName: "readme_icon", rightText: nil))
                .previewLayout(.fixed(width: 300, height: 70))
            StatRow(row: StatsViewModel.Row(text: "File name", imageName: nil, rightText: "11398"))
                .previewLayout(.fixed(width: 300, height: 70))
        }
    }
}