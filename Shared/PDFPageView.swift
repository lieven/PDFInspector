//
//  PDFPageView.swift
//  PDFInspector
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

struct PDFPageView: View {
	let document: CGPDFDocument
	let pageIndex: Int
	
	init(page: CGPDFDocument, pageIndex: Int) {
		self.document = document
		self.pageIndex = pageIndex
	}

    var body: some View {
		VStack(alignment: .leading) {
			PDFDictionaryView(document: document, page: pageIndex)
    	}
    	.navigationTitle("Page \(pageIndex)")
    }
}

struct PDFPageView_Previews: PreviewProvider {
    static var previews: some View {
    	NavigationView {
			PDFPageView(document: ContentView_Previews.testDocument.pdfDocument, page: 1)
		}
    }
}

