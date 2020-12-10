//
//  MemoryGame.swift
//  Memorize
//
//  Created by Admin on 08.12.2020.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    
    var cards: Array<Card>

    var indexOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for idx in cards.indices {
                cards[idx].isFaceUp = idx == newValue
            }
        }
    }
      
    var score = 0
    
    // Turns `card` on another side and checks for match already opendd card;
    // counts score
    mutating func choose(_ card: Card) {
        print("Card chosen is: \(card)")
        if let matchingIndex = cards.firstIndex(matching: card), !cards[matchingIndex].isFaceUp, !cards[matchingIndex].isMatched {
            if let alreadyFaceUpCardIndex = indexOnlyFaceUpCard {
                if cards[matchingIndex].content == cards[alreadyFaceUpCardIndex].content {
                    cards[matchingIndex].isMatched = true
                    cards[alreadyFaceUpCardIndex].isMatched = true
                    score += 2
                }
                cards[matchingIndex].isFaceUp = true
                ifcards[matchingIndex].isFaceUp = 
            } else {
                indexOnlyFaceUpCard = matchingIndex
            }
        } else if let matchingIndex = cards.firstIndex(matching: card), cards[matchingIndex].isFaceUp {
                indexOnlyFaceUpCard = nil
        }
    }

    init(numberOfPairsOfCards: Int, makeCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = makeCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle() // Shuffles inline
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
