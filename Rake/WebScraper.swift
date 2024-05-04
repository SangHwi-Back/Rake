//
//  WebScraper.swift
//  Rake
//
//  Created by 백상휘 on 5/4/24.
//

import UIKit

class WebScraper: NSObject {
    func scrapeWebPage(url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parser = XMLParser(data: data)
            
            parser.delegate = self
            parser.parse()
            
            let parser2 = CustomXmlParser(xmlData: data)
            print(parser2?.dictionary)
            print("haha")
        } catch {
            fatalError("Error fetching HTML: \(error)")
        }
    }
}

extension WebScraper: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, localNamespaceURI: String?) {
        // Handle the start of an HTML element (e.g., <div>)
        print("Started parsing \(elementName)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Extract the desired data from the parsed HTML
        print("Extracted text: \(string)")
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("start")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("end")
    }
}
