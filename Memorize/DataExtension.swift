//
//  DataExtension.swift
//  Memorize
//
//  Created by Anton Makeev on 08.01.2021.
//

import Foundation

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
