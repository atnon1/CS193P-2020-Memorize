//
//  UIApplicationExtension.swift
//  Memorize
//
//  Created by Anton Makeev on 16.01.2021.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
    }
}
