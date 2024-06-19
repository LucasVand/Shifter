//
//  MainBoard.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI

extension AnyTransition {
    static var Good: AnyTransition {
        .scale(scale: 0.0)//.animation(Animation.easeInOut(duration: 0.1))
        
    }
}
//extension Animation {
//    static var anit: Animation {
//
//    }
//}
struct ShakeR: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 2
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
            ProjectionTransform(CGAffineTransform(translationX:
                                                    amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                                  y: 0))
        }
}

struct ShakeU: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 2
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
            ProjectionTransform(CGAffineTransform(translationX: 0 ,
                                                  y: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))))
            
        }
}
struct Rotation: GeometryEffect {
    var amount: CGFloat = 0.7
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {

        
//        ProjectionTransform(CGAffineTransformRotate(CGAffineTransformMakeRotation(), amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))))

        let transform = CGAffineTransform(translationX: size.width/2, y: size.width/2)
            .rotated(by: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)))
            .translatedBy(x: -size.width/2, y: -size.width/2)
        
            return ProjectionTransform(transform)
        }
}



struct MainBoard: View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    let levelData = LevelData()

    @State var shape: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 8)
    @State var scale: [[Double]] = Array(repeating: Array(repeating: 1, count: 4), count: 8)
    @State var shakeU: [[CGFloat]] = Array(repeating: Array(repeating: 0, count: 4), count: 8)
    @State var shakeR: [[CGFloat]] = Array(repeating: Array(repeating: 0, count: 4), count: 8)
    @State var rotation: CGFloat = 0
    @State var test: Bool = false
    
    
    @State var trigger: Bool = false

    @State var spin: Double = 1


    @State var selected = [0,0]
    @State var count = 0

    @Binding var mode: Int
    @Binding var reset: Bool
    @Binding var layout: [[Int]]
    @Binding var gameOver: Bool
    @Binding var selectedLevel: [Int]
    @Binding var levelComplete: [[[Bool]]]
    @Binding var diagnostics: Bool
    @Binding var colorSelected: Int
    @Binding var letter: String
    @Binding var pages: CGFloat

    @State var boardHeight: Int = 7
    
    @Binding var firstMove: Int
    
  


    
    @State var scaling: [Bool] = Array(repeating: false, count: 32)
    @State var LevelCodeString: String = "s"
    let colorData = ColorData()



    

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(colorData.primary[colorSelected])
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(colorData.primary[colorSelected], lineWidth: 5)
                        .shadow(color: colorData.TopShadows[colorSelected], radius: 2, x: -3, y: -3)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(color: colorData.BottomShadows[colorSelected], radius: 2, x: 3, y: 3)
                        .clipShape(RoundedRectangle(cornerRadius: 30+2))
                )
                .frame(width: 350, height: 50+75*CGFloat(boardHeight))
                .overlay {
                    
                    Grid (horizontalSpacing: 15, verticalSpacing: 15){
                        ForEach((0...boardHeight-1), id: \.self) { col in
                            GridRow {
                                ForEach((0...3), id: \.self) { row in
                                    Rectangle()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(17)
                                        .foregroundColor(colorData.primary[colorSelected])
//                                        .modifier(ShadowSettings(ispressed: shape[col][row] == 4 ? Binding.constant(true) : Binding.constant(false), colorSelected: $colorSelected))
                                        .overlay(content: {
                                            ZStack {
                                                //Text(String(shape[col][row]))
                                                
                                                    if shape[col][row] == 1 {
                                                        if pages == 1 && firstMove != 0 && shape[col][row] != 0 {
                                                            
                                                            Text("?")
                                                                .font(.system(size: 30))
                                                                .modifier(Rotation(animatableData: rotation))
                                                                .transition(.Good)
                                                        } else {
                                                            Image(systemName: "square.fill")
                                                                .font(.system(size: 30))
                                                                .modifier(Rotation(animatableData: rotation))
                                                                .transition(.Good)
                                                        }
                                                        
                                                        
                                                    } else if shape[col][row] == 2 {
                                                        if pages == 1 && firstMove != 0 && shape[col][row] != 0 {
                                                            
                                                            Text("?")
                                                                .font(.system(size: 30))
                                                                .modifier(Rotation(animatableData: rotation))
                                                                .transition(.Good)
                                                        } else {
                                                            Image(systemName: "triangle.fill")
                                                                .font(.system(size: 30))
                                                                .modifier(Rotation(animatableData: rotation))
                                                                .transition(.Good)
                                                        }
                                                        
                                                    } else if shape[col][row] == 3 {
                                                        Image(systemName: "viewfinder")
                                                            .font(.system(size: 34))
                                                            .modifier(Rotation(animatableData: rotation))
                                                            .transition(.Good)
                                                    
                                                }
                                               
                                            }                                        .foregroundColor(colorData.secondary[colorSelected])

                                        })
                                        .modifier(ShakeU(animatableData: shakeU[col][row]))
                                        .scaleEffect(scaling[col*4+row] ? 1 : 0)
                                        .modifier(Rotation(animatableData: rotation))
                                        .rotationEffect(Angle.degrees(360*spin))
                                        .modifier(Shadow(colorSelected: $colorSelected))

                                        .opacity(shape[col][row] == 4 ? 0.01 : 1)
                                       
                                    
                                        .onTapGesture(count: 1, perform: {
                                            if diagnostics {
                                                if shape[col][row] == 4 {
                                                    shape[col][row] = 0
                                                }
                                                shape[col][row] += 1

                                                isDone()
                                            }
                                        })
                                        

                                        .onLongPressGesture {
                                            if diagnostics {
                                                shape[col][row] = 0
                                            }
                                        }
                                        .modifier(ShakeR(animatableData: shakeR[col][row]))

                                        .scaleEffect(scale[col][row])
                                        .gesture (
                                            DragGesture()
                                                .onEnded({ gesture in
                                                    let shapeSave = shape
                                                    withAnimation() {
                                                        firstMove = 1
                                                    }

                                                    isDone()
                                                    selected[0] = col
                                                    selected[1] = row
                                                    let saveshape = shape[selected[0]][selected[1]]
                                                    if saveshape != 0 && saveshape != 3 && saveshape != 4 {
                                                        scale[col][row] = 1.0
                                                        if abs(gesture.translation.height) > abs(gesture.translation.width) {

                                                            if gesture.translation.height > 0 {
                                                                //down
                                                                if isOneAhead(selected: selected, direction: "down", shapeCons: saveshape) {
                                                                        while selected[0] < boardHeight-1 {
                                                                            selected[0] += 1
                                                                            let stop = shape[selected[0]][selected[1]] != saveshape && shape[selected[0]][selected[1]] != 0 ? true : false
                                                                          
                                                                            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                                                                
                                                                                scale[selected[0]-1][selected[1]] = 1.15
                                                                                
                                                                                shape[selected[0]][selected[1]] = saveshape

                                                                                shape[selected[0]-1][selected[1]] = 0
                                                                            }

                                                                            if stop {

                                                                                break
                                                                            }

                                                                        }

                                                                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                                                                        scale[selected[0]][selected[1]] = 1.15
                                                                    }

                                                                }
                                                                else {
                                                                    withAnimation {
                                                                        shakeU[col][row] += 1
                                                                    }
                                                                }

                                                            } else {
                                                                //up
                                                                if isOneAhead(selected: selected, direction: "up", shapeCons: saveshape) {
                                                                    while selected[0] > 0 {
                                                                        selected[0] -= 1
                                                                        let stop = shape[selected[0]][selected[1]] != saveshape && shape[selected[0]][selected[1]] != 0 ? true : false
                                                                        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                                                            scale[selected[0]+1][selected[1]] = 1.15
                                                                            shape[selected[0]][selected[1]] = saveshape
                                                                            shape[selected[0]+1][selected[1]] = 0
                                                                        }
                                                                            if stop {

                                                                                break
                                                                            }


                                                                    }
                                                                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                                                                        scale[selected[0]][selected[1]] = 1.15
                                                                    }
                                                                } else {
                                                                    withAnimation {
                                                                        shakeU[col][row] += 1
                                                                    }
                                                                }

                                                            }

                                                        } else {
                                                            if gesture.translation.width > 0 {
                                                                //right
                                                                if isOneAhead(selected: selected, direction: "right", shapeCons: saveshape) {
                                                                    while selected[1] < 3 {
                                                                        selected[1] += 1
                                                                        let stop = shape[selected[0]][selected[1]] != saveshape && shape[selected[0]][selected[1]] != 0 ? true : false
                                                                        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                                                            scale[selected[0]][selected[1]-1] = 1.15
                                                                            shape[selected[0]][selected[1]] = saveshape
                                                                            shape[selected[0]][selected[1]-1] = 0
                                                                        }
                                                                        if stop {

                                                                            break
                                                                        }
                                                                    }
                                                                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                                                                        scale[selected[0]][selected[1]] = 1.15
                                                                    }

                                                                }
                                                                else {
                                                                    withAnimation {
                                                                        shakeR[col][row] += 1
                                                                    }
                                                                }
                                                            } else {
                                                                //left
                                                                if isOneAhead(selected: selected, direction: "left", shapeCons: saveshape) {
                                                                    while selected[1] > 0 {
                                                                        selected[1] -= 1
                                                                        let stop = shape[selected[0]][selected[1]] != saveshape && shape[selected[0]][selected[1]] != 0 ? true : false
                                                                        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                                                            scale[selected[0]][selected[1]+1] = 1.15
                                                                            shape[selected[0]][selected[1]] = saveshape
                                                                            shape[selected[0]][selected[1]+1] = 0
                                                                        }
                                                                        if stop {

                                                                            break
                                                                        }

                                                                    }
                                                                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                                                                        scale[selected[0]][selected[1]] = 1.15
                                                                    }
                                                                } else {
                                                                    withAnimation {
                                                                        shakeR[col][row] += 1
                                                                    }
                                                                }
                                                            }


                                                        }
                                                        isDone()
                                                        withAnimation(.easeInOut.delay(0.6)) {
                                                            scale = Array(repeating: Array(repeating: 1, count: 4), count: 8)
                                                        }

                                                    }

                                                    
                                                    if pages == 2 && shape != shapeSave {
                                                        
                                                        for row in 0...7 {
                                                            for col in 0...3 {
                                                                if shape[row][col] == 1 {
                                                                    shape[row][col] = 2
                                                                }
                                                                else if shape[row][col] == 2 {
                                                                    shape[row][col] = 1
                                                                }
                                                            }
                                                        }
                                                    }
                                                })


                                        )
                                }
                                
                            }
                        }
                    }
                }

            if diagnostics {
            Button {
                layout = shape
            } label: {
                Rectangle()
                    .frame(width: 80, height: 80)
                    .cornerRadius(20)
                    .foregroundColor(colorData.primary[colorSelected])
                
            }.buttonStyle(ExitButtonSytle(colorSelected: $colorSelected))
                .overlay {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 20))
                }
                .offset(x: 170, y: 320)
                
                Toggle(String(test), isOn: $test)
                    .frame(width: 100)
                    .offset(x: -120, y: -320)
                
                
                Text(LevelCodeString)
                    .offset(y: -350)
