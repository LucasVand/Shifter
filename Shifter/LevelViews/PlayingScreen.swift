//
//  PlayingScreen.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

import SwiftUI

struct PlayingScreen: View {
    @Binding var mode: Int
    @Binding var reset: Bool
    @Binding var layout: [[Int]]
    @Binding var selected: [Int]
    @Binding var levelComplete: [[[Bool]]]
    @Binding var diagnostics: Bool
    @Binding var letter: String
    @Binding var colorSelected: Int
    @Binding var hapticsBool: Bool
    @Binding var pages: CGFloat
    let colorData = ColorData()



    @State var firstMove: Int = 0
    
    @State var scaling: [Bool] = [false, false]
    @Binding var gameOver: Bool


    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorData.primary[colorSelected])
                .ignoresSafeArea()
            VStack {
                HStack {
                    if selected[1] == 1 && selected[0] == 0{
                        Text("Slide Tiles to capture tiles of different shapes, can you have one tile remaining?")
                            .font(.system(size: 12, weight: .bold, design: .serif))
                            .padding(40)
                            .foregroundColor(colorData.secondary[colorSelected])
                    }
                    if selected[1] == 1  && selected[0] == 1{
                        Text("Hollow tiles can't be moved but can be catured by any shape, can you have one tile Remaining?")
                            .font(.system(size: 12, weight: .bold, design: .serif))
                            .padding(40)
                            .foregroundColor(colorData.secondary[colorSelected])
                    }
                    if selected[1] == 1  && selected[0] == 2{
                        Text("Some Tiles are missing, huh? can you only have one tile remaining?")
                            .font(.system(size: 12, weight: .bold, design: .serif))
                            .padding(40)
                            .foregroundColor(colorData.secondary[colorSelected])
                    }
                    if selected[1] == 1  && selected[0] == 3{
                        Text("The Board is Bigger, huh? can you only have one tile remaining?")
                            .font(.system(size: 12, weight: .bold, design: .serif))
                            .padding(40)
                            .foregroundColor(colorData.secondary[colorSelected])
                    }
                    
                    Spacer()
                    
                    Text(letter + String(selected[1]))
                        .font(.system(size: 50, weight: .bold, design: .serif))
                        .padding(.vertical,selected[0] == 4 || selected[0] == 5 ? 10 : 50)
                        .padding(.horizontal, 50)
                        .foregroundColor(colorData.secondary[colorSelected])

                }

                MainBoard(mode: $mode, reset: $reset, layout: $layout, gameOver: $gameOver, selectedLevel: $selected, levelComplete: $levelComplete, diagnostics: $diagnostics, colorSelected: $colorSelected, letter: $letter, pages: $pages, firstMove: $firstMove)
                    .disabled(gameOver && !diagnostics)
                
                HStack {
                    Button {
                        simpleSuccess()
                        mode = 2
                    } label: {
                        Rectangle()
                            .frame(width: 70, height: 70)
                            .cornerRadius(20)
                            .foregroundColor(colorData.primary[colorSelected])
                    }.buttonStyle(ExitButtonSytle(colorSelected: $colorSelected))
                        .overlay {
                            Image(systemName: "arrow.left")
                                .foregroundColor(colorData.secondary[colorSelected])
                                .font(.system(size: 20))
                        }
                        .padding(.horizontal,35)
                        .scaleEffect(scaling[0] ? 1 : 0)
                    
                    Button {
                        reset.toggle()
                        simpleSuccess()
                        withAnimation() {
                            firstMove = 0
                        }
                    } label: {
                        Rectangle()
                            .frame(width: 70, height: 70)
                            .cornerRadius(20)
                            .foregroundColor(colorData.primary[colorSelected])
                        
                    }.buttonStyle(ExitButtonSytle(colorSelected: $colorSelected))
                        .overlay {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20))
                                .foregroundColor(colorData.secondary[colorSelected])

                        }
                        .padding(.horizontal,35)
                        .scaleEffect(scaling[1] ? 1 : 0)
                }
                .padding(.vertical, selected[0] == 4 || selected[0] == 5 ? 10 : 35)
            }
            if gameOver {
                CompletionScreen(selected: $selected, gameOver: $gameOver, reset: $reset, mode: $mode, colorSelected: $colorSelected)
            }
        }.onAppear {
            withAnimation(.easeInOut.delay(0.8)) {
                scaling[0] = true
            }
            withAnimation(.easeInOut.delay(0.9)) {
                scaling[1] = true
            }
            
        }
        
    }
    func simpleSuccess() {
        if hapticsBool {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.success)
        }
    }
    
}

struct ExitButtonSytle: ButtonStyle {
    @State var radius: CGFloat = 5
    @Binding var colorSelected: Int
    let colorData = ColorData()
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(color: colorData.BottomShadows[colorSelected], radius: configuration.isPressed ? 1 : radius/2, x: configuration.isPressed ? 1 : radius/2, y: configuration.isPressed ? 1 : radius/2)
            .shadow(color: colorData.TopShadows[colorSelected], radius: configuration.isPressed ? 1 : radius/2, x: configuration.isPressed ? -1 : -radius/2, y: configuration.isPressed ? -1 : -radius/2)
        
    }
        
}

struct PlayingScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayingScreen(mode: Binding.constant(3),reset: Binding.constant(false), layout: Binding.constant(Array(repeating: Array(repeating: 0, count: 4), count: 4)), selected: Binding.constant([1,1]), levelComplete: Binding.constant(Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6)), diagnostics: Binding.constant(true), letter: Binding.constant("A"), colorSelected: Binding.constant(0), hapticsBool: Binding.constant(true), pages: Binding.constant(0), gameOver: Binding.constant(false))
    }
}

