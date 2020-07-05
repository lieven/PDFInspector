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
    
    init(title: String, dictionary: PDFDictionary) {
        self.init(title: title, values: dictionary.values)
    }
    
    init(title: String, array: PDFArray) {
        let mapped = array.values.enumerated().map { return (key: "\($0)", value: $1) }
        self.init(title: title, values: mapped)
    }
    
    var body: some View {
        List(0..<values.count) { index in
            let (key, value) = values[index]
            
            switch value {
            case .dictionary(let dict):
                NavigationLink(destination: PDFCollectionView(title: key, dictionary: dict)) {
                    PDFValueCell(key: key, value: value.valuePreview)
                }
            case .array(let array):
                NavigationLink(destination: PDFCollectionView(title: key, array: array)) {
                    PDFValueCell(key: key, value: value.valuePreview)
                }
            default:
                PDFValueCell(key: key, value: value.valuePreview)
            }
        }
        .navigationTitle(title)
    }
}


struct PDFDictionaryView_Previews: PreviewProvider {
    static let testData: [(key: String, value: PDFObject)] = [
        (key: "String", value: .string("Value1")),
        (key: "Integer", value: .integer(1337)),
        (key: "Double 1", value: .real(1.0)),
        (key: "Double 2", value: .real(1.337)),
        (key: "Null", value: .null),
        (key: "Dictionary", value: .dictionary(PDFDictionary(nil)))
    ]
    
    static var previews: some View {
        NavigationView {
            PDFCollectionView(title: "Page 1 Dict", values: testData)
        }
    }
}



extension PDFObject {
    var valuePreview: String {
        switch self {
        case .null:
            return "NULL"
        case .boolean(let value):
            return value ? "true" : "false"
        case .integer(let value):
            return "\(value)"
        case .real(let value):
            return String(format: "%g", value)
        case .name(let value), .string(let value):
            return value
        case .array(let array):
            return array.valuePreview
        case .dictionary(let dictionary):
            return dictionary.valuePreview
        case .stream:
            return "Stream"
        }
    }
    
    var isComplex: Bool {
        switch self {
        case .null, .boolean, .integer, .real, .name, .string:
            return false
        case .array, .dictionary, .stream:
            return true
        }
    }
}

extension PDFArray {
    var valuePreview: String {
        guard isValid else {
            return "Invalid Array"
        }
        
        let values = self.values
        guard !values.contains(where: { $0.isComplex }) else {
            return "Array"
        }
        
        let valuePreviews = values.map { $0.valuePreview }
        return "[\(valuePreviews.joined(separator: ", "))]"
    }
}

extension PDFDictionary {
    var valuePreview: String {
        guard isValid else {
            return "Invalid Dictionary"
        }
        return "Dictionary"
    }
}
