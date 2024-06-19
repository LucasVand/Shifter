//
//  ColorSelectorButton.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-03-26.
//

import SwiftUI

struct ColorSelectorButton: View {
    @Binding var colorTitles: [String]
    @Binding var mode: Int
    @Binding var colorSelected: Int
    @Binding var colorView: Bool
    @Binding var hapticsBool: Bool
    @Binding var levelCompleted: [[[[Bool]]]]
    @Binding var num: Int
    
    let colorData = ColorData()

    var body: some View {
        
        VStack {
            let numStars = 25
            
            let huh = num
            Text(colorTitles[huh])
                .foregroundColor(colorData.secondary[huh])
                .font(.system(size: 20, weight: .regular, design: .serif))
            
           // let backlog = colorTitles.count-6
            HStack {
                Button {
                    if ((num*numStars) - stars()) <= 0 {
                        colorSelected = num
                        colorView = false
                        simpleSuccess()
                    }
                } label: {
                    Rectangle()
                        .frame(width: 90, height: 90)
                        .foregroundColor(colorData.primary[num])
                        .cornerRadius(20)
                }.buttonStyle(ExitButtonSytle(colorSelected: Binding.constant(num)))
                    .overlay {
                        if ((num*numStars) - stars()) <= 0 {
                            Image(systemName: "star.fill")
                                .foregroundColor(colorData.secondary[num])
                        } else {
                            Image(systemName: "lock")
                                .foregroundColor(colorData.secondary[num])
                        }
                    }
                    .padding(20)
                
                Rectangle()
                    .frame(width: 90, height: 90)
                    .foregroundColor(colorData.primary[num])
                    .cornerRadius(20)
                    .modifier(ShadowSettings(ispressed: Binding.constant(true), colorSelected: Binding.constant(num)))
                    .scaleEffect(1.1)
                    .overlay {
                        if ((num*numStars) - stars()) <= 0 {
                            Image(systemName: "star.fill")
                                .foregroundColor(colorData.secondary[num])
                        } else {
                            Image(systemName: "lock")
                                .foregroundColor(colorData.secondary[num])
                        }
                        
                    }
                    .padding(20)
                
                
            }
            
            
            
        }
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


struct ColorSelectorButton_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectorButton(colorTitles: Binding.constant(["Ice White", "Ivery Cream", "Pale Pink", "Pale Mint", "Bisque", "Milk Choclate", "Dark Lavender", "Midnight Green", "Space Gray", "Midnight Blue"]) ,mode: Binding.constant(4), colorSelected: Binding.constant(0), colorView: Binding.constant(true), hapticsBool: Binding.constant(true), levelCompleted: Binding.constant(Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 2)), num: Binding.constant(0))
    }
}
