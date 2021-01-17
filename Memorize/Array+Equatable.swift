//
//  Array+Hashable.swift
//  Memorize
//
//  Created by Anton Makeev on 14.01.2021.
//

import Foundation

extension Array where Element: Equatable {
    func uniquied() -> [Element] {
        var buffer: [Element] = []
        for item in self {
            if !buffer.contains(item) {
                buffer.append(item)
            }
        }
        return buffer
    }
}
