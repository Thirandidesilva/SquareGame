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
    @State private var showLevelSelection = true
    @State private var selectedLevel: DifficultLevel = .easy
    
    var body: some View {
        if showLevelSelection {
            // ===== START: Level Selection Screen =====
            LevelSelectionView(
                selectedLevel: $selectedLevel,
                showLevelSelection: $showLevelSelection
            )
            // ===== END: Level Selection Screen =====
        } else {
            // ===== START: Game Screen =====
            GameView(
                level: selectedLevel,
                showLevelSelection: $showLevelSelection
            )
            // ===== END: Game Screen =====
        }
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
                .foregroundColor(.blue)
                
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
            .padding(.top,60)
            
        }
        .padding(.top,50)
        Spacer()
        
    }
}


// Game View

struct GameView: View {
    let level: DifficultLevel
    @Binding var showLevelSelection: Bool
    
    @State private var items: [NamedColors] = []
    @State private var selectedIndices: [Int] = []
    @State private var matched: [Bool] = []
    @State private var message = "Tap all matching colors!"
    
    // All available colors
    let allColors: [NamedColors] = [
        NamedColors(color: .blue, colorName: "Blue"),
        NamedColors(color: .pink, colorName: "Pink"),
        NamedColors(color: .yellow, colorName: "Yellow"),
        NamedColors(color: .green, colorName: "Green"),
        NamedColors(color: .red, colorName: "Red"),
        NamedColors(color: .purple, colorName: "Purple"),
        NamedColors(color: .orange, colorName: "Orange"),
        NamedColors(color: .cyan, colorName: "Cyan"),
        NamedColors(color: .mint, colorName: "Mint"),
        NamedColors(color: .indigo, colorName: "Indigo"),
        NamedColors(color: .teal, colorName: "Teal"),
        NamedColors(color: .brown, colorName: "Brown")
    ]
    
    var body: some View {
        
        if items.isEmpty {
        // Show loading or initialize
        Color.clear
            .onAppear {
                setupGame()
            }
    } else {
        
        GeometryReader { geometry in
            VStack(spacing: 20) {
                    
            HStack {
                    // Back Button
            Button {
                showLevelSelection = true
                } label: {
                    HStack {
                    Image(systemName: "chevron.left")
                    Text("Levels")
                    }
                    .foregroundColor(.blue)
                    }
                        
                    Spacer()
                        
                    Text(level.title)
                        .font(.headline)
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                
                    Text("Tap Matching Colors")
                        .font(.largeTitle)
                        .bold()
                    
                    Text(message)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .frame(height: 60)
                    
            ScrollView {
            LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: level.gridSize),
                            spacing: 10) {
                            
    
        ForEach(0..<level.totalTiles, id: \.self) { index in
                                
                                
        Button {
         handleTap(index)
        } label: {
                                    
                                    
        Rectangle()
        .foregroundColor(items[index].color)
        .frame(width: getTileSize(screenWidth: geometry.size.width),
            height: getTileSize(screenWidth: geometry.size.width))
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8)
        .stroke(matched[index] ? Color.black :selectedIndices.contains(index) ? Color.blue : Color.clear,lineWidth: 4))
        .shadow(color: matched[index] ? .black.opacity(0.6) :
        selectedIndices.contains(index) ? .blue.opacity(0.8) : .clear,radius: matched[index] ? 10 : selectedIndices.contains(index) ? 8 : 0)
        .scaleEffect(selectedIndices.contains(index) ? 0.95 : 1.0)
        .opacity(matched[index] ? 0.5 : 1.0)
                                
          }
        .disabled(matched[index])
                            
       }
                        
    }
     .padding(.horizontal)
                        
}
                    
                    
                
        HStack(spacing: 15) {
                        
        // Check Match Button
            Button {
                checkMatch()
                  } label: {
                    Text("Check Match")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                     LinearGradient(
                    colors: [Color.green, Color(red: 0.3,green: 0.8, blue: 0.5)],
                        startPoint: .leading,
                        endPoint: .trailing))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    }
                    .disabled(selectedIndices.isEmpty)
                    .opacity(selectedIndices.isEmpty ? 0.5 : 1.0)
                        
                        // Reset Button
            Button {
                 setupGame()
                 } label: {
                 Text("Reset")
                 .font(.headline)
                 .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                LinearGradient(
                colors: [Color.purple, Color.blue],
                startPoint: .leading,
                endPoint: .trailing))
                .cornerRadius(12)
                .shadow(radius: 5)
                  }
                        
                 }
                .padding(.horizontal)
                
              }
                .padding()
            
            }
        }
    }
    
    // getTileSize function
    
    func getTileSize(screenWidth: CGFloat) -> CGFloat {
        let spacing: CGFloat = 10
        let padding: CGFloat = 40
        let availableWidth = screenWidth - padding - (spacing * CGFloat(level.gridSize - 1))
        return availableWidth / CGFloat(level.gridSize)
    }
    
    
    // setupGame function
    func setupGame() {
        var gameItems: [NamedColors] = []
        
        // Determine how many colors we need
        let numColors: Int
        switch level {
        case .easy:
            numColors = 3
        case .medium:
            numColors = 5
        case .hard:
            numColors = 7
        }
        
        // Create tiles with equal distribution
        let tilesPerColor = level.totalTiles / numColors
        
        for i in 0..<numColors {
            for _ in 0..<tilesPerColor {
                gameItems.append(allColors[i])
            }
        }
        
        // Shuffle the items
        items = gameItems.shuffled()
        matched = Array(repeating: false, count: level.totalTiles)
        selectedIndices.removeAll()
        message = "Tap all matching colors!"
    }
    
    
    // handleTap function
    func handleTap(_ index: Int) {
        if matched[index] { return }
        
        // Check if already selected - deselect it
        if let existingIndex = selectedIndices.firstIndex(of: index) {
            selectedIndices.remove(at: existingIndex)
            message = "Tap all matching colors, then check!"
            return
        }
        
        // Add to selection
        selectedIndices.append(index)
        
        if selectedIndices.count == 1 {
            message = "Tap all \(items[index].colorName) colors!"
        } else {
            message = "\(selectedIndices.count) selected. Tap 'Check Match' to verify!"
        }
    }
    
    
    // checkMatch function
    func checkMatch() {
        if selectedIndices.isEmpty {
            message = "Please select some colors first!"
            return
        }
        
        // Get the color name of the first selected item
        let targetColor = items[selectedIndices[0]].colorName
        
        // Check if all selected items are the same color
        let allSameColor = selectedIndices.allSatisfy { items[$0].colorName == targetColor }
        
        if !allSameColor {
            message = "Not all the same color! Try again!"
            selectedIndices.removeAll()
            return
        }
        
        // Count how many of this color exist in total
        let totalOfThisColor = items.filter { $0.colorName == targetColor }.count
        
        // Check if all instances of this color are selected
        if selectedIndices.count == totalOfThisColor {
            for index in selectedIndices {
                matched[index] = true
            }
            message = "You recognized all \(targetColor)s!"
            selectedIndices.removeAll()
            
            // Check if game is complete
            if matched.allSatisfy({ $0 }) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    message = " You won! All colors matched!"
                }
            }
        } else {
            message = "You found \(selectedIndices.count) but there are \(totalOfThisColor) \(targetColor)(s)! Find them all!"
            selectedIndices.removeAll()
        }
    }

}

#Preview {
    SquareGameTwo()
}
