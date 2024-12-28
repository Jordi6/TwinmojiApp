//
//  ContentView.swift
//  Twinmoji
//
//  Created by tonystark on 12/24/24.
//

import SwiftUI
import SwiftData

enum GameState {
    case waiting
    case player1Turn
    case player2Turn
}

struct ContentView: View {
    let allEmoji = Array("😎🥹🥰😔😂😳🧐🙂😇😅😆😙😬🙃😍🥸😣😶🙄🤨😩😉🥲😋😛🤓😏😭😯😵😐😘😢😠").map(String.init)
    
    @State private var currentEmoji = [String]()
    
    @State private var leftCard = [String]()
    @State private var rightCard = [String]()
    
    @State private var gameState = GameState.waiting
    
    @State private var player1Score = 0
    @State private var player2Score = 0
    
    @State private var answerColor = Color.clear
    @State private var answerScale = 1.0
    @State private var answerAnchor = UnitPoint.center
    
    @State private var playerHasWon = false
    
    var itemCount: Int
    var answerTime: Double
    @Binding var isGameActive: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                PlayerButton(gameState: gameState, score: player1Score, color: .blue, onSelect: selectPlayer1)
                
                ZStack {
                    answerColor
                        .scaleEffect(x: answerScale, anchor: answerAnchor)
                    
                    if leftCard.isEmpty == false {
                        HStack {
                            CardView(card: leftCard, userCanAnswer: gameState != .waiting, onSelect: checkAnswer)
                            CardView(card: rightCard, userCanAnswer: gameState != .waiting, onSelect: checkAnswer)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                
                PlayerButton(gameState: gameState, score: player2Score, color: .red, onSelect: selectPlayer2)
            }
            
            Button("End Game", systemImage: "xmark.circle") {
                isGameActive = false
            }
            .symbolVariant(.fill)
            .labelStyle(.iconOnly)
            .font(.largeTitle)
            .tint(.white)
            .padding(40)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.9))
        .persistentSystemOverlays(.hidden)
        .onAppear(perform: createLevel)
        .alert("Game Over", isPresented: $playerHasWon) {
            Button("Start Again") {
                isGameActive = true
            }
        } message: {
            if player1Score > player2Score {
                Text("Player 1 won \(player1Score) - \(player2Score)")
            } else {
                Text("Player 2 won \(player2Score) - \(player1Score)")
            }
        }
    }
    
    func createLevel() {
        currentEmoji = allEmoji.shuffled()
        
        withAnimation(.spring(duration: 0.75)) {
            leftCard = Array(currentEmoji[0..<itemCount]).shuffled()
            rightCard = Array(currentEmoji[itemCount + 1..<itemCount + itemCount] + [currentEmoji[0]]).shuffled()
        }
    }
    
    func selectPlayer1() {
        guard gameState == .waiting else { return }
        answerColor = .blue
        answerAnchor = .leading
        gameState = .player1Turn
        runClock()
    }
    
    func selectPlayer2() {
        guard gameState == .waiting else { return }
        answerColor = .red
        answerAnchor = .trailing
        gameState = .player2Turn
        runClock()
    }
    
    func timeOut(for emoji: [String]) {
        guard currentEmoji == emoji else { return }
        
        if gameState == .player1Turn {
            player1Score -= 1
        } else if gameState == .player2Turn {
            player2Score -= 1
        }
        
        gameState = .waiting
    }
    
    func runClock() {
        answerScale = 1
        let checkEmoji = currentEmoji
        
        withAnimation(.linear(duration: answerTime)) {
            answerScale = 0
        } completion: {
            timeOut(for: checkEmoji)
        }
    }
    
    func checkAnswer(_ string: String) {
        if string == currentEmoji[0] {
            if gameState == .player1Turn {
                player1Score += 1
            } else if gameState == .player2Turn {
                player2Score += 1
            }
            
            if player1Score == 5 || player2Score == 5 {
                playerHasWon = true
            } else {
                createLevel()
            }
        } else {
            if gameState == .player1Turn {
                player1Score -= 1
            } else if gameState == .player2Turn {
                player2Score -= 1
            }
        }
        
        answerColor = .clear
        answerScale = 0
        gameState = .waiting
    }
}

#Preview {
    ContentView(itemCount: 9, answerTime: 1, isGameActive: .constant(true))
}
