//
//  ContentView.swift
//  SquareGame
//
//  Created by Thirandi De Silva on 2026-01-10.
//

import SwiftUI

struct NamedColor{
    var color: Color
    var name: String
}
struct ContentView: View {
    
    @State var items: [NamedColor] = [
        NamedColor(color: .blue, name: "Blue"),
        NamedColor(color: .pink, name: "Pink"),
        NamedColor(color: .yellow, name: "Yellow"),
        NamedColor(color: .green, name: "Green"),
        NamedColor(color: .blue, name: "Blue"),
        NamedColor(color: .pink, name: "Pink"),
        NamedColor(color: .yellow, name: "Yellow"),
        NamedColor(color: .green, name: "Green"),
        NamedColor(color: .blue, name: "Blue")
    ].shuffled()
    
    @State var selectedIndices: [Int] = []
    @State var matched = Array(repeating: false, count: 9)
    @State var message = "Tap All Matching Colors!"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Color Matching Game")
                .font(.largeTitle)
                .bold()
              Text(message)
                .font(.title3)
                .foregroundStyle(Color.blue)
                .multilineTextAlignment(.center)
                .frame(height:60)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                ForEach(0..<9) { index in
                Button {
                handleTap(index)
                } label: {
                    
                Rectangle()
                .foregroundColor(items[index].color)
                .frame(width: 100, height: 100)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(matched[index] ? Color.black :selectedIndices.contains(index) ? Color.blue : Color.clear,lineWidth: 6))
                .shadow(color: matched[index] ? .black.opacity(0.6) :selectedIndices.contains(index) ? .blue.opacity(0.8) : .clear,radius: matched[index] ? 15 : selectedIndices.contains(index) ? 10 : 0)
                .scaleEffect(selectedIndices.contains(index) ? 0.95 : 1.0).opacity(matched[index] ? 0.5 : 1.0)
            }
            .disabled(matched[index])
        }
        }
                HStack(spacing: 15) {
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
                                    colors: [Color.green, Color(red: 0.3, green: 0.8, blue: 0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    } // END: Button label
                    .disabled(selectedIndices.isEmpty)
                    .opacity(selectedIndices.isEmpty ? 0.5 : 1.0)
                    Button {
                        resetGame()
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
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    
                }
        }
        .padding()
        
    }
    
    //function handle tap
    func handleTap(_ index: Int){
        if matched[index] {return}
        
        if let existingIndex = selectedIndices.firstIndex(of:index){
            selectedIndices.remove(at: existingIndex)
            message = "Tap All Matching Colors, Then Check!"
            return
        }
        
        selectedIndices.append(index)
        if selectedIndices.count == 1{
            message = "Tap All \(items[index].name) Colors!"
        }
        else{
            message = "\(selectedIndices.count) selected. Tap Check Match to verify!"
        }
    }
    
   // function Check Match
    
    func checkMatch() {
        if selectedIndices.isEmpty {
            message = "Please select some colors first!"
            return
        }
        
        // Get the color name of the first selected item
        let targetColor = items[selectedIndices[0]].name
        
        // Check if all selected items are the same color
        let allSameColor = selectedIndices.allSatisfy { items[$0].name == targetColor }
        
        if !allSameColor {
            message = "Not all the same color! Try again!"
            selectedIndices.removeAll()
            return
        }
        
        // Count how many of this color exist in total
        let totalOfThisColor = items.filter { $0.name == targetColor }.count
        
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
                    message = "You won! All colors matched!"
                }
            }
        } else {
            message = "You found \(selectedIndices.count) but there are \(totalOfThisColor) \(targetColor)(s)! Find them all!"
            selectedIndices.removeAll()
        }
    }
    
    // Reset Game Function
    
    func resetGame() {
            items = [
                NamedColor(color: .blue, name: "Blue"),
                NamedColor(color: .pink, name: "Pink"),
                NamedColor(color: .yellow, name: "Yellow"),
                NamedColor(color: .green, name: "Green"),
                NamedColor(color: .blue, name: "Blue"),
                NamedColor(color: .pink, name: "Pink"),
                NamedColor(color: .yellow, name: "Yellow"),
                NamedColor(color: .green, name: "Green"),
                NamedColor(color: .blue, name: "Blue")
            ].shuffled()
            
            matched = Array(repeating: false, count: 9)
            selectedIndices.removeAll()
            message = "Tap all matching colors!"
        }
    
}

#Preview {
    ContentView()
}
