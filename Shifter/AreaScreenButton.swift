//
//  AreaScreenButton.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

struct AreaScreenButton: View {
    @Binding var selected: Int
    @Binding var mode: Int
    @Binding var colorSelected: Int
    @Binding var levelCompletedCount: [Int]
    @Binding var letters: [String]
    @Binding var levelCompleted: [[[Bool]]]
    var row: Int
    var col: Int
    
    var colorData = ColorData()
    var body: some View {
        Button {
            if whatsUnlocked(area: col*2+row) {
                selected = col*2+row
                mode = 2
            } else {
                
            }
        } label: {
            Rectangle()
                .frame(width: 100, height: 100)
                .cornerRadius(17)
                .foregroundColor(colorData.primary[colorSelected])
        }.buttonStyle(ExitButtonSytle(colorSelected: $colorSelected))
            .overlay {
                ZStack {

                    HStack (spacing: 0) {
                        Text("★")
                       Text(String(levelCompletedCount[col*2+row]) + "/20")
                    }
                        .offset(y: -65)
                        .font(.system(size: 10, weight: .light, design: .none))

                    if whatsUnlocked(area: col*2+row) {
                        Text(letters[col*2+row])
                            .font(.system(size: 30, weight: .regular, design: .serif))
                            .foregroundColor(colorData.secondary[colorSelected])
                    }
                    else {
                        Image(systemName: "lock")
                            .foregroundColor(colorData.secondary[colorSelected])
                            .font(.system(size: 25))
                    }
                }
            }
            .padding(10)
    }
    func whatsUnlocked(area: Int) -> Bool {
        if area == 0 {
            return true
        }
        let prevArea = area == 0 ? 0 : area-1
        var counts: Int = 0
              
        
        for row in 0...4 {
            for col in 0...3 {
                if levelCompleted[prevArea][row][col] {
                    counts += 1
                }
            }
        }
        if counts >= 4 {
            return true
        }
        else {
            return false
        }
        
    }
}

struct AreaScreenButton_Previews: PreviewProvider {
    static var previews: some View {
        AreaScreenButton(selected: Binding.constant(0), mode: Binding.constant(1), colorSelected: Binding.constant(0), levelCompletedCount: Binding.constant(Array(repeating: 0, count: 6)), letters: Binding.constant(["A","B","C","D","E","F","G"]), levelCompleted: Binding.constant(Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6)), row: 0, col: 0)
    }
}

