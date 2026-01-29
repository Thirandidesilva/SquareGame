//
//  GameSelectorView.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-21.
//

import SwiftUI

struct GameSelectorView: View {
    //@AppStorage("username") private var username = ""
    @State private var selectedGame: SelectedGame? = nil

    
    enum SelectedGame {
        case colorMatch
        case match3
    }
    
    
    var body: some View {
        NavigationStack {
            if let game = selectedGame {
                switch game {
                case .colorMatch:
                    SquareGameTwo(selectedGame: $selectedGame)
                case .match3:
                    Match3GameView()
                }
            } else {
                mainMenu
            }
        }
    }

    
    // ===== MAIN MENU =====
    var mainMenu: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.0, blue: 0.3),
                    Color(red: 0.2, green: 0.0, blue: 0.4),
                    Color(red: 0.3, green: 0.1, blue: 0.5)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .accessibilityHidden(true) // Decorative background
            
            VStack(spacing: 40) {
                Spacer()
                
                // ===== TITLE =====
                VStack(spacing: 15) {
                    Text("Game Hub")
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityLabel("Game Hub")
                    
                    Text("Choose a game to play")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                        .accessibilityLabel("Choose a game to play")
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
                                .accessibilityHidden(true)
                            
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
                        .shadow(color: Color.purple.opacity(0.5),
                                radius: 15, x: 0, y: 10)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Play Color Match")
                    .accessibilityHint("Starts the Color Match game")
                    .accessibilityAddTraits(.isButton)
                    
                    // Match 3 Button
                    Button {
                        selectedGame = .match3
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "timer")
                                .font(.system(size: 35))
                                .accessibilityHidden(true)
                            
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
                        .shadow(color: Color.pink.opacity(0.5),
                                radius: 15, x: 0, y: 10)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Play Match 3 Rush")
                    .accessibilityHint("Starts the Match 3 game")
                    .accessibilityAddTraits(.isButton)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}

#Preview {
    GameSelectorView()
}
