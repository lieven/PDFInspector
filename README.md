# PDFInspector

A simple SwiftUI app to browse through a PDF's page dictionaries.

## Why?

A PDF document contains metadata for each page. This metadata contains information about:
- page dimensions (and e.g. how to crop pages after print)
- annotations (including links)
- ...

How this metadata should be interpreted is defined in the [PDF Reference](https://www.adobe.com/devnet/pdf/pdf_reference.html)

When working with PDF documents coming from different sources, it can sometimes be useful to manually browse the page dictionaries.

## What?

PDF dictionaires contain key/value pairs, with the keys being character strings and values one of these types:
- integers
- booleans
- null
- strings
- names (which are simple strings)
- other dictionaries
- arrays of any of these types
- streams (which contain other types of data)

PDFInspector lets you browse through these dictionaries.
