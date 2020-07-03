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
        DocumentGroup(newDocument: PDFInspectorDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
