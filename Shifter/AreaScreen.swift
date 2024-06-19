//
//  AreaScreen.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

struct AreaScreen: View {
    @Binding var mode: Int
    @Binding var selected: Int
    @Binding var levelCompleted: [[[[Bool]]]]
    @Binding var hapticsBool: Bool
    
    
    @State var letters: [String] = ["A","B","C","D","E","F"]
    @State var scaling: [Bool] = Array(repeating: false, count: 9)
    @State var levelCompletedCount: [[Int]] = Array(repeating: Array(repeating: 0, count: 6),count: 3)
    
    @Binding var colorSelected: Int
    let colorData = ColorData()
    
    @Binding var pages: CGFloat 
    @State var pageMoveState: CGFloat = 0
    
    let pageCount = 1
    let playModes = ["Regular", "Blind"]
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack (spacing: 0) {
                    Text("★")
                        .font(.system(size: 50, weight: .bold, design: .none))
                    Text(totalStarCount())
                        .font(.system(size: 50, weight: .bold, design: .serif))
                    
                    
                    
                }
                .frame(width: 240, alignment: .trailing)
                .font(.system(size: 50, weight: .bold, design: .serif))
                .foregroundColor(colorData.secondary[colorSelected])
                
                .padding(30)
                
                //                Button("sub") {
                //                    withAnimation(.easeInOut) {
                //                        pages -= 1
                //                    }
                //                }
//                Text(String(Int(pages)))
                //
                //                Button("add") {
                //                    withAnimation(.easeInOut) {
                //                        pages += 1
                //                    }
                //                }
                
                
                
                ZStack {
                    ForEach((0...pageCount), id: \.self) { page in
                        ZStack {
                            VStack {
                                ForEach((0...2), id: \.self) { col in
                                    HStack {
                                        ForEach((0...1), id: \.self) { row in
                                            
                                            AreaScreenButton(selected: $selected, mode: $mode, colorSelected: $colorSelected, levelCompletedCount: $levelCompletedCount[page], letters: $letters, levelCompleted: $levelCompleted[page], row: row, col: col)
                                                .scaleEffect(scaling[col*2+row] ? 1 : 0)
                                                .padding(5)
                                            
                                        }
                                        
                                    }
                                }
                            }
                            Text(playModes[page])
                                .foregroundColor(colorData.secondary[colorSelected])
                                .font(.system(size: 20))
                                .bold()
                                .offset(y: -240)
                        }
                        .padding(.horizontal, 60)
                        .background(Color.black.opacity(0.00000001))
                        .offset(x: CGFloat(CGFloat(page * 400) + 400 * -pages))
                        .offset(x: pageMoveState)
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    
                                    pageMoveState = gesture.translation.width
                                    
                                    
                                })
                                .onEnded({ gesture in
                                    
                                    withAnimation(.easeOut) {
                                        if pageMoveState > 50 && pages != 0{
                                            pages -= 1
                                        }
                                        else if pageMoveState < -50 && pages != CGFloat(pageCount) {
                                            pages += 1
                                        }
                                                
                                                pageMoveState = 0
                                            }
                                        })
                                    
                                )
                            
                            
                            
                        
                    }
                    .padding(.top, 50)

                }
                let lightGray = Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                let darkGray = Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
                HStack {
                    ForEach((0...pageCount), id: \.self) { num in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(Int(pages) == num ? darkGray : lightGray)
                            
                    }
                }
                .scaleEffect(scaling[8] ? 1 : 0)

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
                        .padding(20)
                        .scaleEffect(scaling[6] ? 1 : 0)


                }
            }
        }.onAppear {
            countingLevels()
//            withAnimation(.easeInOut) {
//                scaling[7] = true
//            }
            for num in 0...7 {
                withAnimation(.easeInOut.delay(Double(num)*0.10)) {
                    scaling[num] = true
                }
            }
            
            withAnimation(.easeInOut.delay(0.8)) {
                scaling[8] = true
            }
        }
    }
    func countingLevels() {
        for page in 0...pageCount {
            for num in 0...5 {
                levelCompletedCount[page][num] = 0
                for col in 0...3 {
                    for row in 0...4 {
                        if levelCompleted[page][num][row][col] {
                            levelCompletedCount[page][num] += 1
                        }
                    }
                }
            }
        }
        }
    func totalStarCount() -> String {
        var count = 0
        for num in 0...1 {
            for wow in 0...5 {
                count += levelCompletedCount[num][wow]
            }
            
        }
        let temp = String(count)
        return temp
    }
    
    func simpleSuccess() {
        if hapticsBool {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.success)
        }
    }
    
    
    
}

struct AreaScreen_Previews: PreviewProvider {
    static var previews: some View {
        AreaScreen(mode: Binding.constant(1), selected: Binding.constant(0), levelCompleted: Binding.constant(Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 2)), hapticsBool: Binding.constant(true), colorSelected: Binding.constant(0), pages: Binding.constant(CGFloat(0)))
    }
}
