//
//  PDFDictionaryView.swift
//  PDFInspector
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

struct PDFDictionaryView: View {
    let title: String
    let dictionary: [String: PDFObject]
    let values: [(key: String, value: PDFObject)]
        
        
    init(title: String, dictionary: [String: PDFObject]) {
        self.title = title
        self.dictionary = dictionary
        self.values = dictionary.map({ $0 }).sorted { $0.key < $1.key }
    }
    
    var body: some View {
        List(0..<values.count) { index in
            let (key, value) = values[index]
            switch value {
            case .dictionary(let dict):
                NavigationLink(destination: PDFDictionaryView(title: key, dictionary: dict?.toDictionary ?? [:])) {
                    PDFValueCell(key: key, value: "Dictionary", enabled: false)
                }
            case .string(let value), .name(let value):
                PDFValueCell(key: key, value: value)
            case .integer(let value):
                PDFValueCell(key: key, value: "\(value)")
            case .null:
                PDFValueCell(key: key, value: "NULL", enabled: false)
            case .boolean(let value):
                PDFValueCell(key: key, value: value ? "true" : "false")
            case .real(let value):
                PDFValueCell(key: key, value: "\(value)")
            case .array:
                PDFValueCell(key: key, value: "FIXME: Array", enabled: false)
            case .stream:
                PDFValueCell(key: key, value: "FIXME: Stream", enabled: false)
            }
        }
        .navigationTitle(title)
    }
}

struct PDFValueCell: View {
    let key: String
    let value: String
    let enabled: Bool
    
    init(key: String, value: String, enabled: Bool = true) {
        self.key = key
        self.value = value
        self.enabled = enabled
    }
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
                .foregroundColor(enabled ? Color.black : Color.gray)
        }
        .padding(EdgeInsets(top: 5.0, leading: 0.0, bottom: 5.0, trailing: 0.0))

    }
}


struct PDFDictionaryView_Previews: PreviewProvider {
    static let testData: [String: PDFObject] = [
        "String Key": .string("Value1"),
        "Integer Key": .integer(1337),
        "Null Key": .null,
        "Dictionary Key": .dictionary(nil)
    ]
    
    static var previews: some View {
        NavigationView {
            PDFDictionaryView(title: "Page 1 Dict", dictionary: testData)
        }
    }
}

