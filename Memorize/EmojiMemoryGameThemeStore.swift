//
//  EmojiMemoryGameStore.swift
//  Memorize
//
//  Created by Anton Makeev on 13.01.2021.
//

import SwiftUI

class EmojiMemoryGameStore: ObservableObject {
    
    let name: String
    var storageKey: String {
        "EmojiMemoryGameThemes.\(name)"
    }
    
    @Published var emojiMemoryGameThemes = [EmojiMemoryGameTheme]() {
        didSet {
            UserDefaults.standard.set(
                emojiMemoryGameThemes.map { $0.json }
                , forKey: storageKey)
        }
    }
    
    subscript(themeID: UUID) -> Int? {
        for idx in emojiMemoryGameThemes.indices {
            if emojiMemoryGameThemes[idx].id == themeID {
                return idx
            }
        }
        return nil
    }    
    
    init(named name: String = "Emoji Memory Game") {
        self.name = name
        let themesJSONs = UserDefaults.standard.object(forKey: storageKey) as? [Data?] ?? []
        var themes = [EmojiMemoryGameTheme]()
        for json in themesJSONs {
            if let theme = EmojiMemoryGameTheme(json: json) {
                themes.append(theme)
            }
        }
        print(themes)
        self.emojiMemoryGameThemes = !themes.isEmpty ? themes : EmojiMemoryGameTheme.initialEmojiThemes
    }
    
    // MARK: - Intent(s)
    
    func addTheme() {
        emojiMemoryGameThemes.append(EmojiMemoryGameTheme.newThemeTemplate)
    }
    
    func updateTheme(_ theme: EmojiMemoryGameTheme) {
        if let idx = self[theme.id] {
            emojiMemoryGameThemes[idx] = theme
        }
    }
    
    func removeTheme(at idx: Int) {
        emojiMemoryGameThemes.remove(at: idx)
    }
    
}


