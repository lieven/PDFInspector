//
//  PDFDictionaryView.swift
//  PDFInspector
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

struct PDFCollectionView: View {
    let title: String
    let values: [(key: String, value: PDFObject)]
    
    init(title: String, values: [(key: String, value: PDFObject)]) {
        self.title = title
        self.values = values
    }
    
    init(title: String, dictionary: CGPDFDictionaryRef?) {
        self.init(title: title, values: dictionary?.dictionaryValues ?? [])
    }
    
    init(title: String, array: CGPDFArrayRef?) {
        self.init(title: title, values: array?.arrayValues ?? [])
    }
    
    var body: some View {
        List(0..<values.count) { index in
            let (key, value) = values[index]
            switch value {
            case .dictionary(let dict):
                NavigationLink(destination: PDFCollectionView(title: key, dictionary: dict)) {
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
            case .array(let array):
                NavigationLink(destination: PDFCollectionView(title: key, array: array)) {
                    PDFValueCell(key: key, value: "Array", enabled: false)
                }
            case .stream:
                PDFValueCell(key: key, value: "Stream", enabled: false)
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
    static let testData: [(key: String, value: PDFObject)] = [
        (key: "String Key", value: .string("Value1")),
        (key: "Integer Key", value: .integer(1337)),
        (key: "Null Key", value: .null),
        (key: "Dictionary Key", value: .dictionary(nil))
    ]
    
    static var previews: some View {
        NavigationView {
            PDFCollectionView(title: "Page 1 Dict", values: testData)
        }
    }
}

