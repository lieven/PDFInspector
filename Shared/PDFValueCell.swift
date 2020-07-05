//
//  PDFValueCell.swift
//  PDFInspector
//
//  Created by Lieven Dekeyser on 05/07/2020.
//

import SwiftUI

struct PDFValueCell: View {
    let key: String
    let value: String
    
    init(key: String, value: String, enabled: Bool = true) {
        self.key = key
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
                .lineLimit(1)
                .font(.footnote)
                .foregroundColor(Color.gray)
        }
        .padding(EdgeInsets(top: 5.0, leading: 0.0, bottom: 5.0, trailing: 0.0))

    }
}



struct PDFValueCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PDFValueCell(key: "Key", value: "Short Value", enabled: true)
            PDFValueCell(key: "Key", value: "Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you. But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass.", enabled: true)
        }
    }
}


