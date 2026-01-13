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
    var body: some View {
        Text("Square Game Two")
    }
}

#Preview {
    SquareGameTwo()
}
