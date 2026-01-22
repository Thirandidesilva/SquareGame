//
//  GameSelectorView.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-21.
//

import SwiftUI

// MARK: - Game Selector View


struct GameSelectorView: View {
    @State private var selectedGame: SelectedGame? = nil
    
    /// Which game to show
    enum SelectedGame {
        case colorMatch
        case match3
    }
    
    var body: some View {
        // Use NavigationStack for proper navigation
        NavigationStack {
            if let game = selectedGame {
                // Show selected game
                switch game {
                case .colorMatch:
                    SquareGameTwo(selectedGame: $selectedGame)
                        .navigationBarHidden(true)
                case .match3:
                    Match3GameView()
                        .navigationBarHidden(true)
                }
            } else {
                // Show game selector menu
                mainMenu
                    .navigationBarHidden(true)
            }
        }
    }
    
    // ===== MAIN MENU =====
    var mainMenu: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Color.indigo,
                    Color.purple,
                    Color.pink
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // ===== TITLE =====
                VStack(spacing: 15) {
                    Text("Game Hub")
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                    
                    Text("Choose a game to play")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // ===== BUTTONS =====
                VStack(spacing: 20) {
                    
                    // Color Match Button
                    Button {
                        selectedGame = .colorMatch
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "paintpalette.fill")
                                .font(.system(size: 35))
                            Text("Color Match")
                                .font(.system(size: 28, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: 350)
                        .padding(.vertical, 25)
                        .background(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        
                        )
                        .cornerRadius(25)
                        .shadow(color: Color.purple.opacity(0.5), radius: 15, x: 0, y: 10)
                    }
                     
                    // Match 3 Button
                    Button {
                        selectedGame = .match3
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "timer")
                                .font(.system(size: 35))
                            Text("Match 3 Rush")
                                .font(.system(size: 28, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: 350)
                        .padding(.vertical, 25)
                        .background(
                            LinearGradient(
                                colors: [Color.pink, Color.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: Color.pink.opacity(0.5), radius: 15, x: 0, y: 10)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    GameSelectorView()
}
