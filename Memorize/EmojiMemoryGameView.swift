//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Anton Makeev on 29.11.2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        let defaultColor: Color = (colorScheme == ColorScheme.dark ? .black : .white)
        let oppositeDefaultColor: Color = (colorScheme == ColorScheme.dark ? .white : .black)
        VStack {
            Text(EmojiMemoryGame.currentTheme?.name ?? "Memorize")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(smallPadding)
                .font(.title)
                .layoutPriority(lowPriority)
            
            (Text("Time: \(viewModel.timeSpent, specifier: "%.1f")s    ")
                .font(.title) +
            Text("Score: \(viewModel.score)")
                .font(.title)
                )
            .padding(smallPadding)
            .layoutPriority(lowPriority)
            
            
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
                .aspectRatio(4/5, contentMode: .fit)
                .padding(cardsPadding)
            }
            .padding(smallPadding)
            .foregroundColor( EmojiMemoryGame.currentTheme?.color ?? defaultColor)
            .layoutPriority(highPriority)
            
            Button(action: viewModel.startNewGame) {
                Text("New game")
                    .fontWeight(.bold)
                    .padding()
                    .background(EmojiMemoryGame.currentTheme?.color ?? oppositeDefaultColor)
                    .foregroundColor(defaultColor)
                    .font(.title)
                    .cornerRadius(buttonCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: buttonCornerRadius)
                            .stroke(defaultColor, lineWidth: buttonStrokeWidth)
                        )
                    .padding(buttonDrawPadding)
                    .overlay(
                        RoundedRectangle(cornerRadius: buttonCornerRadius+10)
                            .stroke(EmojiMemoryGame.currentTheme?.color ?? oppositeDefaultColor, lineWidth: buttonStrokeWidth)
                        )
                    .padding(.bottom)
            }
            .layoutPriority(lowPriority)
            .padding(.top, smallPadding)
        }
    }
    
    //MARK: - Drawing Constants
    
    let buttonCornerRadius: CGFloat = 40.0
    let buttonStrokeWidth: CGFloat = 5.0
    let buttonDrawPadding: CGFloat = 5.0
    let cardsPadding: CGFloat = 5.0
    let smallPadding: CGFloat = 2.0
    let highPriority: Double = 100.0
    let middlePriority: Double = 50.0
    let lowPriority: Double = 10.0
    let gradientColor = LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .top, endPoint: .trailing)
    @Environment(\.colorScheme) var colorScheme
 //   var defaultColor: Color? = (colorScheme == ColorScheme.dark ? .white : .black)
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        
        let cardView = ZStack {
            if EmojiMemoryGame.currentTheme?.color == nil {
                pieCounter
                    .fill(gradientColor)
                    .padding(piePadding)
                    .opacity(pieOpacity)
            } else {
                pieCounter
                    .padding(piePadding)
                    .opacity(pieOpacity)
            }
            Text(card.content)
                .font(.system(size: fontSize(for: size)))
        }
        
        if card.isFaceUp || !card.isMatched {
            if EmojiMemoryGame.currentTheme?.color == nil {
                cardView
                    .cardifyFilledWith(gradientColor, isFaceUp: card.isFaceUp)
            } else {
                cardView
                    .cardify(isFaceUp: card.isFaceUp)
            }
        }
    }
    
    //MARK: - Drawing Constants

    func fontSize(for size: CGSize) -> CGFloat {
        min(size.height, size.width) * 0.65
    }
    let gradientColor = LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .top, endPoint: .trailing)
    private(set) var pieCounter = Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockWise: true)
    let pieOpacity = 0.4
    let piePadding: CGFloat = 5.0
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