//                Text(layout.description)
//                    .offset(y: 370)
//                Text(String(gameOver))
//                    .offset(y: 390)
            }
        }.onAppear {
            //calculating board size
            if letter == "A" {
                boardHeight = 4
            } else if letter == "B" {
                boardHeight = 4
            } else if letter == "C" {
                boardHeight = 4
            } else if letter == "D" {
                boardHeight = 5
            } else if letter == "E" {
                boardHeight = 6
            } else if letter == "F" {
                boardHeight = 7
            }
            
            
            isDone()
            layoutMaker()
            shape = layout
            for num in 0...31 {
                withAnimation(.easeInOut.delay(Double(num+1)*0.05)) {
                    scaling[num] = true
                }
            }
        }
        .onChange(of: reset) { newValue in
           if !test {
                layoutMaker()
            }

            withAnimation(.easeInOut(duration: 0.7)) {
                rotation += 1
                shape = layout

            }
            
        }
        .onChange(of: selectedLevel, perform: { _ in
            firstMove = 0
        })
        .onReceive(timer) { _ in
            LevelCode()
        }
        
        
    }
    func layoutMaker() {
        let numCode = String(levelData.A[selectedLevel[0]][selectedLevel[1]-1])
      print(numCode)
        let StringarrayCode = Array(numCode)
        // let StringarrayCode = numCode.digits
      print(StringarrayCode.count)
        for col in 0...boardHeight-1 {
            for row in 0...3 {
                layout[col][row] = Int(String(StringarrayCode[col*4+row+1])) ?? 0
            }
        }

        
    }
    
    
    func isOneAhead(selected: [Int], direction: String, shapeCons: Int) -> Bool {
        if direction == "right" {
            let safe = selected[1] == 3 ? 0 : 1
            for num in selected[1]+safe...3 {
                if shape[selected[0]][num] == shapeCons || shape[selected[0]][num] == 4{
                    return false
                } else {
                    if shape[selected[0]][num] != shapeCons && shape[selected[0]][num] != 0 {
                        return true
                    }
                }
            }
        } else if direction == "left" {
            let safe = selected[1] == 0 ? 0 : 1
            for nums in -selected[1]+safe...0 {
                let num = abs(nums)
                if shape[selected[0]][num] == shapeCons || shape[selected[0]][num] == 4 {
                    return false
                } else {
                    if shape[selected[0]][num] != shapeCons && shape[selected[0]][num] != 0 {
                        return true
                    }
                }
            }
        } else if direction == "down" {
            let safe = selected[0] == boardHeight-1 ? 0 : 1
            for num in selected[0]+safe...boardHeight-1 {
                if shape[num][selected[1]] == shapeCons || shape[num][selected[1]] == 4 {
                    return false
                } else {
                    if shape[num][selected[1]] != shapeCons && shape[num][selected[1]] != 0 {
                        return true
                    }
                }
            }
        } else if direction == "up" {
            let safe = selected[0] == 0 ? 0 : 1
            for nums in -selected[0]+safe...0 {
                let num = abs(nums)
                if shape[num][selected[1]] == shapeCons || shape[num][selected[1]] == 4 {
                    return false
                } else {
                    if shape[num][selected[1]] != shapeCons && shape[num][selected[1]] != 0 {
                        return true
                    }
                }
            }
        }
        return false
    }
    func isDone() {
        count = 0
        for col in 0...boardHeight-1 {
            for row in 0...3 {
                if shape[col][row] != 0 && shape[col][row] != 4 {
                    count += 1
                }
            }
        }
        if count == 1 {
          gameOver = true
            levelComplete[selectedLevel[0]][NumToRow(num: (selectedLevel[1]-1))][NumToCol(num: (selectedLevel[1]-1))] = true
        } else {
            gameOver = false
        }
    }
    
    
    func LevelCode() {
        LevelCodeString = ""
        for col in 0...boardHeight-1 {
            for row in 0...3 {
                LevelCodeString.append(String(shape[col][row]))
            }
        }
    }
    func NumToRow(num: Int) -> Int{
        if num>=0 && num<=3 {
            return 0
        } else if num>=4 && num<=7 {
            return 1
        } else if num>=8 && num<=11 {
            return 2
        } else if num>=12 && num<=15 {
            return 3
        } else if num>=16 && num<=19 {
            return 4
        }
        return 0
    }
    func NumToCol(num: Int) -> Int {
        if num == 0 || num == 4 || num == 8 || num == 12 || num == 16 {
            return 0
        } else if num == 1 || num == 5 || num == 9 || num == 13 || num == 17 {
            return 1
        } else if num == 2 || num == 6 || num == 10 || num == 14 || num == 18 {
            return 2
        } else if num == 3 || num == 7 || num == 11 || num == 15 || num == 19 {
            return 3
        }
        return 0
    }
    
}

