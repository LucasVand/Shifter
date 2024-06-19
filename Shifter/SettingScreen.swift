//
//  SettingScreen.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

struct SettingScreen: View {
    
    
    @Binding var mode: Int
    @Binding var levelComplete: [[[[Bool]]]]
    @Binding var diagnostics: Bool
    @Binding var colorSelected: Int
    @Binding var firstPlay: Bool
    @Binding var achevementString: [Bool]
    @Binding var hapticsBool: Bool
    @AppStorage("UNLOCKALL") var unlockAll: Bool = false
    
    @State var scaling: [Bool] = [false,false,false,false,false ]
    @State var isPressed: [Bool] = [false,false]
    let colorData = ColorData()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorData.primary[colorSelected])
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        mode = 0
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
                        .scaleEffect(scaling[0] ? 1 : 0)
                    
                    Spacer()
                }
                
                Rectangle()
                    .frame(width: 300, height: 70)
                    .cornerRadius(20)
                    .foregroundColor(colorData.primary[colorSelected])
                    .modifier(ShadowSettings(ispressed: $hapticsBool, colorSelected: $colorSelected))
                    .overlay {
                        HStack {
                            Spacer()
                            Text("Vibration")
                                .foregroundColor(colorData.secondary[colorSelected])
                            Spacer()

                            
                            Image(systemName: hapticsBool ? "circle.fill" : "circle")
                                .foregroundColor(colorData.secondary[colorSelected])
                                .padding(.horizontal,20)
                        }
                    }
                    .padding(5)
                    .onTapGesture {
                        simpleSuccess()
                        withAnimation(.easeInOut(duration: 1)) {
                            hapticsBool.toggle()
                        }
                    }
                    .scaleEffect(scaling[1] ? 1 : 0)
                
                Spacer()
                
                Button {
                    simpleWarning()
                    unlockAll = false
                    levelComplete = Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 2)
                    achevementString = Array(repeating: false, count: 15)
                    
                    firstPlay = true
                } label: {
                    Rectangle()
                        .frame(width: 300, height: 70)
                        .cornerRadius(20)
                        .foregroundColor(colorData.primary[colorSelected])
                }.buttonStyle(ExitButtonSytle(colorSelected: $colorSelected))
                    .overlay {
                        Text("Clear Data")
                            .foregroundColor(colorData.secondary[colorSelected])
                    }
                    .padding(5)
                    .scaleEffect(scaling[2] ? 1 : 0)
                
                Rectangle()
                    .frame(width: 300, height: 70)
                    .cornerRadius(20)
                    .foregroundColor(colorData.primary[colorSelected])
                    .modifier(ShadowSettings(ispressed: $diagnostics, colorSelected: $colorSelected))
                    .overlay {
                        HStack {
                            Spacer()
                            Text("Diagnostics")
                                .foregroundColor(colorData.secondary[colorSelected])
                            
                            Spacer()
                            Image(systemName: diagnostics ? "circle.fill" : "circle")
                                .foregroundColor(colorData.secondary[colorSelected])
                                .padding(.horizontal,20)

                        }
                    }
                    .padding(5)
                    .onTapGesture {
                            simpleWarning()
                            diagnostics.toggle()
                        
                    }
                    .scaleEffect(scaling[3] ? 1 : 0)
                
                Rectangle()
                    .frame(width: 300, height: 70)
                    .cornerRadius(20)
                    .foregroundColor(colorData.primary[colorSelected])
                    .modifier(ShadowSettings(ispressed: $unlockAll, colorSelected: $colorSelected))
                    .overlay {
                        HStack {
                            Spacer()
                            Text("Unlock Everything")
                                .foregroundColor(colorData.secondary[colorSelected])
                            Spacer()

                            
                            Image(systemName: unlockAll ? "circle.fill" : "circle")
                                .foregroundColor(colorData.secondary[colorSelected])
                                .padding(.horizontal,20)
                        }
                    }
                    .padding(5)
                    .onTapGesture {
                        unlockAll.toggle()
                        simpleWarning()
                        if unlockAll {
                            levelComplete = Array(repeating: Array(repeating: Array(repeating: Array(repeating: true, count: 4), count: 5), count: 6), count: 2)
                            achevementString = Array(repeating: true, count: 15)

                        } else {
                            levelComplete = Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 2)
                            achevementString = Array(repeating: false, count: 15)

                        }
                    }
                    .scaleEffect(scaling[4] ? 1 : 0)

                VStack {
                    Text("Credits")
                        .font(.system(size: 23))
                        .padding()
                    Text("Game Design - Lucas Vanderwielen")
                    Text("Game Production - Lucas Vanderwielen")
                }
                .foregroundColor(colorData.secondary[colorSelected])
                .padding()



            }
        }.onAppear {
            for num in 0...4 {
                withAnimation(.easeInOut.delay(Double(num)*0.2)) {
                    scaling[num] = true
                }
            }
        }
    }
    func simpleWarning() {
        if hapticsBool {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.error)
        }
    }
    func simpleSuccess() {
        if hapticsBool {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.success)
        }
    }
}
extension AnyTransition {
    static var ShadowButtonTransititon: AnyTransition {
        .asymmetric(insertion: .scale(scale: 0.9), removal: .scale(scale: 0.9))
        
    }
}

struct ShadowSettings: ViewModifier {
    @State var radius: CGFloat = 5
    @State var CornerRadius: CGFloat = 22
    @State var lineWidth: CGFloat = 5
    @Binding var ispressed: Bool
    @Binding var colorSelected: Int
    let colorData = ColorData()

    func body(content: Content) -> some View {
        if !ispressed {
            content
                .shadow(color: colorData.BottomShadows[colorSelected], radius: radius/2, x: radius/2, y:  radius/2)
                .shadow(color:colorData.TopShadows[colorSelected], radius:  radius/2, x:  -radius/2, y:  -radius/2)
                .transition(.ShadowButtonTransititon)
            
        } else {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius)
                        .stroke(colorData.primary[colorSelected], lineWidth: lineWidth)
                        .shadow(color: colorData.TopShadows[colorSelected], radius: 2, x: -3, y: -3)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius))
                        .shadow(color: colorData.BottomShadows[colorSelected], radius: 2, x: 3, y: 3)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius+2))
                    
                )
                .transition(.ShadowButtonTransititon)
                .scaleEffect(1.05)

        }
            
        }
    }

struct SettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        SettingScreen(mode: Binding.constant(4),levelComplete: Binding.constant(Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 2)), diagnostics: Binding.constant(false), colorSelected: Binding.constant(0), firstPlay: Binding.constant(false), achevementString: Binding.constant(Array(repeating: false, count: 8)), hapticsBool: Binding.constant(true))
    }
}

