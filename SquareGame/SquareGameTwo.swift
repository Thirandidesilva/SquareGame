//
//  SquareGameTwo.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-13.
//

import SwiftUI
import Combine

struct NamedColors {
    var color: Color
    var colorName: String
}

enum DifficultLevel: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
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
        case .easy: return "Easy (3x3)"
        case .medium: return "Medium (5x5)"
        case .hard: return "Hard (7x7)"
        }
    }
}

// HighScore Model =====
struct HighScore: Identifiable, Codable {
    let id: UUID
    let level: String
    let time: TimeInterval
    let date: Date
    
    init(level: DifficultLevel, time: TimeInterval) {
        self.id = UUID()
        self.level = level.rawValue
        self.time = time
        self.date = Date()
    }
    
    var formattedTime: String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}
// ===== END: HighScore Model =====

// ===== START: HighScore Manager =====
class HighScoreManager: ObservableObject {
    @Published var highScores: [HighScore] = []
    
    private let saveKey = "SavedHighScores"
    
    init() {
        loadScores()
    }
    
    func addScore(_ score: HighScore) {
        highScores.append(score)
        highScores.sort { $0.time < $1.time }
        saveScores()
    }
    
    func getTopScores(for level: DifficultLevel, limit: Int = 10) -> [HighScore] {
        return highScores
            .filter { $0.level == level.rawValue }
            .sorted { $0.time < $1.time }
            .prefix(limit)
            .map { $0 }
    }
    
    func getBestTime(for level: DifficultLevel) -> TimeInterval? {
        return getTopScores(for: level, limit: 1).first?.time
    }
    
    private func saveScores() {
        if let encoded = try? JSONEncoder().encode(highScores) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadScores() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([HighScore].self, from: data) {
            highScores = decoded
        }
    }
}
// ===== END: HighScore Manager =====

struct SquareGameTwo: View {
    @StateObject private var highScoreManager = HighScoreManager()
    @State private var showLevelSelection = true
    @State private var showHighScores = false
    @State private var selectedLevel: DifficultLevel = .easy
    
    var body: some View {
        if showHighScores {
            HighScoreView(
                highScoreManager: highScoreManager,
                showHighScores: $showHighScores
            )
        } else if showLevelSelection {
            LevelSelectionView(
                selectedLevel: $selectedLevel,
                showLevelSelection: $showLevelSelection,
                showHighScores: $showHighScores,
                highScoreManager: highScoreManager
            )
        } else {
            GameView(
                level: selectedLevel,
                showLevelSelection: $showLevelSelection,
                highScoreManager: highScoreManager
            )
        }
        
    }
    
}

// ===== START: Level Selection View =====
struct LevelSelectionView: View {
    @Binding var selectedLevel: DifficultLevel
    @Binding var showLevelSelection: Bool
    @Binding var showHighScores: Bool
    @ObservedObject var highScoreManager: HighScoreManager
    
