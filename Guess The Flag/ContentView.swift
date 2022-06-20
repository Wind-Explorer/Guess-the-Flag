//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Adam C on 2022/6/2.
//

import SwiftUI

struct FlagImage1: ViewModifier {
    var imageName: String

    func body(content: Content) -> some View {
        Image(imageName)
            .renderingMode(.original)
            //.clipShape(Capsule())
            .cornerRadius(10)
            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2), radius: 6, x: -5, y: 5)
    }
}

struct titleTextStruct: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        Text(text)
            .font(.largeTitle.bold())
            .foregroundColor(.white)
            .shadow(color: .white, radius: 20, x: -5, y: 5)
    }
}

struct detailsTextStruct: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        Text(text)
            .foregroundColor(.white)
            .font(.headline.bold())
            //.shadow(color: .black, radius: 15, x: -5, y: 5)
        
    }
}

extension View {
    func flagImage(image: String) -> some View {
        modifier(FlagImage1(imageName: image))
    }
    
    func titleText(_ text: String) -> some View {
        modifier(titleTextStruct(text: text))
    }
    
    func detailsText(_ text: String) -> some View {
        modifier(detailsTextStruct(text: text))
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var showingEnd = false
    @State private var scoreTtile = ""
    @State private var currentScore = 0
    @State private var userInput = 0
    @State private var alertMessage = ""
    @State private var gameProgress = 0
    @State private var congratsMessage = ""
    @State private var flagRotate = 0.0
    @State private var fadeAway = false
    @State private var flagScale = 0.0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
//            RadialGradient(stops: [
//                .init(color: Color(red: 0.35, green: 0, blue: 0.55), location: 0.3),
//                .init(color: Color(red: 0.76, green: 0.65, blue: 0.26), location: 0.3)
//            ], center: .top, startRadius: 200, endRadius: 700
//            )
            
            LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Spacer()
                titleText("Guess the Flag")
                Spacer()
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.primary)
                            .font(.largeTitle.weight(.semibold))
                            //.shadow(color: .secondary, radius: 15, x: -5, y: 5)
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            userInput = number
                            withAnimation {
                                flagRotate += 360
                            }
                            fadeAway = true
                            flagTapped(number)
                        } label: {
                            flagImage(image: countries[number])
                        }
                        .rotation3DEffect(.degrees(flagRotate), axis: (x: 0, y: number == userInput ? 1 : 0, z: 0))
                        .animation(.interpolatingSpring(stiffness: 50, damping: 10), value: flagRotate)
                        .opacity(number != userInput && fadeAway ? 0 : 1)
                        .scaleEffect(number != userInput && fadeAway ? 0 : 1)
                        .animation(.default, value: fadeAway)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color(red: 0.3, green: 0.3, blue: 0.3), radius: 25, x: -5, y: 5)
                                
                HStack {
                    Spacer()
                    detailsText("Score: \(currentScore)")
                    Spacer()
                    detailsText("Progress: \(gameProgress)/8")
                    Spacer()
                }
                .padding(10)

                Spacer()
                Spacer()

            }
            .padding(.horizontal, 30)
        }
        .alert(scoreTtile, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        
        .alert("The end!", isPresented: $showingEnd) {
            Button("Restart", role: .cancel, action: resetGame)
        } message: {
            Text("Your total score: \(currentScore)/8\(congratsMessage)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTtile = "Correct"
            currentScore += 1
            alertMessage = "Good job! Your score is \(currentScore)"
            gameProgress += 1
        } else {
            scoreTtile = "Wrong!"
            alertMessage = "That is the flag of \(countries[userInput])!\nYour score is \(currentScore)"
            gameProgress += 1
        }
        
        if gameProgress == 8 {
            if currentScore == 8 {
                congratsMessage = "\nYou are good at this! :D"
            } else {
                congratsMessage = "\nTry harder next time!"
            }
            showingEnd = true
        } else {
            showingScore = true
        }
    }
    
    func resetGame() {
        currentScore = 0
        gameProgress = 0
        askQuestion()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        fadeAway = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
