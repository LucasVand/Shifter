//
//  ContentView.swift
//  Shifter
//
//  Created by Lucas Vanderwielen on 2023-02-17.
//

import SwiftUI
import DeviceKit


struct ContentView: View {
    @AppStorage("SAVE_COLOR") var colorSave = 0
    @AppStorage("FIRST_PLAY") var firstPlay = false
    
    @AppStorage("SAVE_LEVELS") var save = ""
    
    
    @State var gameDone: Bool = true
    @State var reset: Bool = true
    @State var diagnostics: Bool = false
    
    @State var mode: Int = 0
    @State var letters: [String] = ["A","B","C","D","E","F"]
    @State var selected: [Int] = [0,1]
    @State var levelComplete: [[[[Bool]]]] = Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 4), count: 5), count: 6), count: 3)
    @State var layout: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 8)
    
    @State var colorSelected: Int = 1
    @State var colorView: Bool = false
    
    @State var achevementString: [Bool] = Array(repeating: false, count: 15)
    
    @AppStorage("HapticsSaving") var hapticsBool: Bool = true
    
    
    @State var pages: CGFloat = 0
    
    
    @State var gameOver: Bool = false
    
    
    let device = Device.current
    
    var colorData = ColorData()
    
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorData.primary[colorSelected])
                .ignoresSafeArea()
            ZStack {
                if mode == 0 {
                    TitleScreen(mode: $mode, colorSelected: $colorSelected, colorView: $colorView, firstPlay: $firstPlay, hapticsBool: $hapticsBool)
                        .sheet(isPresented: $colorView) {
                            ColorSelectorScreen(mode: $mode, colorSelected: $colorSelected, colorView: $colorView, hapticsBool: $hapticsBool, levelCompleted: $levelComplete)
                        }
                    
                    
                } else if mode == 1 {
                    AreaScreen(mode: $mode, selected: $selected[0], levelCompleted: $levelComplete, hapticsBool: $hapticsBool, colorSelected: $colorSelected, pages: $pages)
                } else if mode == 2 {
                    LevelsScreen(mode: $mode, letter: $letters[selected[0]], levelComplete: $levelComplete[Int(pages)][selected[0]], selected1: $selected[1], hapticsBool: $hapticsBool, colorSelected: $colorSelected)
                } else if mode == 3 {
                    PlayingScreen(mode: $mode, reset: $reset, layout: $layout, selected: $selected, levelComplete: $levelComplete[Int(pages)], diagnostics: $diagnostics, letter: $letters[selected[0]], colorSelected: $colorSelected, hapticsBool: $hapticsBool, pages: $pages, gameOver: $gameOver)
                } else if mode == 4 {
                    SettingScreen(mode: $mode, levelComplete: $levelComplete, diagnostics: $diagnostics, colorSelected: $colorSelected, firstPlay: $firstPlay, achevementString: $achevementString, hapticsBool: $hapticsBool)
                } else if mode == 5 {
                    AchevementsScreen(colorSelected: $colorSelected, mode: $mode, levelComplete: $levelComplete)
                }
                
                //achevement icon
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "trophy")
                            .padding(.horizontal,20)
                            .foregroundColor(colorData.secondary[colorSelected])
                            .padding()
                            .onTapGesture {
                                mode = 5
                            }
                            .opacity(mode == 0 ? 1 : 0)
                        
                    }
                    Spacer()
                }
                
                //achevement bar
                AchevementBar(colorSelected: $colorSelected, mode: $mode, levelComplete:  $levelComplete, achevementSaving: $achevementString, hapticsBool: $hapticsBool, gameOver: $gameOver)
                
            }
            .scaleEffect(screenScaling())
        }
        .preferredColorScheme(preferredColorScheme() == "light" ? .light : .dark)
        .onChange(of: levelComplete) { newValue in
            saving()
        }
        .onChange(of: colorSelected) { newValue in
            colorSave = colorSelected
        }
        
        .onAppear {
            
            colorSelected = colorSave
            reading()
        }
    }
    
    func preferredColorScheme() -> String {
        if colorSelected == 0 {
            return "light"
        } else if colorSelected == 1{
            return "light"
        } else if colorSelected == 2{
            return "light"
            
        }else if colorSelected == 3{
            return "light"
        }else if colorSelected == 4{
            return "light"
        }else if colorSelected == 5{
            return "dark"
        }else if colorSelected == 6{
            return "dark"
        } else if colorSelected == 7{
            return "dark"
        } else if colorSelected == 8{
            return "dark"
        } else if colorSelected == 9{
            return "dark"
        }
        return "light"
    }
    
    func simpleSuccess() {
        if hapticsBool {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(.success)
        }
    }
    
    func saving() {
        save = ""
        for page in 0...1 {
            for area in 0...5 {
                for row in 0...4 {
                    for col in 0...3 {
                        save.append(String(levelComplete[page][area][row][col]) + " ")
                    }
                }
            }
        }
    }
    func reading() {
        
        let array = save.count < 100 ? Array(repeating: "", count: 380) : save.components(separatedBy: " ")
        print(array.description)
        print(array.count)
        for page in 0...1 {
            for area in 0...5 {
                for row in 0...4 {
                    for col in 0...3 {
                        levelComplete[page][area][row][col] = Bool(array[(area*20)+row*4+col+(page*120)]) ?? false
                    }
                }
            }
        }
    }
    
    func screenScaling() -> Double {
        if device == .iPhoneSE3 {
            return 0.8
        } else if device == .iPhoneSE {
            return 0.8
        } else if device == .iPhoneSE2 {
            return 0.8
        } else if device == .iPhone8 || device == .iPhone7 || device == .iPhone6 || device == .iPhone6s {
            return 0.8
        } else if device == .iPhone8Plus || device == .iPhone7Plus || device == .iPhone6sPlus || device == .iPhone6Plus {
            return 0.9
        } else if device == .iPhoneX || device == .iPhoneXS || device == .iPhone11Pro {
            return 0.95
        } else if device == .iPhone12Mini || device == .iPhone13Mini {
            return 0.90
        }
        
        
        
        return 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

