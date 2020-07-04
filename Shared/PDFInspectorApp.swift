//
//  PDFInspectorApp.swift
//  Shared
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

@main
struct PDFInspectorApp: App {
    var body: some Scene {
        DocumentGroup(viewing: PDFInspectorDocument.self) { file in
            PDFDocumentView(document: file.$document)
        }
    }
}
