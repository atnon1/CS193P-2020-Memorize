//
//  EmojiMemoryGameThemeChooser.swift
//  Memorize
//
//  Created by Anton Makeev on 13.01.2021.
//g

import SwiftUI

struct EmojiMemoryGameThemeChooser: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    @State var editMode: EditMode = .inactive
    @State var themeToEdit: EmojiMemoryGameTheme?
    
    var body: some View {
        NavigationView() {
            List {
                ForEach(store.emojiMemoryGameThemes) { theme in
                    ThemeListItemView(theme: theme, editMode: $editMode, themeToEdit: $themeToEdit)
                }
                .onDelete { indexSet in
                    for idx in indexSet.sorted(by: >) {
                        store.removeTheme(at: idx)
                    }
                }
            }
            .sheet(item: $themeToEdit) { theme in
                ThemeEditor(theme: theme)
                    .environmentObject(store)
            }
            .navigationTitle(Text(store.name))
            .navigationBarItems(leading: newThemeButton, trailing: EditButton())
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var newThemeButton: some View {
        Button( action: {
            store.addTheme()
        }, label: {
            Image(systemName: "plus").imageScale(.large)
        })
    }
}

struct ThemeListItemView: View {
    let theme: EmojiMemoryGameTheme
    @Binding var editMode: EditMode
    @Binding var themeToEdit: EmojiMemoryGameTheme?
    
    var body: some View {
        let viewModel = EmojiMemoryGame(theme: theme)
        return NavigationLink(
            destination: EmojiMemoryGameView(viewModel: viewModel)
                .navigationBarTitle(Text(theme.name))
        ) {
            HStack {
                if editMode.isEditing {
                    editorButton
                }
                listItemView
            }
            .shadow(color: textShadowColor, radius: textShadowRadius)
        }
        .listRowBackground(theme.color)
    }
    
    var editorButton: some View {
        Button(action: {
            themeToEdit = theme
        }, label: {
            Image(systemName: "pencil.circle.fill" )
            .imageScale(.large)
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    var listItemView: some View {
        VStack(alignment: .leading) {
            Text(theme.name).font(.largeTitle)
            Text("\(String(theme.cardPairsNumber)) pairs of \(theme.contentSet.joined())").font(.body)
                .lineLimit(1)
        }
    }
    
    // MARK: - Drawing variables. List item
    @Environment(\.colorScheme) var colorScheme
    // Improving visability of text depending on color scheme
    var textShadowColor: Color {
        colorScheme == .light ? .white : .black
    }
    let textShadowRadius: CGFloat = 1
}

struct ThemeEditor: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    @Environment(\.presentationMode) var presentationMode
    @State var emojisToAdd: String = ""
    @State var themeName: String = ""
    @State var cardPairsNumber = 0
    @State var theme: EmojiMemoryGameTheme {
        didSet {
            // Save and apply changes as they appear
            store.updateTheme(theme)
            cardPairsNumber = theme.cardPairsNumber
        }
    }
    
    @State var lowCardNumberAlert: Bool = false
    
    var body: some View {
        header
        Divider()
        Form {
            nameAndAddSection
            emojiRemoveSection
            if !theme.removedContent.isEmpty {
                emojiRestoreSection
            }
            cardsCountSection
            themeColorSection
        }.onAppear {
            themeName = theme.name
            cardPairsNumber = theme.cardPairsNumber
        }
        .alert(isPresented: $lowCardNumberAlert) {
            lowCardAlert
        }
    }
    
    var header: some View {
        ZStack {
            Text("Theme editor")
                .font(.largeTitle)
                .padding()
            HStack {
                Spacer()
                Button(
                    action: { presentationMode.wrappedValue.dismiss() },
                    label: { Text("Done") }
                )
                .padding()
            }
        }
    }
    
    var nameAndAddSection: some View {
        Section(header: Text("Name")) {
            TextField("Theme name", text: $themeName , onEditingChanged: { began in
                if !began {
                    theme.name = themeName
                }
            })
            .font(.headline)
            HStack{
                TextField("Add emojis", text: $emojisToAdd, onEditingChanged: { began in
                if !began {
                    theme.contentSet = (emojisToAdd.map {String($0)} + theme.contentSet).uniquied()
                    emojisToAdd = ""
                    }
                })
                Button(
                    action: {
                        theme.contentSet = (emojisToAdd.map {String($0)} + theme.contentSet).uniquied()
                        emojisToAdd = ""
                        UIApplication.shared.endEditing()
                    }, label: {
                        Text("Add")
                    }
                )
            }
        }
    }
    
    var emojiRemoveSection: some View {
        Section(header: Text("Remove emoji")) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: defaultEmojiFontSize))]) {
                ForEach(theme.contentSet.map { String($0) }, id: \.self) { item in
                    Text(item)
                        .font(Font.system(size: defaultEmojiFontSize))
                        .onTapGesture {
                            let newContent = theme.contentSet.filter { $0 != item }
                            if newContent.count >= minimumEmojiCount {
                                theme.contentSet = newContent
                            } else {
                                lowCardNumberAlert = true
                            }
                        }
                }
            }
        }
    }
    
    var emojiRestoreSection: some View {
        Section(header: Text("Restore removed emoji")) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: defaultEmojiFontSize))]) {
                ForEach(theme.removedContent.map { String($0) }, id: \.self) { item in
                    Text(item)
                        .font(Font.system(size: defaultEmojiFontSize))
                        .onTapGesture {
                            theme.contentSet.append(item)
                        }
                }
            }
        }
    }
        
    var cardsCountSection: some View {
        Section(header: Text("Cards count")) {
            Stepper(
                value: $cardPairsNumber,
                in:  2...theme.contentSet.count,
                onEditingChanged: { began in
                    if !began {
                        theme.cardPairsNumber = cardPairsNumber
                    }
                },
                label: {
                    Text("\(theme.cardPairsNumber) pairs")
                })
        }
    }
    
    var themeColorSection: some View {
        Section(header: Text("Theme color")) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: colorRectangleWidth))], spacing: colorGridSpacing) {
                ForEach(themeColors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: colorRectangleShapeRadius)
                        .fill(Color(color))
                        // Shows chosen color with stroke
                        .overlay(RoundedRectangle(cornerRadius: colorRectangleShapeRadius).stroke(colorRectangleStrokeColor, lineWidth: theme.colorRGB == color.rgb ? colorRectangleStrokeWidth : 0))
                        .aspectRatio(colorRectangleAspectRation, contentMode: .fit)
                        .onTapGesture {
                            theme.colorRGB = color.rgb
                        }
                }
            }
        }
    }
    
    var lowCardAlert: Alert {
        Alert(
             title: Text("Unable to remove"),
             message: Text("Theme should contain at least 2 emoji"),
             dismissButton: .default(Text("OK"))
        )
    }
    
    enum ThemeEditorAlert {
        case lowCardNumber
        case lowPairsNumber
    }
    
    // MARK: - Theme editor constants
    @Environment(\.colorScheme) var colorScheme
    let defaultEmojiFontSize: CGFloat = 40.0
    let minimumEmojiCount = 2
    let themeColors: [UIColor] = [.red,
        .blue,
        .gray,
        .green,
        .schoolBusYellow,
        .orange,
        .brown,
        .purple,
        .pink,
        .cyan,
    ]
    let colorRectangleShapeRadius: CGFloat = 10
    let colorRectangleStrokeWidth: CGFloat = 2
    var colorRectangleStrokeColor: Color {
        colorScheme == .dark ? .white : .black
    }
    let colorRectangleWidth: CGFloat = 50
    let colorRectangleAspectRation: CGFloat = 1
    let colorGridSpacing: CGFloat = 10
}




struct EmojiMemoryGameThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameThemeChooser()
    }
}
