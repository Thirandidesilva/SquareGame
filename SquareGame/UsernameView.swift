//
//  UsernameView.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-26.
//


import SwiftUI

struct UsernameView: View {
    @AppStorage("username") var username: String = ""
    @State private var tempName = ""
    
    
    var body: some View {
        ZStack {
            // Dark gradient background
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
            
            VStack(spacing: 30) {
                
                Spacer()
                
                // Game logo/title area
                VStack(spacing: 15) {
                    ZStack {
                        // Glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.cyan.opacity(0.3), Color.clear],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        // Icon
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cyan, .blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .cyan.opacity(0.5), radius: 10)
                    }
                    
                    Text("PLAYER SETUP")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .cyan.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    
                    Text("Choose your identity")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .tracking(2)
                }
                .padding(.bottom, 20)
                
                // Input container
                VStack(spacing: 20) {
                    ZStack {
                        // Glowing border effect
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.cyan, .blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 2
                            )
                            .frame(height: 60)
                            .shadow(color: .cyan.opacity(0.5), radius: 8)
                        
                        TextField("", text: $tempName)
                            .placeholder(when: tempName.isEmpty) {
                                Text("Enter player name")
                                    .foregroundColor(.white.opacity(0.4))
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .frame(height: 60)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 30)
                    
                    // Continue button
                    Button {
                        if !tempName.trimmingCharacters(in: .whitespaces).isEmpty {
                                username = tempName.trimmingCharacters(in: .whitespaces)
                            }
                       // isCompleted = true
                    } label: {
                        HStack(spacing: 12) {
                            Text("START GAME")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .tracking(1.5)
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 24))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                colors: tempName.isEmpty ?
                                    [Color.gray.opacity(0.3), Color.gray.opacity(0.5)] :
                                    [Color.green, Color.cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: tempName.isEmpty ? .clear : .cyan.opacity(0.5), radius: 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .disabled(tempName.isEmpty)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                }
                
                Spacer()
                Spacer()
            }
        }
    }
}

// TextField placeholder extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    UsernameView()
}
