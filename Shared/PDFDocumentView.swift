//
//  ContentView.swift
//  Shared
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

struct PDFDocumentView: View {
    @Binding var document: PDFInspectorDocument

    var body: some View {
		// FIXME NavigationView {
			List(1..<document.pdfDocument.numberOfPages+1) { page in
				NavigationLink(destination: PDFDictionaryView(document: document.pdfDocument, page: page)) {
					Text("Page \(page)")
				}
			}
		//	.navigationTitle(document.name ?? "test")
		//}
    }
}

struct ContentView_Previews: PreviewProvider {
	static var testDocument: PDFInspectorDocument {
		guard
			let url = Bundle.main.url(forResource: "Flyer", withExtension: "pdf"),
			let fileWrapper = try? FileWrapper(url: url, options: .immediate),
			let document = try? PDFInspectorDocument(fileWrapper: fileWrapper, contentType: .pdf)
		else {
			fatalError()
		}
		return document
	}

    static var previews: some View {
    	return PDFDocumentView(document: .constant(ContentView_Previews.testDocument))
    }
}

