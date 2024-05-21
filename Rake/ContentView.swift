//
//  ContentView.swift
//  Rake
//
//  Created by 백상휘 on 5/4/24.
//

import SwiftUI
import SwiftData
import WebKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var searchText: String = ""
    
    @ObservedObject var scrape = WebScraper()

    var body: some View {
        NavigationSplitView {
            VStack {
                if let webView = scrape.webView {
                    WebViewContainer(view: webView)
                }
                
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem {
                        Button("🧑‍🌾") {
                            Task { await scrape() }
                        }
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .searchable(text: $searchText,
                    isPresented: Binding.constant(!items.isEmpty))
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func scrape() async {
        guard let url = URL(string: "https://www.naver.com") else { return }
        await scrape.scrapeWebPage(url: url)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct WebViewContainer: UIViewRepresentable {
    let view: WKWebView
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    func makeUIView(context: Context) -> WKWebView {
        view.frame = .zero
        return view
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
