//
//  Grid.swift
//  Memorize
//
//  Created by Admin on 05.12.2020.
//

import SwiftUI

struct Grid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            let layout = GridLayout(itemCount: items.count, in: geometry.size)
            ForEach(items) { item in
                let index = items.firstIndex(matching: item)!
                self.viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index))
            }
        }
    }
}
