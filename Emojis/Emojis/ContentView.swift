//
//  ContentView.swift
//  Emojis
//
//  Created by Tobias Lewinzon on 22/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        
        switch viewModel.view {
        case .home:
            // Simple home view, with Fetch button, loading and error UI:
            VStack {
                if viewModel.isFetching {
                    HStack(spacing: 8) {
                        Text("Fetching")
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                } else {
                    Button {
                        Task {
                            await viewModel.getEmojis()
                        }
                    } label: {
                        Text("Fetch Emojis")
                            .font(.title)
                    }
                }
                
                if viewModel.showError {
                    Text("API call failed and there is no cached data.")
                        .foregroundColor(.red)
                }
            }
        case .data:
            // Simple data section with a NavigationStack
            NavigationStack {
                // Initial view is just a list of Categories.
                List {
                    ForEach(viewModel.categories, id: \.name) { category in
                        let name = category.name
                        let emoji = category.someUnicode
                        
                        NavigationLink(value: category) {
                            HStack {
                                Text(name)
                                // Add a random emoji as preview.
                                Text(String(emoji))
                            }
                        }
                    }
                    
                }
                .navigationTitle("Categories")
                .navigationDestination(for: CategoryRow.self) { category in
                    // Destination views are a grid of emojis.
                    let dataToDisplay = viewModel.prepareEmojiList(category: category.name)
                    
                    // Let's make it scrollable.
                    ScrollView(.vertical) {
                        // A vertical stack of horizontal stacks.
                        LazyVStack(spacing: 20) {
                            ForEach(dataToDisplay, id: \.index) { row in
                                HStack(spacing: 20) {
                                    ForEach(row.unicodes, id: \.self) { unicode in
                                        Text(viewModel.decodeUnicode(unicode))
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle(category.name)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
