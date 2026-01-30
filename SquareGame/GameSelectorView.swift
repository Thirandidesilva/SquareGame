//
//  GameSelectorView.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-21.
//

import SwiftUI

struct GameSelectorView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("username") private var username = ""

    @State private var selectedGame: SelectedGame? = nil
    @State private var showLogoutAlert = false   //Alertstate

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
            // Background
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
            .accessibilityHidden(true)

            VStack(spacing: 40) {

                // ===== TOP BAR =====
                HStack {
                    // PLAYER NAME
                    Text("Player: \(username)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                        .accessibilityLabel("Current player \(username)")

                    Spacer()

                    // LOGOUT BUTTON
                    Button {
                        showLogoutAlert = true
                    } label: {
                        Image(systemName: "person.crop.circle.badge.xmark")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                                Circle().fill(
                                    LinearGradient(
                                        colors: [.red, .pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            )
                            .shadow(radius: 6)
                    }
                    .accessibilityLabel("Logout")
                    .accessibilityHint("Logs out and changes player")
                    .padding(.trailing, 20)
                }
                .padding(.top, 20)

               // Spacer()

                // ===== TITLE =====
                VStack(spacing: 15) {
                    Text("Game Hub")
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .accessibilityAddTraits(.isHeader)

                    Text("Choose a game to play")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                // ===== GAME BUTTONS =====
                VStack(spacing: 25) {

                    // Color Match
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

                    // Match 3
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
                }
                .padding(.bottom,50)
                .padding(.horizontal, 30)

                Spacer()
            }
        }
        //  LOGOUT CONFIRMATION ALERT
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}

            Button("Logout", role: .destructive) {
                username = ""
                appState.hasUsername = false
            }
        } message: {
            Text("Are you sure you want to change the player?")
        }
    }
}

#Preview {
    GameSelectorView()
        .environmentObject(AppState())
}
