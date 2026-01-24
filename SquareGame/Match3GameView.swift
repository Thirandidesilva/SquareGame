//
//  Match3GameView.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-21.
//

import SwiftUI
import Combine
// MARK: - Models

struct TileData: Identifiable {
    let id: String
    var row: Int
    var col: Int
    var tileColor: Color
    var symbolIcon: String
    var tileName: String
}

struct GameRecord: Identifiable, Codable {
    let id: UUID
    let finalScore: Int
    let recordDate: Date
    
    init(finalScore: Int) {
        self.id = UUID()
        self.finalScore = finalScore
        self.recordDate = Date()
    }
}

enum TileType {
    case redStar
    case blueCircle
    case greenHeart
    case purpleSquare
    case goldCrown
    
    var tileColor: Color {
        switch self {
        case .redStar: return .red
        case .blueCircle: return .blue
        case .greenHeart: return .green
        case .purpleSquare: return .purple
        case .goldCrown: return .orange
        }
    }
    
    var symbolIcon: String {
        switch self {
        case .redStar: return "star.fill"
        case .blueCircle: return "circle.fill"
        case .greenHeart: return "heart.fill"
        case .purpleSquare: return "square.fill"
        case .goldCrown: return "crown.fill"
        }
    }
    
    var tileName: String {
        switch self {
        case .redStar: return "Red Star"
        case .blueCircle: return "Blue Circle"
        case .greenHeart: return "Green Heart"
        case .purpleSquare: return "Purple Square"
        case .goldCrown: return "Gold Crown"
        }
    }
    
    static var allTypes: [TileType] {
        return [.redStar, .blueCircle, .greenHeart, .purpleSquare, .goldCrown]
    }
}

// MARK: - Record Manager

class RecordManager: ObservableObject {
    @Published var allRecords: [GameRecord] = []
    
    private let storageKey = "Match3GameRecords"
    
    init() {
        loadRecords()
    }
    
    func saveRecord(_ record: GameRecord) {
        allRecords.append(record)
        allRecords.sort { $0.finalScore > $1.finalScore }
        saveToStorage()
    }
    
    func getTopRecords(limit: Int = 10) -> [GameRecord] {
        return Array(allRecords.prefix(limit))
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(allRecords) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([GameRecord].self, from: data) {
            allRecords = decoded
        }
    }
}

// MARK: - Main Game View

struct Match3GameView: View {
    @StateObject private var recordManager = RecordManager()
    @State private var activeScreen: GameScreen = .mainMenu  // change this to .mainMenu
    
    enum GameScreen {
        case mainMenu
        case gameplay
        case leaderboard
    }
    
    var body: some View {
        Group {
            switch activeScreen {
            case .mainMenu:
                MainMenuView(
                    onStartGame: { activeScreen = .gameplay },
                    onShowLeaderboard: { activeScreen = .leaderboard }
                )
            case .gameplay:
                GameplayView(
                    onReturnHome: { activeScreen = .mainMenu },
                    recordManager: recordManager
                )
            case .leaderboard:
                LeaderboardView(
                    onReturnHome: { activeScreen = .mainMenu },
                    recordManager: recordManager
                )
            }
        }
    }
}

// MARK: - Main Menu View

struct MainMenuView: View {
    let onStartGame: () -> Void
    let onShowLeaderboard: () -> Void
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Color.pink.opacity(0.8),
                    Color.purple.opacity(0.8),
                    Color.indigo.opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Animated Icons
                HStack(spacing: 20) {
                    IconBox(color: .red, icon: "star.fill", delay: 0.0)
                    IconBox(color: .blue, icon: "circle.fill", delay: 0.1)
                    IconBox(color: .green, icon: "heart.fill", delay: 0.2)
                }
                
                // Title
                VStack(spacing: 10) {
                    Text("Color Matching")
                        .font(.system(size:40, weight: .semibold))
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    
                    Text("60 Second Rush")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.yellow)
                        .shadow(radius: 5)
                }
                
                // Subtitle
                Text("60 Seconds Max Score Challenge!")
                    .font(.headline)
                    .foregroundColor(.purple)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(20)
                
                Spacer()
                

                // Buttons
                VStack(spacing: 20) {
                    // Start Button
                    Button {
                        onStartGame()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 25))
                            Text("START")
                                .font(.system(size: 25, weight: .black))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: 320)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.yellow, Color.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(radius: 10)
                    }
                    
                    // High Scores Button
                    Button {
                        onShowLeaderboard()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.yellow)
                            Text("High Scores")
                                .font(.system(size: 25, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: 320)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(radius: 10)
                    }
                }
                .padding(.horizontal, 50)
                
                // Instructions
                VStack(spacing: 10) {
                    Text("How to Play ")
                        .font(.headline)
                        .foregroundColor(.purple)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Match 3 or more tiles in a row")
                                .font(.subheadline)
                        }
                        HStack {
            
                            Text("Score as many points as possible")
                                .font(.subheadline)
                        }
                        HStack {
                        
                            Text("You have 60 seconds!")
                                .font(.subheadline)
                        }
                    }
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .padding(.horizontal, 60)
                
                
                Spacer()
            }
        }
    }
}

