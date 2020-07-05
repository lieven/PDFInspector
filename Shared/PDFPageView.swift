//
//  PDFPageView.swift
//  PDFInspector
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

struct PDFPageView: View {
	let document: PDFInspectorDocument
	let pageIndex: Int
	
	init(document: PDFInspectorDocument, pageIndex: Int) {
		self.document = document
		self.pageIndex = pageIndex
	}

    var body: some View {
		VStack(alignment: .leading) {
			PDFCollectionView(title: "Page \(pageIndex) Dict", values: document.pageDict(at: pageIndex) ?? [])
    	}
    	.navigationTitle("Page \(pageIndex)")
    }
}

struct PDFPageView_Previews: PreviewProvider {
    static var previews: some View {
    	NavigationView {
			PDFPageView(document: ContentView_Previews.testDocument, pageIndex: 1)
		}
    }
}

