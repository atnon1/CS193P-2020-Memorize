//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Anton Makeev on 29.11.2020.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // We use statuc var to be able to check color to replace with gradient in View
    static var currentTheme: MemoryGameTheme<String>?
    
    private static func createMemoryGame() -> MemoryGame<String> {
        currentTheme = themes.randomElement()
        let theme = currentTheme!
        let emojis = theme.contentSet.shuffled()
        let pairsCount = theme.cardPairsNumber ?? Int.random(in: 2 ..< min(emojis.count, 14))
        return MemoryGame<String>(numberOfPairsOfCards: pairsCount ) { pairIndex in
                return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var timeSpent: Double {
        model.timeSpent
    }
    
    var score: Int {
        model.score
    }
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func resetGame() {
        self.model = EmojiMemoryGame.createMemoryGame()
    }
    
}

