//
//  ContentView.swift
//  Emojis
//
//  Created by Tobias Lewinzon on 22/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                Task{
                    await getEmojis()
                }
            } label: {
                Text("Get emojis")
            }
        }
        .padding()
    }
    
    func getEmojis() async {
        let success = await EmojiService.getEmojis()
        _ = success ? print("Successfully fetched API or cached Emojis.") :
        print("Emoji called failed and there is no cached data.")
    }
}

#Preview {
    ContentView()
}
