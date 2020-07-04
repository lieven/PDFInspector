//
//  PDFPageView.swift
//  PDFInspector
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

struct PDFPageView: View {
	let page: CGPDFPage?
	
	init(document: CGPDFDocument, page: Int) {
		self.page = document.page(at: page)
	}

    var body: some View {
        Text("Page \(page?.pageNumber ?? 0)")
    }
}

struct PDFPageView_Previews: PreviewProvider {
    static var previews: some View {
        PDFPageView(document: ContentView_Previews.testDocument.pdfDocument, page: 1)
    }
}

