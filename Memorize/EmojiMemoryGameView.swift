//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Admin on 29.11.2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text(EmojiMemoryGame.currentTheme?.name ?? "Memorize")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .font(.title)
                .layoutPriority(10)
            Text("Time: " + String(viewModel.timeSpent) + "s    ")
                .font(.title) +
            Text("Score: " + String(viewModel.score))
                .font(.title)
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
                //.aspectRatio(2/3, contentMode: .fit)
                .padding(5)
            }
            .padding()
            .foregroundColor( EmojiMemoryGame.currentTheme?.color ?? .black )
            .layoutPriority(10)
            
            Button(action: viewModel.startNewGame) {
                Text("New game")
                    .fontWeight(.bold)
                    .padding()
                    .background(EmojiMemoryGame.currentTheme?.color ?? .black)
                    .foregroundColor(.white)
                    .font(.title)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 5)
                        )
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(EmojiMemoryGame.currentTheme?.color ?? .black, lineWidth: 5)
                        )
                    .padding(.bottom)
            }
            .layoutPriority(10)
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                Text(card.content)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
            } else {
                if !card.isMatched {
                    if EmojiMemoryGame.currentTheme?.color == nil {
                        RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .top, endPoint: .trailing))
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                }
            }
        }
        //.aspectRatio(2/3, contentMode: .fill)
        .font(.system(size: fontSize(for: size)))
    }
    
    //MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3.0
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.height, size.width) * 0.75
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
