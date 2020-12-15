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
                    withAnimation(.linear(duration: cardFlipAnimationSpeed)){
                        viewModel.choose(card: card)
                    }
                }
                .aspectRatio(cardAspectRatio, contentMode: .fit)
                .padding(cardsPadding)
            }
            .padding(smallPadding)
            .foregroundColor( EmojiMemoryGame.currentTheme?.color ?? defaultColor)
            .layoutPriority(highPriority)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.resetGame()
                }
            }, label: {
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
                        RoundedRectangle(cornerRadius: buttonOuterCornerRadius)
                            .stroke(EmojiMemoryGame.currentTheme?.color ?? oppositeDefaultColor, lineWidth: buttonStrokeWidth)
                        )
                    .padding(.bottom)
            })
            .layoutPriority(lowPriority)
            .padding(.top, smallPadding)
        }
    }
    
    //MARK: - Drawing Constants
    
    let buttonCornerRadius: CGFloat = 40.0
    let buttonOuterCornerRadius: CGFloat = 50.0
    let buttonStrokeWidth: CGFloat = 5.0
    let buttonDrawPadding: CGFloat = 5.0
    let cardsPadding: CGFloat = 5.0
    let smallPadding: CGFloat = 2.0
    let highPriority: Double = 100.0
    let middlePriority: Double = 50.0
    let lowPriority: Double = 10.0
    let gradientColor = LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .top, endPoint: .trailing)
    @Environment(\.colorScheme) var colorScheme
    let cardFlipAnimationSpeed: Double = 0.75
    let cardAspectRatio: CGFloat = 4/5

}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        
        let cardView = ZStack {
            Group {
                if card.isConsumingBonusTime {
                    Group {
                        if EmojiMemoryGame.currentTheme?.color == nil {
                            Pie(startAngle: Angle.degrees(pieStartAngleDegrees + pieDegreesOffset), endAngle: Angle.degrees(-animatedBonusRemaining * pieFullEndAngleDegrees + pieDegreesOffset), clockWise: true)
                                .fill(gradientColor)
                        } else {
                            Pie(startAngle: Angle.degrees(pieStartAngleDegrees + pieDegreesOffset), endAngle: Angle.degrees(-animatedBonusRemaining * pieFullEndAngleDegrees + pieDegreesOffset), clockWise: true)
                        }
                    }
                    .onAppear {
                        self.startBonusTimeAnimation()
                    }
                } else {
                    Pie(startAngle: Angle.degrees(pieStartAngleDegrees + pieDegreesOffset), endAngle: Angle.degrees(-card.bonusRemaining * pieFullEndAngleDegrees + pieDegreesOffset), clockWise: true)
                }
            }
            .padding(piePadding)
            .opacity(pieOpacity)
            .transition(.identity)
            
            Text(card.content)
                .font(.system(size: fontSize(for: size)))
                .rotationEffect(Angle.degrees(card.isMatched ? cardMatchRotationDegree : cardDefaultRotationDegree))
                .animation(card.isMatched ? Animation.linear(duration: cardMatchAnimationDuration).repeatForever(autoreverses: false) : .default)
        }
        
        if card.isFaceUp || !card.isMatched {
            Group {
                if EmojiMemoryGame.currentTheme?.color == nil {
                    cardView
                        .cardify(withFilling: gradientColor, isFaceUp: card.isFaceUp)
                } else {
                    cardView
                        .cardify(isFaceUp: card.isFaceUp)
                }
            }
            .transition(AnyTransition.scale)
        }
    }
    
    //MARK: - Drawing Constants

    func fontSize(for size: CGSize) -> CGFloat {
        min(size.height, size.width) * 0.65
    }
    let gradientColor = LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .top, endPoint: .trailing)
    let pieStartAngleDegrees: Double = 0
    let pieFullEndAngleDegrees: Double = 360
    let pieDegreesOffset: Double = -90
    let pieOpacity: Double = 0.4
    let piePadding: CGFloat = 5.0
    let cardMatchRotationDegree: Double = 360
    let cardDefaultRotationDegree: Double = 0
    let cardMatchAnimationDuration: Double = 1
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
