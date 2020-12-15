//
//  Theme.swift
//  Memorize
//
//  Created by Anton Makeev on 15.12.2020.
//

import SwiftUI

// TODO: Move struct to another file. Fix init (move color, closer to the end)
struct MemoryGameTheme<Content> {
    var name: String
    var color: Color?
    var contentSet: [Content]
    var cardPairsNumber: Int?
    init (_ name: String, contentSet: [Content], color: Color? = nil, cardPairsNumber: Int? = nil) {
        self.name = name
        self.color = color
        self.contentSet = contentSet
        self.cardPairsNumber = cardPairsNumber
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
