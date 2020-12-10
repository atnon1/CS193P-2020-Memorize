//
//  Array+Only.swift
//  Memorize
//
//  Created by Admin on 05.12.2020.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
