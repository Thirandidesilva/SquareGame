//
//  RootView.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-29.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.hasUsername {
            GameSelectorView()
        } else {
            UsernameView()
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}

