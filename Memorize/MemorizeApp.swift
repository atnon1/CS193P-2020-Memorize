//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Anton Makeev on 29.11.2020.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let store = EmojiMemoryGameStore(named: "Emoji Memory Game")
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameThemeChooser().environmentObject(store)
        }
    }
}
