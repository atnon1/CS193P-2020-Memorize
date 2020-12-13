//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Anton Makeev on 29.11.2020.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
