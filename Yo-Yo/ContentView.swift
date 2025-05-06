//
//  ContentView.swift
//  Yo-Yo
//
//  Created by Venkat Manavarthi on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var manager = YoYoTestManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // Level and Shuttle
            VStack(spacing: 8) {
                Text("Level \(manager.level)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Shuttle \(manager.shuttle)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            // Timer Circle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: CGFloat(manager.timeRemaining / maxTime()))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.green, .blue, .purple]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: manager.timeRemaining)
                
                Text(timeString())
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
            }
            .frame(width: 200, height: 200)
            
            // Status
            Text(manager.isPaused ? "Paused" : (manager.isResting ? "Resting" : "Running"))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(manager.isPaused ? .orange : (manager.isResting ? .blue : .green))
            
            // Buttons
            HStack(spacing: 20) {
                if !manager.isRunning {
                    actionButton(title: "Start", color: .green) {
                        manager.startTest()
                    }
                } else {
                    actionButton(title: manager.isPaused ? "Resume" : "Pause", color: .orange) {
                        manager.isPaused ? manager.resumeTest() : manager.pauseTest()
                    }
                    
                    actionButton(title: "Stop", color: .red) {
                        manager.stopTest()
                    }
                }
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    // Helper to format time
    private func timeString() -> String {
        let seconds = Int(manager.timeRemaining)
        let tenths = Int((manager.timeRemaining - Double(seconds)) * 10)
        return String(format: "%02d.%d", seconds, tenths)
    }
    
    // Max time based on resting or running
    private func maxTime() -> Double {
        manager.isResting ? 10.0 : 40.0 / YoYoLevel.paceForLevel(manager.level)
    }
    
    // Reusable button
    private func actionButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 100, height: 44)
                .background(color)
                .cornerRadius(12)
        }
    }
}


#Preview {
    ContentView()
}
