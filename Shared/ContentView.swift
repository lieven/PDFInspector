//
//  ContentView.swift
//  Shared
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: PDFInspectorDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(PDFInspectorDocument()))
    }
}
