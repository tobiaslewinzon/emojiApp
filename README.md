# emojiApp
Emoji viewer app for Compass job application

## Instructions
- No pods or dependencies. Just open Emojis.xcodeproj and run or test!
- Needs Xcode 15.0+, since it uses NavigationStack and other modern SwiftUI components.

## Architechture and technical decisions
- Used MVVM. Because of the simplicity of the view heriarchy, only one view and view model seemed enough. 
- It's easily scalable by taking out the views configured in the switch statements within the ContentView into separate files.
- Coding challenges must be easy to setup for the reviewer. So no pods or dependencies are needed. Services are based on native URLSessions, URLRequests and async/await.
- The service is fully tested.
- The ViewModel isn't, could be good to test some error states, for example. Timing was against this.
- CoreData was used to allow for relationships and cache, which then easies up data grabbing by Category.
