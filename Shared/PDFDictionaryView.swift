//
//  PDFDictionaryView.swift
//  PDFInspector
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

struct PDFDictionaryView: View {
	let dictionary: CGPDFDictionaryRef?
	let keys: [String]
	let values: [CGPDFDictionaryRef?]
	
	init(dictionary: CGPDFDictionaryRef?) {
		self.dictionary = dictionary
		
		var keys = [String]()
		var values = [CGPDFDictionaryRef?]()
		if let dictionary = dictionary {
			CGPDFDictionaryApplyBlock(dictionary, { (key, value, _) -> Bool in
				keys.append(String(cString: key))
				if case .dictionary = CGPDFObjectGetType(value) {
					var valueDict: CGPDFDictionaryRef? = nil
					if CGPDFObjectGetValue(value, .dictionary, &valueDict) {
						values.append(valueDict)
					} else {
						values.append(nil)
					}
				} else {
					values.append(nil)
				}
				return true
			}, nil)
		}
		self.keys = keys
		self.values = values
	}
	
	init(document: CGPDFDocument, page: Int) {
		self.init(dictionary: document.page(at: page)?.dictionary)
	}

	var body: some View {
    	List(0..<keys.count) { index in
    		NavigationLink(destination: PDFDictionaryView(dictionary: values[index])) {
				 Text(keys[index])
			}
		}
    }
}

struct PDFDictionaryView_Previews: PreviewProvider {
	static var testDict: CGPDFDictionaryRef? {
		return ContentView_Previews.testDocument.pdfDocument.page(at: 1)?.dictionary
	}

    static var previews: some View {
        PDFDictionaryView(dictionary: testDict)
    }
}
