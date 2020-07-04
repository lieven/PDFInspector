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
	case array(CGPDFArrayRef)
	case dictionary(CGPDFDictionaryRef)
	case stream(CGPDFStreamRef)
	
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
				CGPDFObjectGetValue(object, .array, &value),
				let pdfArray = value
			else {
				return nil
			}
			/*
			
			*/
			self = .array(pdfArray)
		case .dictionary:
			var value: CGPDFDictionaryRef?
			guard
				CGPDFObjectGetValue(object, .dictionary, &value),
				let pdfDict = value
			else {
				return nil
			}
			/*
			var dict = [String: PDFObject]()
			CGPDFDictionaryApplyBlock(pdfDict, { (key, value, _) -> Bool in
				dict[String(cString: key)] = PDFObject(value)
				return true
			}, nil)*/
			self = .dictionary(pdfDict)
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

extension CGPDFDictionaryRef {
	var toDictionary: [String: PDFObject] {
		var results = [String: PDFObject]()
		CGPDFDictionaryApplyBlock(self, { (key, value, _) -> Bool in
			results[String(cString: key)] = PDFObject(value)
			return true
		}, nil)
		return results
	}
}

extension CGPDFArrayRef {
	var toArray: [PDFObject] {
		var array = [PDFObject]()
		CGPDFArrayApplyBlock(self, { (_, pdfObject, nil) -> Bool in
			if let object = PDFObject(pdfObject) {
				array.append(object)
			}
			return true
		}, nil)
		return array
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
    
    func pageDict(at index: Int) -> [String: PDFObject]? {
    	guard
    		let page = pdfDocument.page(at: index),
    		let pdfDict = page.dictionary
		else {
			return nil
		}
		
		return pdfDict.toDictionary
    }
    
    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
    	/* FIXME
        let data = text.data(using: .utf8)!
        fileWrapper = FileWrapper(regularFileWithContents: data)*/
    }
}