struct Shadow: ViewModifier {
    @State var radius: CGFloat = 5
    @State var CornerRadius: CGFloat = 22
    @State var lineWidth: CGFloat = 5
    @Binding var colorSelected: Int
    let colorData = ColorData()
    func body(content: Content) -> some View {
//        if !isPressed {
            content
                .shadow(color: colorData.BottomShadows[colorSelected], radius: radius/2, x: radius/2, y:  radius/2)
                .shadow(color:colorData.TopShadows[colorSelected], radius:  radius/2, x:  -radius/2, y:  -radius/2)
              //  .transition(.Good)
            
//        } else {
//            content
//                .shadow(color: Color("BottomShadow"), radius: radius-1, x: radius/2, y:  radius/2)
//                .shadow(color:Color("OffWhite"), radius:  radius-1, x:  -radius/2, y:  -radius/2)
//                .scaleEffect(1.1)
//                .transition(.Good)

//                .overlay(
//            RoundedRectangle(cornerRadius: CornerRadius)
//                .stroke(Color("GradientColorsLight"), lineWidth: lineWidth)
//                .shadow(color: Color("GradientColorsLight"), radius: 2, x: -3, y: -3)
//                .clipShape(RoundedRectangle(cornerRadius: CornerRadius))
//                .shadow(color: .gray, radius: 2, x: 3, y: 3)
//                .clipShape(RoundedRectangle(cornerRadius: CornerRadius+2))
//                ).scaleEffect(1.1)
//                .transition(.Good)
                

//        }
    }
}

struct MainBoard_Previews: PreviewProvider {
    static var previews: some View {
        MainBoard(mode: Binding.constant(3), reset: Binding.constant(false), layout: Binding.constant(Array(repeating: Array(repeating: 0, count: 4), count: 8)), gameOver: Binding.constant(false), selectedLevel: Binding.constant([0,1]), levelComplete: Binding.constant(Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6)), diagnostics: Binding.constant(true), colorSelected: Binding.constant(0), letter: Binding.constant("A"), pages: Binding.constant(0), firstMove: Binding.constant(0))
    }
}

