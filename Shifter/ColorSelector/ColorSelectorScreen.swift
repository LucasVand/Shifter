//
//  ColorSelectorScreen.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

struct ColorSelectorScreen: View {
    @Binding var mode: Int
    @Binding var colorSelected: Int
    @Binding var colorView: Bool
    @Binding var hapticsBool: Bool
    @Binding var levelCompleted: [[[[Bool]]]]
    @State var colorTitles: [String] = ["Ice White", "Ivery Cream", "Pale Pink", "Pale Mint", "Bisque", "Milk Choclate", "Dark Lavender", "Midnight Green", "Space Gray", "Midnight Blue"]
    let colorData = ColorData()
    
    
    var body: some View {
        ZStack {
            
            let numStars = 25
            VStack {
                Rectangle()
                    .foregroundColor(colorData.primary[0])
                    .ignoresSafeArea()
                
                Rectangle()
                    .foregroundColor(colorData.primary[colorData.primary.count-1])
                    .ignoresSafeArea()
                
            }
            ScrollView {
                VStack (spacing: 0){
                    
                    ForEach((0...colorTitles.count-1), id: \.self) { num in
                         let what = num
                        Rectangle()
                            .frame(height: 250)
                            .foregroundColor(colorData.primary[num])
                            .overlay {
                                VStack {
                                    ColorSelectorButton(colorTitles: $colorTitles, mode: $mode, colorSelected: $colorSelected, colorView: $colorView, hapticsBool: $hapticsBool, levelCompleted: $levelCompleted, num: Binding.constant(num))
                                    
                                    if ((what*numStars) - stars()) > 0 {
                                        Text("★" + String((num*numStars)-stars()) + " Needed To Unlock")
                                            .foregroundColor(colorData.secondary[num])
                                            .font(.system(size: 13, weight: .bold, design: .serif))
                                    }
                                   // Text(String(stars()))

                                }
                            }
                    }
                }
            }
//            Button {
//                mode = 0
//            } label: {
//                Image(systemName: "x.circle.fill")
//                    .foregroundColor(.gray)
//                    .font(.system(size: 25))
//            }.frame(width: 320, height: 750,alignment: .topTrailing)
        }
            //.offset(y: offset)
    }
    func simpleSuccess() {
        if hapticsBool {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.success)
        }
    }
    
    func whatsUnlocked(area: Int) -> Bool {
        var counts: Int = 0
        if area > 5 || area < 0 {
            return true
        }
        
        for row in 0...4 {
            for col in 0...3 {
                if levelCompleted[0][area][row][col] {
                    counts += 1
                }
            }
        }
        if counts == 20 {
            return true
        }
        else {
            return false
        }
        
    }
    
    func stars() -> Int {
        var count = 0
        for page in 0...1 {
            for area in 0...5 {
                for row in 0...4 {
                    for col in 0...3 {
                        if levelCompleted[page][area][row][col] {
                            count += 1
                        }
                    }
                }
            }
        }
        return count
    }
    
}

struct ColorSelectorScreen_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectorScreen(mode: Binding.constant(4), colorSelected: Binding.constant(0), colorView: Binding.constant(true), hapticsBool: Binding.constant(true), levelCompleted: Binding.constant(Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 2)))
    }
}

