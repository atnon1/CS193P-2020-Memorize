//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Anton Makeev on 29.11.2020.
//

import SwiftUI


// Declares alias globally to use in the whole project
typealias EmojiMemoryGameTheme = MemoryGameTheme<String>

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    
    var currentTheme: EmojiMemoryGameTheme?
    
    private static func createMemoryGame(theme: EmojiMemoryGameTheme?) -> MemoryGame<String> {
        let currentTheme = theme ?? EmojiMemoryGameTheme.initialEmojiThemes.randomElement()!
        let emojis = currentTheme.contentSet.shuffled()
        let pairsCount = currentTheme.cardPairsNumber
        let game = MemoryGame<String>(numberOfPairsOfCards: pairsCount ) { pairIndex in
                return emojis[pairIndex]
        }
        print("Theme json: \(currentTheme.json?.utf8 ?? "nil")")
        return game
    }
    
    init(theme: EmojiMemoryGameTheme? = nil) {
        currentTheme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
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
        model = EmojiMemoryGame.createMemoryGame(theme: currentTheme)
    }
    
}

