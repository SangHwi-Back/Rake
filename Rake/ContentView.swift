//
//  ContentView.swift
//  Rake
//
//  Created by 백상휘 on 5/4/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    
    @State var searchText: String = ""
    
    let scrape = WebScraper()

    var body: some View {
        NavigationSplitView {
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
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
                ToolbarItem {
                    Button("🧑‍🌾") {
                        Task {
                            await scrape()
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
        await scrape.scrapeWebPage(url: URL(string: "https://www.apple.com")!)
        print("ended!!!!")
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
