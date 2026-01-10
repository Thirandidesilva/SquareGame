//
//  ContentView.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Square Game")
                .font(.title)
                .bold()
                .padding()
              Text("PICK COLOURS TO MATCH THE SQUARES")
                .padding(.bottom,600)
        }
        
    }
}

#Preview {
    ContentView()
}
