//
//  Theme.swift
//  Memorize
//
//  Created by Anton Makeev on 15.12.2020.
//

import SwiftUI

// TODO: Move struct to another file. Fix init (move color, closer to the end)
struct MemoryGameTheme<Content:Codable>: Codable {
    var name: String
    var colorRGB: UIColor.RGB
    var color: Color {
        return Color(colorRGB)
    }
    var contentSet: [Content]
    var cardPairsNumber: Int
    init (_ name: String, contentSet: [Content], color: UIColor? = nil, cardPairsNumber: Int? = nil) {
        self.name = name
        self.colorRGB = color?.rgb ?? UIColor.black.rgb
        self.contentSet = contentSet
        self.cardPairsNumber = cardPairsNumber ?? 6
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}

var themes = [
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
                    , color: .yellow
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
