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
                cards[idx].haveAlreadyBeenSeen = (cards[idx].haveAlreadyBeenSeen || cards[idx].isFaceUp)
                cards[idx].isFaceUp = idx == newValue
                if newValue != nil {
                    firstCardOpenTime = Date()
                } else {
                    firstCardOpenTime = nil
                }
            }
        }
    }
      
    var score = 0
    var firstCardOpenTime: Date?
    var timeSpent: Int {
        if let startCounting = firstCardOpenTime {
            return Int(startCounting.distance(to: Date()))
        } else {
            return 0
        }
    }
    
    // Turns `card` on another side and checks for match already opendd card;
    // counts score
    mutating func choose(_ card: Card) {
        print("Card chosen is: \(card)")
        if let matchingIndex = cards.firstIndex(matching: card), !cards[matchingIndex].isFaceUp, !cards[matchingIndex].isMatched {
            
            if let alreadyFaceUpCardIndex = indexOnlyFaceUpCard {
                
                // Checking for match
                if cards[matchingIndex].content == cards[alreadyFaceUpCardIndex].content {
                    cards[matchingIndex].isMatched = true
                    cards[alreadyFaceUpCardIndex].isMatched = true
                    score += max(-1, 10 - timeSpent)
                } else {
                    // If card at `idx` is faced up and have already been seen and not matched then reduce score
                        score -= (cards[alreadyFaceUpCardIndex].haveAlreadyBeenSeen ? 1 : 0)
                        score -= (cards[matchingIndex].haveAlreadyBeenSeen ? 1 : 0)
                }

                cards[matchingIndex].isFaceUp = true
            } else {
                indexOnlyFaceUpCard = matchingIndex
            }
            
        } else
        // If `card` already isFaceUp and not the only then turn all cards down
            if let matchingIndex = cards.firstIndex(matching: card), cards[matchingIndex].isFaceUp && indexOnlyFaceUpCard == nil {
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
        var haveAlreadyBeenSeen: Bool = false
        var content: CardContent
        var id: Int
    }
}
