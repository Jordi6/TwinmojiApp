//
//  PlayerButton.swift
//  Twinmoji
//
//  Created by tonystark on 12/24/24.
//

import SwiftUI

struct PlayerButton: View {
    var gameState: GameState
    var score: Int
    var color: Color
    var onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            Rectangle()
                .fill(color)
                .frame(minWidth: 60) // 44 recomended width on iPhone and iPad
                .overlay(
                    Text(String(score))
                        .fixedSize()
                        .foregroundStyle(.white)
                        .font(.system(size: 48))
                        .bold()
                )
        }
        .disabled(gameState != .waiting)
    }
}

#Preview {
    PlayerButton(gameState: .waiting, score: 5, color: .blue) {
        
    }
}
