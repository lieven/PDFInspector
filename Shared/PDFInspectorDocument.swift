//
//  PDFInspectorDocument.swift
//  Shared
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI
import UniformTypeIdentifiers


struct PDFInspectorDocument: FileDocument {
	let pdfDocument: CGPDFDocument
	let name: String?
	
    static var readableContentTypes: [UTType] { [.pdf] }

    init(fileWrapper: FileWrapper, contentType: UTType) throws {
        guard
        	let data = fileWrapper.regularFileContents,
        	let dataProvider = CGDataProvider(data: data as CFData),
        	let pdfDocument = CGPDFDocument(dataProvider)
        	else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.name = fileWrapper.filename
        self.pdfDocument = pdfDocument
    }
    
    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
    	/* FIXME
        let data = text.data(using: .utf8)!
        fileWrapper = FileWrapper(regularFileWithContents: data)*/
    }
}
