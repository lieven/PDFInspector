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
	
	init(title: String, dictionary: [String: PDFObject]) {
		self.title = title
		self.dictionary = dictionary
	}
	
	var body: some View {
		List {
			ForEach(dictionary.sorted(by: >), id: \.key) { key, value in
				switch value {
				case .dictionary(let dict):
					return NavigationLink(destination: PDFDictionaryView(title: key, dictionary: dict)) {
						Text(key)
					}
				default:
					return Text(key)
				}
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
