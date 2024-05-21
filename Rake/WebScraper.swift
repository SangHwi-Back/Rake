//
//  WebScraper.swift
//  Rake
//
//  Created by 백상휘 on 5/4/24.
//

import UIKit
import WebKit

class WebScraper: NSObject, ObservableObject, WKScriptMessageHandler {
    @Published var webView: WKWebView?
    
    private(set) var htmlElements: WebScraperElement?
    
    func scrapeWebPage(url: URL) async {
        do {
            var request = URLRequest(url: url)
            request.addValue("application/xml", forHTTPHeaderField: "Accept")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let htmlString = String(data: data, encoding: .utf8) ?? ""
            
            if let url = Bundle.main.url(forResource: "core", withExtension: "js"),
                let jsCode = try? String(contentsOf: url, encoding: .utf8) {
                
                DispatchQueue.main.async { [jsCode, htmlString] in
                    let script = WKUserScript(source: jsCode, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
                    
                    let contentController = WKUserContentController()
                    contentController.addUserScript(script)
                    contentController.add(self, name: "getDOMTree")
                    
                    let webViewConfiguration = WKWebViewConfiguration()
                    webViewConfiguration.userContentController = contentController
                    
                    let webview = WKWebView(frame: .zero, configuration: webViewConfiguration)
                    webview.loadHTMLString(htmlString, baseURL: url)
                    webview.isInspectable = true
                    self.webView = webview
                }
            }
        } catch {
            fatalError("Error fetching HTML: \(error)")
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "getDOMTree":
            guard let htmlTags = message.body as? Dictionary<String, Any> else {
                return
            }
            
            func decode(_ htmlTags: Dictionary<String, Any>) -> WebScraperElement? {
                guard let tagName = htmlTags["name"] as? String,
                    let attributes = htmlTags["attribute"] as? Dictionary<String, String> else {
                    return nil
                }
                
                var element = WebScraperElement(tagName: tagName, attributes: attributes)
                
                if let children = htmlTags["children"] as? Array<Dictionary<String, Any>>, children.isEmpty == false {
                    for value in children {
                        if let children = decode(value) {
                            element.children.append(children)
                        }
                    }
                }
                
                return element
            }
            
            htmlElements = decode(htmlTags)
        default:
            return
        }
    }
}

struct WebScraperElement: Codable {
    let tagName: String
    var attributes: Dictionary<String, String> = .init()
    var children: [WebScraperElement] = []
}
