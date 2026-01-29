//
//  SquareGameApp.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-10.
//

import SwiftUI

@main
struct SquareGameApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("username") private var username = ""

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .onAppear {
                    appState.hasUsername = !username.isEmpty
                }
        }
    }
}

