//
//  CompletionScreen.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI


struct CompletionScreen: View {
    @State var y: Bool = false
    @Binding var selected: [Int]
    @Binding var gameOver: Bool
    @Binding var reset: Bool
    @Binding var mode: Int
    @Binding var colorSelected: Int
    let colorData = ColorData()


    var body: some View {
        ZStack (alignment: .bottom){
            Rectangle()
                .ignoresSafeArea()
                
                .opacity(0.5)
                
            
            Rectangle()
                .ignoresSafeArea()
                .frame(height: 300)
                .cornerRadius(50)
                .foregroundColor(colorData.primary[colorSelected])
                .overlay(content: {
                    VStack {
                        Text("Level Cleared!")
                            .foregroundColor(colorData.secondary[colorSelected])
                            .font(.system(size: 22))
                            .padding(10)

                        
                        Image(systemName: "star.fill")
                            .foregroundColor(colorData.secondary[colorSelected])

                            .font(.system(size: 30))
                            .padding(5)
                        
                        Button {
                            if selected[1] < 20 {
                                selected[1] += 1
                            } else {
                                mode = 2
                            }
                            print(selected[1])
                            reset.toggle()
                            gameOver = false
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 300, height: 100)
                                .foregroundColor(colorData.secondary[colorSelected])
                                .overlay {
                                    Text("To Next Level")
                                        .foregroundColor(colorData.primary[colorSelected])
                                }
                        }.buttonStyle(.plain)
                        .padding(20)

                    }
                    
                })
                .offset(y: y ? 50 : 300)
        }.onAppear {
            withAnimation(.linear(duration: 0.35)) {
                y = true
            }
        }

    }
}

struct CompletionScreen_Previews: PreviewProvider {
    static var previews: some View {
        CompletionScreen(selected: Binding.constant([0,0]), gameOver: Binding.constant(true), reset: Binding.constant(false), mode: Binding.constant(3), colorSelected: Binding.constant(0))
    }
}

