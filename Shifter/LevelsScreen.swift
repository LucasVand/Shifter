//
//  LevelsScreen.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

struct LevelsScreen: View {
    @Binding var mode: Int
    @Binding var letter: String
    @Binding var levelComplete: [[Bool]]
    @Binding var selected1: Int
    @Binding var hapticsBool: Bool
    
    
    @State var scaling: [Bool] = Array(repeating: false, count: 22)
    @Binding var colorSelected: Int
    let colorData = ColorData()




    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorData.primary[colorSelected])
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    
                    Text(letter)
                        .font(.system(size: 50, weight: .bold, design: .serif))
                        
                        .padding(50)
                        .foregroundColor(colorData.secondary[colorSelected])

                }
                    Grid (horizontalSpacing: 15, verticalSpacing: 15){
                        ForEach((0...4), id: \.self) { col in
                            GridRow {
                                ForEach((0...3), id: \.self) { row in
                                    Button {
                                        selected1 = col*4+row+1
                                        mode = 3
                                    } label: {
                                        Rectangle()
                                            .frame(width: 65, height: 65)
                                            .cornerRadius(17)
                                            .foregroundColor(colorData.primary[colorSelected])
                                    }.buttonStyle(ExitButtonSytle(colorSelected: $colorSelected))
                                        .overlay {
                                            ZStack {
                                                if levelComplete[col][row] {
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(colorData.secondary[colorSelected])
                                                    
                                                } else {
                                                    Image(systemName: "smallcircle.filled.circle")
                                                        .foregroundColor(colorData.secondary[colorSelected])
                                                    
                                                }
                                            }
                                        }
                                        .scaleEffect(scaling[col*4+row] ? 1 : 0)
                                }
                            }
                        }
                    }
                HStack {
                    Button {
                        mode = 1
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
                        .padding(50)
                        .scaleEffect(scaling[21] ? 1 : 0)
                    
                    Button {
                        mode = 0
                        simpleSuccess()
                    } label: {
                        Rectangle()
                            .frame(width: 70, height: 70)
                            .cornerRadius(20)
                            .foregroundColor(colorData.primary[colorSelected])
                    }.buttonStyle(ExitButtonSytle(colorSelected: $colorSelected))
                        .overlay {
                            Image(systemName: "house")
                                .foregroundColor(colorData.secondary[colorSelected])
                                .font(.system(size: 20))
                        }.padding(50)
                        .scaleEffect(scaling[20] ? 1 : 0)
                    
                }
            }
        }.onAppear {
            for num in 0...21 {
                withAnimation(.easeInOut.delay(Double(num)*0.03)) {
                    scaling[num] = true
                }
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

struct LevelsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LevelsScreen(mode: Binding.constant(2), letter: Binding.constant("A"), levelComplete: Binding.constant(Array(repeating: Array(repeating: false, count: 4), count: 5)), selected1: Binding.constant(0), hapticsBool: Binding.constant(true), colorSelected: Binding.constant(0))
    }
}

