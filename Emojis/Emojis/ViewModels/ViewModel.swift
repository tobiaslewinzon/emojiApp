//
//  ViewModel.swift
//  Emojis
//
//  Created by Tobias Lewinzon on 23/05/2024.
//

import Foundation

enum EmojiAppView {
    case home, data
}

struct CategoryRow: Hashable {
    var name: String
    var someUnicode: String
}

struct EmojiRow: Hashable {
    var index: Int
    var unicodes: [String]
}


class ViewModel: ObservableObject {
    @Published var isFetching = false
    @Published var showError = false
    @Published var hasFetched = false
    @Published var view: EmojiAppView = .home
    
    @Published var categories = [CategoryRow]()
    
    @MainActor
    func getEmojis() async {
        isFetching = true
        hasFetched = true
        let success = await EmojiService.getEmojis()
        _ = success ? print("Successfully fetched API or cached Emojis.") :
        print("Emoji called failed and there is no cached data.")
        showError = !success
        isFetching = false
        
        // Prepare categories now.
        prepareCategoryList()
        
        if hasFetched && !isFetching {
            view = .data
        }
    }
    
    private func prepareCategoryList() {
        for category in Category.getAll() {
            let emojis = category.emojis?.allObjects as? [Emoji] ?? []
            let unicodes = emojis.randomElement()?.unicode.allObjects as? [String] ?? []
            
            let cat = CategoryRow(name: category.name ?? "",
                                  someUnicode:  decodeUnicode(unicodes.first ?? ""))
            
            categories.append(cat)
        }
    }
    
    func prepareEmojiList(category: String) -> [EmojiRow] {
        var result = [EmojiRow]()
        // Get all emojis in chunks of 5. Some GeometryReader work could make the ammout dynamic as an enhancement.
        let emojis = Emoji.getByCategory(category: category)
        let chunks = emojis.chunked(into: 5)
        
        for (index, chunk) in chunks.enumerated() {
            let unicodes = chunk.map {$0.unicode.allObjects.first as? String ?? ""}
            let row = EmojiRow(index: index, unicodes: unicodes)
            result.append(row)
        }
        
        return result
    }
    
    /// Unicodes as they come from the API are unsable for Swift. This converts them to a format that can be then shown as Emojis.
    func decodeUnicode(_ code: String) -> String {
        guard code.hasPrefix("U+"),
              let number = Int(code.dropFirst(2), radix: 16),
              let scalar = Unicode.Scalar(number) else {
            return ""
        }
        return String(scalar)
    }
}
