//
//  MemoryGame.swift
//  Memorize
//
//  Created by Anton Makeev on 08.12.2020.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    
    private(set) var cards: Array<Card>

    private var indexOnlyFaceUpCard: Int? {
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
    var timeSpent: Double {
        if let startCounting = firstCardOpenTime {
            return startCounting.distance(to: Date())
        } else {
            return 0.0
        }
    }
    
    // Turns `card` on another side and checks for match already opened card;
    // counts score
    mutating func choose(_ card: Card) {
        print("Card chosen is: \(card)")
        if let matchingIndex = cards.firstIndex(matching: card), !cards[matchingIndex].isFaceUp, !cards[matchingIndex].isMatched {
            
            if let alreadyFaceUpCardIndex = indexOnlyFaceUpCard {
                
                // Checking for match
                if cards[matchingIndex].content == cards[alreadyFaceUpCardIndex].content {
                    cards[matchingIndex].isMatched = true
                    cards[alreadyFaceUpCardIndex].isMatched = true
                    /*switch timeSpent {
                    case 0.0...5.0:
                        score += Int((5.0 - timeSpent)/0.5)
                    case 5.0...10.0:
                        score += 1
                    default:
                        score -= 1
                    }*/
                    
                    // Linear dependance of bonus on the time
                    score += Int((Double(cards[matchingIndex].maxBonus) * cards[matchingIndex].bonusRemaining) + (Double(cards[alreadyFaceUpCardIndex].maxBonus) *  cards[alreadyFaceUpCardIndex].bonusRemaining))
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
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var haveAlreadyBeenSeen: Bool = false
        var content: CardContent
        var id: Int
        
        // Defines maximum bonus avaliable for a card
        var maxBonus: Int {
            Int(bonusTimeLimit)
        }
        // MARK: - Bonus Time
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
}
