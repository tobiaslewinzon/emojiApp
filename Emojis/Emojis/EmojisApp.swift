//
//  EmojisApp.swift
//  Emojis
//
//  Created by Tobias Lewinzon on 22/05/2024.
//

import SwiftUI

let persistenceController = PersistenceController.shared

@main
struct EmojisApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
