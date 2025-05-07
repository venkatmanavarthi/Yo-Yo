//
//  YoYoTestView.swift
//  Yo-Yo
//
//  Created by Venkat Manavarthi on 5/5/25.
//

import SwiftUI

struct YoYoTestView: View {
    @StateObject private var manager = YoYoTestManager()

    // Check if it's WatchOS
    var isWatch: Bool {
        #if os(watchOS)
        return true
        #else
        return false
        #endif
    }

    var body: some View {
        VStack(spacing: isWatch ? 10 : 20) {
            levelShuttleView
            timerCircle
            statusText
            controlButtons
        }
        .frame(maxWidth: isWatch ? 200 : .infinity, maxHeight: .infinity)
        .background(isWatch ? Color.black.opacity(0.1) : Color.white)
        .cornerRadius(isWatch ? 16 : 0)
        .padding(isWatch ? 10 : 20)
    }

    private var levelShuttleView: some View {
        VStack(spacing: 8) {
            Text("Level \(manager.level)")
                .font(isWatch ? .system(size: 14, weight: .bold) : .system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Shuttle \(manager.shuttle)")
                .font(isWatch ? .system(size: 12) : .system(size: 20, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(isWatch ? 5 : 10)
    }
    
    private var timerCircle: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: isWatch ? 6 : 12)  // Thinner stroke on Watch
            
            Circle()
                .trim(from: 0, to: CGFloat(manager.timeRemaining / maxTime()))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.green, .blue, .purple]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: isWatch ? 6 : 12, lineCap: .round)  // Thinner stroke on Watch
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: manager.timeRemaining)
            
            Text(timeString())
                .font(isWatch ? .system(size: 18, weight: .bold, design: .monospaced) : .system(size: 28, weight: .bold))
        }
        .frame(width: isWatch ? 100 : 200, height: isWatch ? 100 : 200)  // Smaller circle on Watch
    }
    
    private var statusText: some View {
        Text(manager.isPaused ? "Paused" : (manager.isResting ? "Resting" : "Running"))
            .font(isWatch ? .system(size: 12) : .system(size: 20, weight: .semibold))
            .foregroundColor(manager.isPaused ? .orange : (manager.isResting ? .blue : .green))
    }
    
    private var controlButtons: some View {
        HStack(spacing: isWatch ? 10 : 20) {
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
        .padding(isWatch ? 5 : 20)
    }
    
    private func timeString() -> String {
        let seconds = Int(manager.timeRemaining)
        let tenths = Int((manager.timeRemaining - Double(seconds)) * 10)
        return String(format: "%02d.%d", seconds, tenths)
    }
    
    private func maxTime() -> Double {
        manager.isResting ? 10.0 : 40.0 / YoYoLevel.paceForLevel(manager.level)
    }
    
    private func actionButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(isWatch ? .system(size: 14, weight: .bold) : .system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: isWatch ? 50 : 100, height: isWatch ? 30 : 44)
                .background(color)
                .cornerRadius(10)
        }
    }
}
