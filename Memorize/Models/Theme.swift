//
//  Theme.swift
//  Memorize
//
//  Created by Anton Makeev on 15.12.2020.
//

import SwiftUI

// TODO: Move struct to another file. Fix init (move color, closer to the end)
struct MemoryGameTheme<Content:Codable & Equatable>: Codable, Identifiable {
    var name: String
    var id = UUID()
    var colorRGB: UIColor.RGB
    var color: Color {
        get { Color(colorRGB) }
        set { colorRGB = UIColor(newValue).rgb }
    }
    
    var contentSet: [Content] {
        didSet {
            var newRemoved = [Content]()
            for item in removedContent {
                if !contentSet.contains(item) {
                    newRemoved.append(item)
                }
            }
            for item in oldValue {
                if !contentSet.contains(item) {
                    newRemoved.append(item)
                }
            }
            removedContent = newRemoved.uniquied()
        }
        willSet {
            if newValue.count < cardPairsNumber {
                cardPairsNumber = newValue.count
            }
        }
    }
    
    var removedContent: [Content] = []
    var cardPairsNumber: Int
    init (_ name: String, contentSet: [Content], color: UIColor? = nil, cardPairsNumber: Int? = nil) {
        self.name = name
        self.colorRGB = color?.rgb ?? UIColor.gray.rgb
        self.contentSet = contentSet
        self.cardPairsNumber = cardPairsNumber ?? 6
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}


extension MemoryGameTheme where Content == String {
    
    // Initializes memory game theme with `String` type of `Content` theme decoding from `json`; returns nil if fails
    init?(json: Data?) {
        if json != nil, let theme = try? JSONDecoder().decode(MemoryGameTheme<String>.self, from: json!){
            self = theme
        } else {
            return nil
        }
    }
    
    static let initialEmojiThemes = [
        MemoryGameTheme("Halloween",
                        contentSet: ["👻","🎃","🕷","🕯","😨","😱","🌒","🧟‍♀️","🦇","☠️","⚰️","🩸","🔪","🕸","🧛🏻‍♂️"]
                        , color: .orange
        ),
        MemoryGameTheme("Sports",
                        contentSet: ["⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🏓","🏒","🥊","🚴‍♀️","🏊‍♀️","⛷","🏂","🏄‍♀️"],
                        color: .blue,
                        cardPairsNumber: 4
        ),
        MemoryGameTheme("Animals",
                        contentSet: ["🐶","🐱","🐭","🐹","🦊","🐻","🐷","🐮","🦁","🐯","🐨","🐼","🐵","🐧","🐣","🦉","🐗","🐴","🐺","🦑","🐙","🦩","🦥","🦨","🐿","🦔","🦃","🐏","🦙","🐐","🦌","🐓"]
                        , color: .schoolBusYellow
        ),
        MemoryGameTheme("Flags",
                        contentSet: ["🇦🇲","🇦🇷","🇦🇿","🇨🇴","🇨🇮","🇪🇬","🇪🇺","🇫🇮","🇫🇷","🇬🇷","🇬🇧","🏴󠁧󠁢󠁥󠁮󠁧󠁿","🇹🇷","🇺🇦","🏴󠁧󠁢󠁷󠁬󠁳󠁿","🇰🇷","🇯🇵","🇧🇬","🇨🇳","🇷🇺","🇧🇷","🇧🇪"],
                        cardPairsNumber: 7
        ),
        MemoryGameTheme("Happy New Year",
                        contentSet: ["🎅","🌟","❄️","⛄️","🎁","🍪","🥛","🎄","🤶","🎆","🥂","🕛",]
                        , color: .red
                        , cardPairsNumber: 3
        ),
        MemoryGameTheme("Fruits&Vegs",
                        contentSet: ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍈","🍒","🍑","🥭","🍍","🥥","🥝","🍅","🍆","🥑","🥦","🥬","🥒","🌶","🌽","🥕","🧄","🧅","🥔"]
                        , color: .green
        )
    ]
    
    static let newThemeTemplate =
        MemoryGameTheme("Untitled",
                        contentSet: ["😉","🙃"],
                        color: .red,
                        cardPairsNumber: 2
        )
}
