//
//  PDFInspectorDocument.swift
//  Shared
//
//  Created by Lieven Dekeyser on 03/07/2020.
//

import SwiftUI
import UniformTypeIdentifiers

enum PDFObject {
    case null
    case boolean(Bool)
    case integer(Int)
    case real(CGFloat)
    case name(String)
    case string(String)
    case array(PDFArray)
    case dictionary(PDFDictionary)
    case stream(CGPDFStreamRef?)
    
    init?(_ object: CGPDFObjectRef) {
        switch CGPDFObjectGetType(object) {
        case .null:
            self = .null
        case .boolean:
            var value: Bool = false
            guard CGPDFObjectGetValue(object, .boolean, &value) else {
                return nil
            }
            self = .boolean(value)
        case .integer:
            var value: CGPDFInteger = 0
            guard CGPDFObjectGetValue(object, .integer, &value) else {
                return nil
            }
            self = .integer(value)
        case .real:
            var value: CGPDFReal = 0.0
            guard CGPDFObjectGetValue(object, .real, &value) else {
                return nil
            }
            self = .real(value)
        case .name:
            var value: UnsafePointer<Int8>?
            guard
                CGPDFObjectGetValue(object, .name, &value),
                let cString = value
            else {
                return nil
            }
            self = .name(String(cString: cString))
        case .string:
            var value: CGPDFStringRef?
            guard
                CGPDFObjectGetValue(object, .string, &value),
                let pdfString = value,
                let cfString = CGPDFStringCopyTextString(pdfString)
            else {
                return nil
            }
            self = .string(cfString as String)
        case .array:
            var value: CGPDFArrayRef?
            guard
                CGPDFObjectGetValue(object, .array, &value)
            else {
                return nil
            }
            self = .array(PDFArray(value))
        case .dictionary:
            var value: CGPDFDictionaryRef?
            guard
                CGPDFObjectGetValue(object, .dictionary, &value)
            else {
                return nil
            }
            self = .dictionary(PDFDictionary(value))
        case .stream:
            var value: CGPDFStreamRef?
            guard
                CGPDFObjectGetValue(object, .stream, &value),
                let stream = value
            else {
                return nil
            }
            self = .stream(stream)
        @unknown default:
            return nil
        }
    }
}


class PDFArray {
    private let arrayRef: CGPDFArrayRef?
    
    var isValid: Bool {
        return arrayRef != nil
    }
    
    lazy var values: [PDFObject] = {
        var values = [PDFObject]()
        if let arrayRef = arrayRef {
            CGPDFArrayApplyBlock(arrayRef, { (index, pdfObject, nil) -> Bool in
                if let object = PDFObject(pdfObject) {
                    values.append(object)
                }
                return true
            }, nil)
        }
        return values
    }()
    
    init(_ arrayRef: CGPDFArrayRef?) {
        self.arrayRef = arrayRef
    }
}


class PDFDictionary {
    private let dictionaryRef: CGPDFDictionaryRef?
    
    var isValid: Bool {
        return dictionaryRef != nil
    }
    
    lazy var values: [(key: String, value: PDFObject)] = {
        var results = [(key: String, value: PDFObject)]()
        if let dictionaryRef = dictionaryRef {
            CGPDFDictionaryApplyBlock(dictionaryRef, { (key, value, _) -> Bool in
                if let object = PDFObject(value) {
                    results.append((key: String(cString: key), value: object))
                }
                return true
            }, nil)
        }
        return results
    }()
    
    init(_ dictionaryRef: CGPDFDictionaryRef?) {
        self.dictionaryRef = dictionaryRef
    }
}


extension CGPDFDictionaryRef {
    var dictionaryValues: [(key: String, value: PDFObject)] {
        var results = [(key: String, value: PDFObject)]()
        CGPDFDictionaryApplyBlock(self, { (key, value, _) -> Bool in
            if let object = PDFObject(value) {
                results.append((key: String(cString: key), value: object))
            }
            return true
        }, nil)
        return results
    }
}

extension CGPDFArrayRef {
    var arrayValues: [(key: String, value: PDFObject)] {
        var values = [(key: String, value: PDFObject)]()
        CGPDFArrayApplyBlock(self, { (index, pdfObject, nil) -> Bool in
            if let object = PDFObject(pdfObject) {
                values.append((key: "\(index)", value: object))
            }
            return true
        }, nil)
        return values
    }
}

struct PDFInspectorDocument: FileDocument {
    private let pdfDocument: CGPDFDocument
    let name: String
    var numberOfPages: Int {
        return pdfDocument.numberOfPages
    }
    
    static var readableContentTypes: [UTType] { [.pdf] }
    
    init(fileWrapper: FileWrapper, contentType: UTType) throws {
        guard
            let data = fileWrapper.regularFileContents,
            let dataProvider = CGDataProvider(data: data as CFData),
            let pdfDocument = CGPDFDocument(dataProvider)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.name = fileWrapper.filename ?? "Untitled PDF"
        self.pdfDocument = pdfDocument
    }
    
    func pageDict(at index: Int) -> [(key: String, value: PDFObject)]? {
        guard
            let page = pdfDocument.page(at: index),
            let pdfDict = page.dictionary
        else {
            return nil
        }
        
        return pdfDict.dictionaryValues
    }
    
    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
        /* FIXME
         let data = text.data(using: .utf8)!
         fileWrapper = FileWrapper(regularFileWithContents: data)*/
    }
}
