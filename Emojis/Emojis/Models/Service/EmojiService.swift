//
//  EmojiService.swift
//  Emojis
//
//  Created by Tobias Lewinzon on 22/05/2024.
//

import Foundation

/// Implement this protocol to return custom (Data, URLResponse) tuple in Unit Tests.
protocol URLSessionProxy {
    func getData(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProxy {
    func getData(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: request)
    }
}


/// Class in charge fetching, saving and retrieving Emojis
class EmojiService {
    
    /// Emoji codable struct.
    private struct EmojiAPI: Codable {
        var category: String
        var unicode: [String]
        var name: String
    }
    
    /// Call this method to fetch Emojis from API. Returns whether saved Emojis are present after attempting the call.
    static func getEmojis(urlSession: URLSessionProxy = URLSession.shared) async -> Bool {
        guard let url = URL(string: "https://emojihub.yurace.pro/api/all") else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        await getEmojisFromAPI(request: request, urlSession: urlSession)
        return !Emoji.getAll().isEmpty
    }
    
    /// Performs API call and decodes into EmojiAPI.
    static private func getEmojisFromAPI(request: URLRequest, urlSession: URLSessionProxy) async {
        do {
            let (data, response) = try await urlSession.getData(for: request)
            
            // Retrieve status code.
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            let decoder = JSONDecoder()
            let object = try decoder.decode([EmojiAPI].self, from: data)
            
            print("Successfully decoded \(object.count) Emojis")
            
            saveEmojis(emojiAPI: object)
        } catch {
            print("Error in call: \(error.localizedDescription)")
        }
    }
    
    /// Saves Emoji and Category and sets up relationships.
    static private func saveEmojis(emojiAPI: [EmojiAPI]) {
        let context = PersistenceController.shared.getBackgroundContext()
        
        // Wipe tables. Cascade deletion rule will delete all Emoji as well.
        Category.deleteAll(context: context)
        
        emojiAPI.forEach { emojiAPI in
            // Create Category.
            guard let category = Category.getOrCreate(name: emojiAPI.category, context: context) else { return }
            category.name = emojiAPI.category
            
            // Create Emoji.
            let emoji = Emoji.create(context: context)
            emoji.unicode = NSSet(array: emojiAPI.unicode)
            emoji.name = emojiAPI.name
            
            // Setup relationships.
            emoji.category = category
            category.emojis.insert(emoji)
            
            context.saveAndThrow()
        }
        
        let allEmojis = Emoji.getAll(context: context)
        let allCategories = Category.getAll(context: context)
        
        print("Successfully saved \(allEmojis.count) Emojis into \(allCategories.count) categories")
    }
    
    static func getCachedEmojis() -> [Emoji] {
        return Emoji.getAll()
    }
}