struct IconBox: View {
    let color: Color
    let icon: String
    let delay: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .frame(width: 70, height: 70)
                .shadow(radius: 10)
            
            Image(systemName: icon)
                .font(.system(size: 35))
                .foregroundColor(.white)
        }
        .offset(y: -10)
        .animation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
                .delay(delay),
            value: UUID()
        )
    }
}

// MARK: - Leaderboard View

struct LeaderboardView: View {
    let onReturnHome: () -> Void
    @ObservedObject var recordManager: RecordManager
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color.pink.opacity(0.8),
                    Color.purple.opacity(0.8),
                    Color.indigo.opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                ZStack {
                    // Center title
                    HStack(spacing: 8) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.yellow)
                            
                        Text("High Scores")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }

                    // Left button
                    HStack {
                        Button {
                            onReturnHome()
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.purple)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .padding(.horizontal)

                
                // Records List
                let topRecords = recordManager.getTopRecords()
                
                if topRecords.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("No Scores Yet!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Play your first game to set a record!")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(25)
                    .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(topRecords.enumerated()), id: \.element.id) { index, record in
                                RecordRowView(record: record, position: index)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct RecordRowView: View {
    let record: GameRecord
    let position: Int
    
    var rankGradient: [Color] {
        switch position {
        case 0: return [.yellow, Color(red: 0.8, green: 0.6, blue: 0)]
        case 1: return [.gray, Color(red: 0.6, green: 0.6, blue: 0.6)]
        case 2: return [.orange, Color(red: 0.8, green: 0.4, blue: 0)]
        default: return [.blue, Color(red: 0.2, green: 0.4, blue: 0.8)]
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Rank Badge
            ZStack {
                LinearGradient(
                    colors: rankGradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 50, height: 50)
                .cornerRadius(15)
                
                if position < 3 {
                    VStack {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        Text("#\(position + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                } else {
                    Text("#\(position + 1)")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                }
            }
            
            // Score Info
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(record.finalScore)")
                        .font(.system(size: 25, weight: .black))
                        .foregroundColor(.purple)
                    Text("points")
                        .foregroundColor(.gray)
                }
                
                Text(formatDate(record.recordDate))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Medal for top 3
            if position < 3 {
                Text(position == 0 ? "🥇" : position == 1 ? "🥈" : "🥉")
                    .font(.system(size: 40))
            }
        }
        .padding()
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Gameplay View

struct GameplayView: View {
    let onReturnHome: () -> Void
    @ObservedObject var recordManager: RecordManager
    
    let BOARD_SIZE = 5
    let TIME_LIMIT: TimeInterval = 60.0
    
    @State private var gameBoard: [TileData] = []
    @State private var pickedCell: TileData? = nil
    @State private var countdown: TimeInterval = 60.0
    @State private var timerRunning = false
    @State private var playerScore = 0
    @State private var displayGameOver = false
    @State private var feedbackText = "Match 3 tiles to score!"
    @State private var streakCounter = 0
    
    // Time alert states
    @State private var showTimeAlert = false
    @State private var timeAlertText = ""
    @State private var didShow30SecAlert = false
    @State private var didShow10SecAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                // Background
                LinearGradient(
                    colors: [
                        Color.pink.opacity(0.8),
                        Color.purple.opacity(0.8),
                        Color.indigo.opacity(0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // MAIN CONTENT
                VStack(spacing: 20) {
                    
                    // HEADER
                    VStack(spacing: 15) {
                        HStack {
                            Button {
                                onReturnHome()
                            } label: {
                                Image(systemName: "house.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.purple)
                                    .cornerRadius(12)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.white)
                                Text(formatCountdown(countdown))
                                    .font(.system(size: 24, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                countdown <= 10
                                ? LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(14)
                            
                            Spacer()
                            
                            Button {
                                startNewGame()
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.orange)
                                    .cornerRadius(12)
                            }
                        }
                        
                        // Time progress bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 10)
                                    .cornerRadius(5)
                                
                                Rectangle()
                                    .fill(
                                        countdown <= 10
                                        ? LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
                                        : LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .frame(
                                        width: geo.size.width * CGFloat(countdown / TIME_LIMIT),
                                        height: 10
                                    )
                                    .cornerRadius(5)
                            }
                        }
                        .frame(height: 10)
                        
                        // Score
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("\(playerScore)")
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.orange)
                            Text("POINTS")
                                .foregroundColor(.orange)
                        }
                        
                        Text(feedbackText)
                            .font(.headline)
                            .foregroundColor(.purple)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.purple.opacity(0.15))
                            .cornerRadius(15)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    
                    // GAME BOARD
                    VStack(spacing: 15) {
                        ForEach(0..<BOARD_SIZE, id: \.self) { row in
                            HStack(spacing: 15) {
                                ForEach(0..<BOARD_SIZE, id: \.self) { col in
                                    if let tile = gameBoard.first(where: { $0.row == row && $0.col == col }) {
                                        TileView(
                                            tileData: tile,
                                            isChosen: pickedCell?.id == tile.id,
                                            onTileTap: {
                                                handleTileTap(tile)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .onAppear {
                    startNewGame()
                }
                
                //  TIME WARNING ALERT
                if showTimeAlert {
                    VStack {
                        Spacer()
                        Text(timeAlertText)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 25)
                            .background(
                                LinearGradient(
                                    colors: countdown <= 10 ? [.red, .orange] : [.orange, .yellow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding(.bottom, 120)
                    }
                }
                
                // GAME OVER OVERLAY
                if displayGameOver {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    GameOverDialog(
                        finalScore: playerScore,
                        onPlayAgain: {
                            displayGameOver = false
                            startNewGame()
                        },
                        onGoHome: {
                            displayGameOver = false
                            onReturnHome()
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - GAME LOGIC
    
    func startNewGame() {
        gameBoard = generateBoard()
        pickedCell = nil
        countdown = TIME_LIMIT
        playerScore = 0
        streakCounter = 0
        timerRunning = true
        displayGameOver = false
        feedbackText = "Match 3 tiles to score!"
        
        didShow30SecAlert = false
        didShow10SecAlert = false
        showTimeAlert = false
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if timerRunning && countdown > 0 {
                countdown -= 0.01
                
                if Int(countdown) == 30 && !didShow30SecAlert {
                    didShow30SecAlert = true
                    showQuickAlert(text: "⏳ Only 30 seconds left! Be quick!")
                }
                
                if Int(countdown) == 10 && !didShow10SecAlert {
                    didShow10SecAlert = true
                    showQuickAlert(text: "⚠️ Only 10 seconds left!")
                }
                
            } else if countdown <= 0 {
                timer.invalidate()
                endGame()
            }
        }
    }
    
    func showQuickAlert(text: String) {
        timeAlertText = text
        withAnimation {
            showTimeAlert = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showTimeAlert = false
            }
        }
    }
    
    func generateBoard() -> [TileData] {
        var tiles: [TileData] = []
        for row in 0..<BOARD_SIZE {
            for col in 0..<BOARD_SIZE {
                let randomType = TileType.allTypes.randomElement()!
                tiles.append(
                    TileData(
                        id: "\(row)-\(col)",
                        row: row,
                        col: col,
                        tileColor: randomType.tileColor,
                        symbolIcon: randomType.symbolIcon,
                        tileName: randomType.tileName
                    )
                )
            }
        }
        return tiles
    }
    
    func handleTileTap(_ tile: TileData) {
        if displayGameOver || countdown <= 0 { return }
        
        if pickedCell == nil {
            pickedCell = tile
            feedbackText = "Selected \(tile.tileName)"
        } else {
            if pickedCell!.id == tile.id {
                pickedCell = nil
                feedbackText = "Selection cleared"
                return
            }
            
            let isNextTo =
                (abs(pickedCell!.row - tile.row) == 1 && pickedCell!.col == tile.col) ||
                (abs(pickedCell!.col - tile.col) == 1 && pickedCell!.row == tile.row)
            
            if isNextTo {
                performSwap(pickedCell!, tile)
            } else {
                feedbackText = "Select adjacent tiles only!"
                pickedCell = nil
            }
        }
    }
    
    func performSwap(_ tile1: TileData, _ tile2: TileData) {
        withAnimation(.easeInOut(duration: 0.25)) {
            gameBoard = gameBoard.map { tile in
                if tile.id == tile1.id {
                    return TileData(
                        id: tile.id,
                        row: tile.row,
                        col: tile.col,
                        tileColor: tile2.tileColor,
                        symbolIcon: tile2.symbolIcon,
                        tileName: tile2.tileName
                    )
                } else if tile.id == tile2.id {
                    return TileData(
                        id: tile.id,
                        row: tile.row,
                        col: tile.col,
                        tileColor: tile1.tileColor,
                        symbolIcon: tile1.symbolIcon,
                        tileName: tile1.tileName
                    )
                }
                return tile
            }
        }
        
        pickedCell = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            findAndClearMatches()
        }
    }

    
    func findAndClearMatches() {
        var matchedTiles: Set<String> = []
        
        // Horizontal
        for row in 0..<BOARD_SIZE {
            for col in 0...(BOARD_SIZE - 3) {
                let tiles = [
                    gameBoard.first { $0.row == row && $0.col == col }!,
                    gameBoard.first { $0.row == row && $0.col == col + 1 }!,
                    gameBoard.first { $0.row == row && $0.col == col + 2 }!
                ]
                
                if tiles[0].tileColor == tiles[1].tileColor &&
                    tiles[1].tileColor == tiles[2].tileColor {
                    tiles.forEach { matchedTiles.insert($0.id) }
                }
            }
        }
        
        // Vertical
        for col in 0..<BOARD_SIZE {
            for row in 0...(BOARD_SIZE - 3) {
                let tiles = [
                    gameBoard.first { $0.row == row && $0.col == col }!,
                    gameBoard.first { $0.row == row + 1 && $0.col == col }!,
                    gameBoard.first { $0.row == row + 2 && $0.col == col }!
                ]
                
                if tiles[0].tileColor == tiles[1].tileColor &&
                    tiles[1].tileColor == tiles[2].tileColor {
                    tiles.forEach { matchedTiles.insert($0.id) }
                }
            }
        }
        
        if !matchedTiles.isEmpty {
            let matches = matchedTiles.count / 3
            let points = matches * 10
            playerScore += points
            
            streakCounter += 1
            
            feedbackText = streakCounter > 1
            ? "🔥 \(streakCounter)x COMBO! +\(points + streakCounter * 5)"
            : "✨ Match! +\(points) points!"
            
            if streakCounter > 1 {
                playerScore += streakCounter * 5
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                refillTiles(Array(matchedTiles))
            }
        } else {
            feedbackText = "No matches. Try again!"
            streakCounter = 0
        }
    }
    
    func refillTiles(_ matchedIds: [String]) {
        gameBoard = gameBoard.map { tile in
            if matchedIds.contains(tile.id) {
                let randomType = TileType.allTypes.randomElement()!
                return TileData(
                    id: tile.id,
                    row: tile.row,
                    col: tile.col,
                    tileColor: randomType.tileColor,
                    symbolIcon: randomType.symbolIcon,
                    tileName: randomType.tileName
                )
            }
            return tile
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            findAndClearMatches()
        }
    }
    
    func endGame() {
        timerRunning = false
        recordManager.saveRecord(GameRecord(finalScore: playerScore))
        displayGameOver = true
    }
    
    func formatCountdown(_ time: TimeInterval) -> String {
        let seconds = Int(time)
        let ms = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d.%02d", seconds, ms)
    }
}

struct TileView: View {
    let tileData: TileData
    let isChosen: Bool
    let onTileTap: () -> Void
    
    var body: some View {
        Button(action: onTileTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(tileData.tileColor)
                    .shadow(radius: isChosen ? 0 : 5)
                
                Image(systemName: tileData.symbolIcon)
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                
                if isChosen {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 4)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .scaleEffect(isChosen ? 1.1 : 1.0)
            .animation(.spring(response: 0.3), value: isChosen)
        }
    }
}

struct GameOverDialog: View {
    let finalScore: Int
    let onPlayAgain: () -> Void
    let onGoHome: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            // Trophy Icon
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 90, height: 90)
                    .shadow(radius: 20)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.yellow)
            }
            
            // Title
            VStack(spacing: 10) {
                Text("TIME'S UP!")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                Text("Great Job!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Score
            VStack(spacing: 10) {
                Text("FINAL SCORE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 45))
                        .foregroundColor(.yellow)
                    
                    Text("\(finalScore)")
                        .font(.system(size: 44, weight: .black))
                        .foregroundColor(.purple)
                }
                
                Text("POINTS")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(20)
            
            // Buttons
            VStack(spacing: 15) {
                Button {
                    onPlayAgain()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Play Again")
                    }
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,12)
                    .background(Color.white)
                    .cornerRadius(20)
                }
                
                Button {
                    onGoHome()
                } label: {
                    HStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,12)
                    .background(Color.purple)
                    .cornerRadius(20)
                }
            }
        }
        .frame(maxWidth:340)
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.purple, Color.pink, Color.orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(30)
        .shadow(radius: 30)
        .padding(20)
    }
}
// MARK: - Preview
#Preview {
Match3GameView()
}
