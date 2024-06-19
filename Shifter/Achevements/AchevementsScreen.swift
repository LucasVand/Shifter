//
//  AchevementsScreen.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

struct AchevementsScreen: View {
    @Binding var colorSelected: Int
    @Binding var mode: Int
    @Binding var levelComplete: [[[[Bool]]]]
    let colorData = ColorData()
    
    @State var scaling: [Bool] = Array(repeating: false, count: 30)
    
    let achevementNames: [String] = ["First Play","Area A","Area B","Area C","Area D","Area E","Area F","All Done", "Playing Blind", "Blind Area A", "Blind Area B", "Blind Area C", "Blind Area D", "Blind Area E", "Blind Area F"]
    let achevementDescriptions: [String] = ["Complete The First Level","Complete Area A", "Complete Area B", "Complete Area C", "Complete Area D", "Complete Area E", "Complete Area F","Complete All Levels", "Complete the First Blind Level", "Complete Blind Area A", "Complete Blind Area B", "Complete Blind Area C", "Complete Blind Area D", "Complete Blind Area E", "Complete Blind Area F"]
    @State var achevementDone: [Bool] = Array(repeating: false, count: 15)
    @State var achevementsCompleted: Int = 0
    @State var achevementSelected: [Bool] = [false,false,false]
    
    let playModes = ["Regular", "Blind"]


    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorData.primary[colorSelected])
                .ignoresSafeArea()

//            Circle()
//                .frame(width: 30, height: 30)
//                .offset(x: 140, y: -360)
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
                    
                    Text(String(achevementsCompleted)+"/"+String(achevementNames.count))
                        .font(.system(size: 50, weight: .bold, design: .serif))
                        .foregroundColor(colorData.secondary[colorSelected])
                        .padding(40)



                }
                
                ScrollView(showsIndicators: false) {
                    ForEach((0...14), id: \.self) { num in
                        Rectangle()
                            .frame(width: 300, height: 70)
                            .cornerRadius(17)
                            .foregroundColor(colorData.primary[colorSelected])
                            .modifier(Shadow(colorSelected: $colorSelected))
                            .padding(5)
                            .overlay {
                                HStack {
                                    Image(systemName: "trophy")
                                        .foregroundColor(colorData.secondary[colorSelected])
                                        .padding(.leading, 30.0)
                                    
                                    Spacer()
                                    VStack {
                                        Text(achevementNames[num])
                                            .foregroundColor(colorData.secondary[colorSelected])
                                        Text(achevementDescriptions[num])
                                            .font(.system(size: 13))
                                            .foregroundColor(colorData.secondary[colorSelected])
                                    }
                                    Spacer()
                                    
                                    Image(systemName: achevementDone[num] ? "checkmark.circle" : "circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(colorData.secondary[colorSelected])
                                        .padding(.trailing, 30.0)
                                    
                                }
                            }
                            .scaleEffect(scaling[num] ? 1 : 0)

                    }
                }
                Rectangle()
                    .ignoresSafeArea()
                    .frame(height: 10)
                    .foregroundColor(colorData.primary[colorSelected])
            }
        }.onAppear {
            checkingAchevements()
            for num in 0...1+achevementDone.count {
                withAnimation(.easeInOut.delay(Double(num)*0.04)) {
                    scaling[num] = true
                }
            }
        }
    }
    
    func checkingAchevements() {
        var count = 0
        //first play
        if levelComplete[0][0][0][0]  {
            achevementDone[0] = true
            achevementsCompleted += 1
        }
        
        //first blind
        if levelComplete[1][0][0][0]  {
            achevementDone[8] = true
            achevementsCompleted += 1
        }
        
        //area achevements
        
            for area in 0...5 {
                for row in 0...4 {
                    for col in 0...3 {
                        if levelComplete[0][area][row][col] {
                            count += 1
                        }
                    }
                }
                
                if count == 20 {
                    achevementDone[(area+1)] = true
                    achevementsCompleted += 1
                }
                count = 0
            }
        
        for area in 0...5 {
            for row in 0...4 {
                for col in 0...3 {
                    if levelComplete[1][area][row][col] {
                        count += 1
                    }
                }
            }
            
            if count == 20 {
                achevementDone[(area+1)+8] = true
                achevementsCompleted += 1
            }
            count = 0
        }
        
        
        //all done
        count = 0
        for page in 0...1 {
            for area in 0...5 {
                for row in 0...4 {
                    for col in 0...3 {
                        if levelComplete[page][area][row][col] {
                            count += 1
                        }
                    }
                }
            }
        }
        if count == 360 {
            achevementDone[7] = true
            achevementsCompleted += 1
        }
        
        
    }
}

struct ShadowAchevements: ViewModifier {
    @State var radius: CGFloat = 5
    @State var CornerRadius: CGFloat = 12
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

struct AchevementsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AchevementsScreen(colorSelected: Binding.constant(0), mode: Binding.constant(1), levelComplete: Binding.constant(Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 2)))
    }
}
