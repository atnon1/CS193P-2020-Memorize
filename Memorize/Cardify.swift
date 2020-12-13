//
//  Cardify.swift
//  Memorize
//
//  Created by Anton Makeev on 12.12.2020.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool

    
    func body(content: Content) -> some View {
        ZStack{
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3.0
}

struct CardifyFilled<S: ShapeStyle>: ViewModifier {
    var isFaceUp: Bool
    var filling: S
    
    func body(content: Content) -> some View {
        ZStack{
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            } else {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(filling)
            }
        }
    }
    
    init(with filling: S, isFaceUp: Bool) {
        self.filling = filling
        self.isFaceUp = isFaceUp
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3.0
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
    func cardifyFilledWith<S: ShapeStyle>(_ filling: S, isFaceUp: Bool) -> some View {
        self.modifier(CardifyFilled(with: filling, isFaceUp: isFaceUp))
    }
}


