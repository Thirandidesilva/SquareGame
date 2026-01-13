//
//  SquareGameTwo.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-13.
//

import SwiftUI

struct NamedColors {
    var color: Color
    var colorName: String
}

enum DifficultLevel {
    case easy // for 3x3
    case medium // for 5x5
    case hard // 7x7
    
    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .medium: return 5
        case .hard: return 7
        }
    }
    
    var totalTiles: Int {
        return gridSize * gridSize
    }
    
    var title: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}

struct SquareGameTwo: View {
    @State private var showLevelSelction = true
    @State private var selectedLevel: DifficultLevel = .easy
    
    // showLevelSelection view
    
    var body: some View {
        Text("Square Game Two")
    }
}

// LevelSelection View

struct LevelSelectionView: View {
    @Binding var selectedLevel: DifficultLevel
    @Binding var showLevelSelection: Bool
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            // Title
            Text("Color Match Game")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.purple)
            
            Text("Select Difficulty Level")
                .font(.title2)
                .foregroundColor(.gray)
            
            // Level Buttons VStack
            VStack(spacing: 20) {
                
                // Easy Button
                Button {
                    selectedLevel = .easy
                    showLevelSelection = false
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("Easy")
                        Text("(3x3)")
                            .font(.caption)
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.green, Color.mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                
                // Medium Button
                Button {
                    selectedLevel = .medium
                    showLevelSelection = false
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Text("Medium")
                        Text("(5x5)")
                            .font(.caption)
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.yellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                
                //Hard Button
                Button {
                    selectedLevel = .hard
                    showLevelSelection = false
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Text("Hard")
                        Text("(7x7)")
                            .font(.caption)
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.red, Color.pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                
            }
            .padding(.horizontal, 40)
        
            
        }
        .padding()
        
    }
}


// Game View



#Preview {
    SquareGameTwo()
}