    var body: some View {
        ZStack {
            
           
            VStack(spacing: 30) {
                
                Spacer()
                
                // Title
                VStack(spacing: 10) {
                    Text("Color Match")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.purple)
                        
                    Text("Challenge")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.blue)
                }
                
                
                Text("Select Difficulty Level")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                
                // Level Buttons
                VStack(spacing: 20) {
                    
                    ForEach([DifficultLevel.easy, .medium, .hard], id: \.self) { level in
                        LevelButton(
                            level: level,
                            bestTime: highScoreManager.getBestTime(for: level),
                            action: {
                                selectedLevel = level
                                showLevelSelection = false
                            }
                        )
                    }
                }
                .padding(.horizontal, 30)
                Spacer()
                // High Scores Button
                Button {
                    showHighScores = true
                } label: {
                    HStack {
                        Image(systemName: "trophy.fill")
                        Text("High Scores")
                    }
                    .font(.headline)
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
                    .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}

struct LevelButton: View {
    let level: DifficultLevel
    let bestTime: TimeInterval?
    let action: () -> Void
    
    var stars: Int {
        switch level {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        }
    }
    
    var gradient: [Color] {
        switch level {
        case .easy: return [.green, .mint]
        case .medium: return [.orange, .yellow]
        case .hard: return [.red, .pink]
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                HStack {
                    HStack(spacing: 4) {
                        ForEach(0..<stars, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.caption)
                        }
                    }
                    
                    Text(level.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("(\(level.gridSize)x\(level.gridSize))")
                        .font(.caption)
                        .opacity(0.8)
                    
                    Spacer()
                    
                    if let bestTime = bestTime {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Best")
                                .font(.caption2)
                                .opacity(0.8)
                            Text(formatTime(bestTime))
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: gradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(15)
            .shadow(color: gradient[0].opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
// ===== END: Level Selection View =====

// ===== START: High Score View =====
struct HighScoreView: View {
    @ObservedObject var highScoreManager: HighScoreManager
    @Binding var showHighScores: Bool
    @State private var selectedLevel: DifficultLevel = .easy
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        showHighScores = false
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("High Scores")
                        .font(.headline)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button {} label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .hidden()
                }
                .padding()
                
                // Level Picker
                Picker("Level", selection: $selectedLevel) {
                    ForEach(DifficultLevel.allCases, id: \.self) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom)
                
                // Scores List
                let scores = highScoreManager.getTopScores(for: selectedLevel)
                
                if scores.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("No scores yet")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("Play \(selectedLevel.rawValue) mode to set a record!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(scores.enumerated()), id: \.element.id) { index, score in
                                HighScoreRow(score: score, rank: index + 1)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct HighScoreRow: View {
    let score: HighScore
    let rank: Int
    
    var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank
            ZStack {
                Circle()
                    .fill(rankColor)
                    .frame(width: 40, height: 40)
                
                if rank <= 3 {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                } else {
                    Text("\(rank)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(score.formattedTime)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(formatDate(score.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
// ===== END: High Score View =====

// ===== START: Game View =====
struct GameView: View {
    let level: DifficultLevel
    @Binding var showLevelSelection: Bool
    @ObservedObject var highScoreManager: HighScoreManager
    
    @State private var items: [NamedColors] = []
    @State private var selectedIndices: [Int] = []
    @State private var matched: [Bool] = []
    @State private var message = "Tap all matching colors!"
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showWinDialog = false
    
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
        ZStack {
            if items.isEmpty {
                Color.clear
                    .onAppear {
                        setupGame()
                    }
            } else {
                GeometryReader { geometry in
                    VStack(spacing: 20) {
                        
                        // Header
                        HStack {
                            Button {
                                stopTimer()
                                showLevelSelection = true
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Levels")
                                }
                                .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            // Timer
                            HStack(spacing: 8) {
                                Image(systemName: "timer")
                                    .foregroundColor(.blue)
                                Text(formatTime(elapsedTime))
                                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                            
                            Spacer()
                            
                            Text(level.title)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        // Title
                        Text("Tap Matching Colors")
                            .font(.title2)
                            .bold()
                        
                        // Message
                        Text(message)
                            .font(.body)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .frame(height: 50)
                            .animation(.easeInOut, value: message)
                        
                        // Grid
                        ScrollView {
                            LazyVGrid(
                                columns: Array(repeating: GridItem(.flexible()), count: level.gridSize),
                                spacing: 10
                            ) {
                                ForEach(0..<level.totalTiles, id: \.self) { index in
                                    Button {
                                        handleTap(index)
                                    } label: {
                                        Rectangle()
                                            .foregroundColor(items[index].color)
                                            .frame(
                                                width: getTileSize(screenWidth: geometry.size.width),
                                                height: getTileSize(screenWidth: geometry.size.width)
                                            )
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(
                                                        matched[index] ? Color.black :
                                                        selectedIndices.contains(index) ? Color.blue : Color.clear,
                                                        lineWidth: 4
                                                    )
                                            )
                                            .shadow(
                                                color: matched[index] ? .black.opacity(0.6) :
                                                       selectedIndices.contains(index) ? .blue.opacity(0.8) : .clear,
                                                radius: matched[index] ? 10 : selectedIndices.contains(index) ? 8 : 0
                                            )
                                            .scaleEffect(selectedIndices.contains(index) ? 0.9 : 1.0)
                                            .opacity(matched[index] ? 0.5 : 1.0)
                                            .animation(.spring(response: 0.3), value: selectedIndices)
                                    }
                                    .disabled(matched[index])
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Reset Button
                        Button {
                            setupGame()
                        } label: {
                            Text("Reset Game")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color.purple, Color.blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(15)
                                .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
            
            // Win Dialog
            if showWinDialog {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showWinDialog = false
                        showLevelSelection = true
                    }
                
                WinDialogView(
                    time: elapsedTime,
                    level: level,
                    onPlayAgain: {
                        showWinDialog = false
                        setupGame()
                    },
                    onBackToMenu: {
                        showWinDialog = false
                        showLevelSelection = true
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(), value: showWinDialog)
    }
    
    func getTileSize(screenWidth: CGFloat) -> CGFloat {
        let spacing: CGFloat = 10
        let padding: CGFloat = 40
        let availableWidth = screenWidth - padding - (spacing * CGFloat(level.gridSize - 1))
        return availableWidth / CGFloat(level.gridSize)
    }
    
    func setupGame() {
        stopTimer()
        var gameItems: [NamedColors] = []
        
        let numColors: Int
        switch level {
        case .easy: numColors = 3
        case .medium: numColors = 5
        case .hard: numColors = 7
        }
        
        let tilesPerColor = level.totalTiles / numColors
        
        for i in 0..<numColors {
            for _ in 0..<tilesPerColor {
                gameItems.append(allColors[i])
            }
        }
        
        items = gameItems.shuffled()
        matched = Array(repeating: false, count: level.totalTiles)
        selectedIndices.removeAll()
        message = "Tap all matching colors!"
        elapsedTime = 0
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            elapsedTime += 0.01
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func handleTap(_ index: Int) {
        if matched[index] { return }
        
        if let existingIndex = selectedIndices.firstIndex(of: index) {
            selectedIndices.remove(at: existingIndex)
            message = "Tap all matching colors!"
            return
        }
        
        selectedIndices.append(index)
        
        if selectedIndices.count == 1 {
            message = "Tap all \(items[index].colorName) colors!"
        } else {
            message = "\(selectedIndices.count) colors selected"
        }
        
        // Auto-check when all of one color is selected
        checkForAutoMatch()
    }
    
    func checkForAutoMatch() {
        if selectedIndices.isEmpty { return }
        
        let targetColor = items[selectedIndices[0]].colorName
        let allSameColor = selectedIndices.allSatisfy { items[$0].colorName == targetColor }
        
        if !allSameColor { return }
        
        let totalOfThisColor = items.filter { $0.colorName == targetColor }.count
        
        if selectedIndices.count == totalOfThisColor {
            for index in selectedIndices {
                matched[index] = true
            }
            
            withAnimation {
                message = " \(targetColor) matched!"
            }
            
            selectedIndices.removeAll()
            
            // Check if game is complete
            if matched.allSatisfy({ $0 }) {
                stopTimer()
                
                // Save high score
                let newScore = HighScore(level: level, time: elapsedTime)
                highScoreManager.addScore(newScore)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showWinDialog = true
                }
            }
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}
// ===== END: Game View =====

// ===== START: Win Dialog =====
struct WinDialogView: View {
    let time: TimeInterval
    let level: DifficultLevel
    let onPlayAgain: () -> Void
    let onBackToMenu: () -> Void
    
    var formattedTime: String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    var body: some View {
        VStack(spacing: 25) {
            // Confetti or celebration icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: .yellow.opacity(0.5), radius: 20)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 10) {
                Text("Congratulations!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("You completed \(level.rawValue) mode!")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            // Time display
            VStack(spacing: 8) {
                Text("Your Time")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(formattedTime)
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(15)
            
            // Buttons
            VStack(spacing: 12) {
                Button {
                    onPlayAgain()
                } label: {
                    Text("Play Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                
                Button {
                    onBackToMenu()
                } label: {
                    Text("Back to Menu")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding(40)
    }
}


#Preview {
    SquareGameTwo()
}
