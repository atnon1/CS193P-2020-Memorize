//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Anton Makeev on 29.11.2020.
//

import SwiftUI

struct MemoryGameTheme<Content> {
    var name: String
    var color: Color?
    var contentSet: [Content]
    var cardPairsNumber: Int?
    init (_ name: String, color: Color?, contentSet: [Content], cardPairsNumber: Int? = nil) {
        self.name = name
        self.color = color
        self.contentSet = contentSet
        self.cardPairsNumber = cardPairsNumber
    }
}

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // Creates set of themes for MemoryGame
    private static var themes: [MemoryGameTheme<String>] {
        var themes = [MemoryGameTheme("Halloween", color: .orange, contentSet: ["👻","🎃","🕷","🕯","😨","😱","🌒","🧟‍♀️","🦇","☠️","⚰️","🩸","🔪","🕸","🧛🏻‍♂️"])]
        themes.append(MemoryGameTheme("Sports", color: .blue, contentSet: ["⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🏓","🏒","🥊","🚴‍♀️","🏊‍♀️","⛷","🏂","🏄‍♀️"], cardPairsNumber: 4))
        themes.append(MemoryGameTheme("Animals", color: .yellow, contentSet: ["🐶","🐱","🐭","🐹","🦊","🐻","🐷","🐮","🦁","🐯","🐨","🐼","🐵","🐧","🐣","🦉","🐗","🐴","🐺","🦑","🐙","🦩","🦥","🦨","🐿","🦔","🦃","🐏","🦙","🐐","🦌","🐓"]))
        themes.append(MemoryGameTheme("Flags", color: nil, contentSet: ["🇦🇲","🇦🇷","🇦🇿","🇨🇴","🇨🇮","🇪🇬","🇪🇺","🇫🇮","🇫🇷","🇬🇷","🇬🇧","🏴󠁧󠁢󠁥󠁮󠁧󠁿","🇹🇷","🇺🇦","🏴󠁧󠁢󠁷󠁬󠁳󠁿","🇰🇷","🇯🇵","🇧🇬","🇨🇳","🇷🇺","🇧🇷","🇧🇪"], cardPairsNumber: 7))
        themes.append(MemoryGameTheme("Happy New Year", color: .red, contentSet: ["🎅","🌟","❄️","⛄️","🎁","🍪","🥛","🎄","🤶","🎆","🥂","🕛",], cardPairsNumber: 3))
        themes.append(MemoryGameTheme("Fruits&Vegs", color: .green, contentSet: ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍈","🍒","🍑","🥭","🍍","🥥","🥝","🍅","🍆","🥑","🥦","🥬","🥒","🌶","🌽","🥕","🧄","🧅","🥔"]))
        return themes
    }
    
    static var currentTheme: MemoryGameTheme<String>?
    
    private static func createMemoryGame() -> MemoryGame<String> {
        currentTheme = themes[Int.random(in: 0..<themes.count)]
        let theme = currentTheme!
        let emojis = theme.contentSet.shuffled()  //TODO -move shuffle to model
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

