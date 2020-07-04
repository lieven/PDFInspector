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
        self.values = dictionary.map({ $0 }).sorted { $0.key > $1.key }
    }
    
    var body: some View {
        List(0..<values.count) { index in
            let (key, value) = values[index]
            if case .dictionary(let dict) = value {
                NavigationLink(destination: PDFDictionaryView(title: key, dictionary: dict.toDictionary)) {
                    Text(key)
                }
            } else {
                Text(key)
            }
        }
        //.navigationTitle(title)
    }
    
    
}

struct PDFDictionaryView_Previews: PreviewProvider {
    static var testDict: [String: PDFObject]? {
        return ContentView_Previews.testDocument.pageDict(at: 1)
    }
    
    static var previews: some View {
        PDFDictionaryView(title: "Page 1 Dict", dictionary: testDict ?? [:])
    }
}
