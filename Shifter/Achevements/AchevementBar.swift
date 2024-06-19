//
//  AchevementBar.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

struct AchevementBar: View {
    
    let achevementTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Binding var colorSelected: Int
    @Binding var mode: Int
    @Binding var levelComplete: [[[[Bool]]]]
    @Binding var achevementSaving: [Bool]
    @Binding var hapticsBool: Bool
    @Binding var gameOver: Bool
    

    let colorData = ColorData()
    
    let achevementNames: [String] = ["First Play","Area A","Area B","Area C","Area D","Area E","Area F","All Done", "Playing Blind", "Blind Area A", "Blind Area B", "Blind Area C", "Blind Area D", "Blind Area E", "Blind Area F"]
    let achevementDescriptions: [String] = ["Complete The First Level","Complete Area A", "Complete Area B", "Complete Area C", "Complete Area D", "Complete Area E", "Complete Area F","Complete All Levels", "Complete the First Blind Level", "Complete Blind Area A", "Complete Blind Area B", "Complete Blind Area C", "Complete Blind Area D", "Complete Blind Area E", "Complete Blind Area F"]
    
    @State var achevementJustDone: Int = 0
    @State var iconScaling: [Bool] = [true,false]
    @State var barPosition: Bool = false
    @State var achevementJustDoneBool: Bool = false
    @State var animationGoing: Bool = false

    
    
    @AppStorage("AchevementSave") var achevementString = "false false false false false false false false false false false false false false false "




    var body: some View {
        ZStack {
            
            
            
            Rectangle()
                .frame(width: 300, height: 70)
                .cornerRadius(17)
                .foregroundColor(colorData.primary[colorSelected])
                .overlay {
                    RoundedRectangle(cornerRadius: 17)
                        .opacity(gameOver ? 0.5 : 0)
                }
                .shadow(radius: 5)
                //.modifier(Shadow(colorSelected: $colorSelected))
                .padding(5)
                .overlay {
                    HStack {
                        Image(systemName: "trophy")
                            .foregroundColor(colorData.secondary[colorSelected])
                            .padding(.leading, 30.0)
                        
                        Spacer()
                        VStack {
                            Text(achevementNames[achevementJustDone])
                                .foregroundColor(colorData.secondary[colorSelected])
                            Text(achevementDescriptions[achevementJustDone])
                                .font(.system(size: 13))
                                .foregroundColor(colorData.secondary[colorSelected])
                        }
                        Spacer()
                        
                        ZStack {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 20))
                                .foregroundColor(colorData.secondary[colorSelected])
                                .padding(.trailing, 30.0)
                                .scaleEffect(iconScaling[1] ? 1 : 0)
                            
                            
                            
                            Image(systemName: "circle")
                                .font(.system(size: 20))
                                .foregroundColor(colorData.secondary[colorSelected])
                                .padding(.trailing, 30.0)
                                .scaleEffect(iconScaling[0] ? 1 : 0)

                        }
                        
                    }
                    
                    
                }
                .offset(y: barPosition ? -330 : -600)
            
            

        }
        .onChange(of: achevementJustDoneBool) { newValue in
            if !animationGoing {
                CompletionAnimation()
            }
        }
        .onReceive(achevementTimer) { _ in
            checkingAchevements()
            saving()
            reading()
        }
        .onAppear {
            
            reading()
        }
    }
    func saving() {
        achevementString = ""
        for num in 0...achevementSaving.count-1 {
            if achevementSaving[num] {
                achevementString.append("true ")
            } else {
                achevementString.append("false ")

            }
        }
    }
    func reading() {
        let array = achevementString.components(separatedBy: " ")

        for num in 0...achevementSaving.count-1 {
            achevementSaving[num] = Bool(array[num]) ?? false
        }
//        print(achevementSaving.description)
//        print(achevementString)
    }
    func simpleSuccess() {
        if hapticsBool {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.success)
        }
    }
    
    func CompletionAnimation() {
        animationGoing = true
        iconScaling[0] = true
        iconScaling[1] = false
        let delay: Double = 0
        simpleSuccess()
        withAnimation(.easeInOut(duration: 0.4).delay(delay)) {
            barPosition = true
        }
        withAnimation(.easeInOut(duration: 0.3).delay(0.5+delay)) {
            iconScaling[0] = false
        }
        withAnimation(.easeInOut(duration: 0.3).delay(0.82+delay)) {
            iconScaling[1] = true
        }
        withAnimation(.easeInOut(duration: 0.4).delay(1.52+delay)) {
            barPosition = false
        }
        animationGoing = false
    }
    
    func checkingAchevements() {
        var count = 0
        //first play
        if levelComplete[0][0][0][0]  {
            if !achevementSaving[0] {
                achevementJustDoneBool.toggle()
            }

            achevementJustDone = 0
            achevementSaving[0] = true
        }
        
        //first blind
        if levelComplete[1][0][0][0]  {
            if !achevementSaving[8] {
                achevementJustDoneBool.toggle()
            }
            
            achevementJustDone = 8
            achevementSaving[8] = true
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
                if !achevementSaving[area+1] {
                    achevementJustDoneBool.toggle()
                }
                achevementJustDone = area+1
                achevementSaving[area+1] = true
            }
            count = 0
        }
        
        count = 0
        for area in 0...5 {
            for row in 0...4 {
                for col in 0...3 {
                    if levelComplete[1][area][row][col] {
                        count += 1
                    }
                }
            }
            
            if count == 20 {
                if !achevementSaving[area+1+8] {
                    achevementJustDoneBool.toggle()
                }
                achevementJustDone = 8+area+1
                achevementSaving[area+1+8] = true
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
            if !achevementSaving[7] {
                achevementJustDoneBool.toggle()
            }
            achevementJustDone = 7
            achevementSaving[7] = true
            
        }
        
        
    }
}

struct AchevementBar_Previews: PreviewProvider {
    static var previews: some View {
        AchevementBar(colorSelected: Binding.constant(0), mode: Binding.constant(0), levelComplete: Binding.constant(Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 2)), achevementSaving: Binding.constant(Array(repeating: false, count: 15)), hapticsBool: Binding.constant(true), gameOver: Binding.constant(true))
    }
}

