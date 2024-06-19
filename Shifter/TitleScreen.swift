//
//  TitleScreen.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//
import SwiftUI


struct TitleScreen: View {
    
    @Binding var mode: Int
    @State var scaling: [Bool] = [false,false,false]
    @Binding var colorSelected: Int
    @Binding var colorView: Bool
    @Binding var firstPlay: Bool
    @Binding var hapticsBool: Bool
    let colorData = ColorData()
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorData.primary[colorSelected])
                .ignoresSafeArea()
            VStack (){
           
                let size: CGFloat = 150
                Text("Shifter")
                    .font(.system(size: 50, weight: .bold, design: .serif))
                    .foregroundColor(colorData.secondary[colorSelected])
                Button {
//                    if !firstPlay {
//                        mode = 1
//                    } else {
//                        mode = 3
//                        firstPlay = false
//                    }
                    mode = 1
                    firstPlay = false
                    
                    simpleSuccess()
                    
                
                    
                    
                } label: {
                    Rectangle()
                        .frame(width: size, height: size)
                        .foregroundColor(colorData.primary[colorSelected])
                        .cornerRadius(50)
                }.buttonStyle(ExitButtonSytle(radius: 7, colorSelected: $colorSelected))
                    .overlay(content: {
                        Image(systemName: "play")
                            .font(.system(size: 30))
                            .foregroundColor(colorData.secondary[colorSelected])

                    })
                    .padding()
                    .scaleEffect(scaling[0] ? 1 : 0)
                Button {
                    simpleSuccess()
                    colorView = true
                } label: {
                    Rectangle()
                        .frame(width: size, height: size)
                        .foregroundColor(colorData.primary[colorSelected])
                        .cornerRadius(50)
                }.buttonStyle(ExitButtonSytle(radius: 7, colorSelected: $colorSelected))
                    .overlay(content: {
                        Image(systemName: "square.split.2x2")
                            .font(.system(size: 30))
                            .foregroundColor(colorData.secondary[colorSelected])

                    })
                    .padding()
                    .scaleEffect(scaling[1] ? 1 : 0)

                
                Button {
                   mode = 4
                    simpleSuccess()
                } label: {
                    Rectangle()
                        .frame(width: size, height: size)
                        .foregroundColor(colorData.primary[colorSelected])
                        .cornerRadius(50)
                }.buttonStyle(ExitButtonSytle(radius: 7, colorSelected: $colorSelected))
                    .overlay(content: {
                        Image(systemName: "gear")
                            .font(.system(size: 30))
                            .foregroundColor(colorData.secondary[colorSelected])

                    })
                    .padding()
                    .scaleEffect(scaling[2] ? 1 : 0)


            }
        }.onAppear {
            for num in 0...2 {
                withAnimation(.easeInOut(duration: 0.5).delay(Double(num)*0.2)) {
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

struct TitleScreen_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreen(mode: Binding.constant(0), colorSelected: Binding.constant(0), colorView: Binding.constant(false), firstPlay: Binding.constant(false), hapticsBool: Binding.constant(true))
    }
}

