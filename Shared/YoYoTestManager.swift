//
//  YoYoTestManager.swift
//  Yo-Yo
//
//  Created by Venkat Manavarthi on 5/5/25.
//

import Foundation
import Combine

class YoYoTestManager: ObservableObject {
    @Published var level: Int = 1
    @Published var shuttle: Int = 1
    @Published var timeRemaining: Double = 0
    @Published var isResting: Bool = false
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    
    private var timer: AnyCancellable?
    
    func startTest() {
        guard !isRunning else { return }
        isRunning = true
        isPaused = false
        level = 1
        shuttle = 1
        startShuttle()
    }
    
    func stopTest() {
        timer?.cancel()
        isRunning = false
        isPaused = false
        timeRemaining = 0
    }
    
    func pauseTest() {
        guard isRunning, !isPaused else { return }
        isPaused = true
        timer?.cancel()
    }
    
    func resumeTest() {
        guard isRunning, isPaused else { return }
        isPaused = false
        startTimer()
    }
    
    private func startShuttle() {
        timeRemaining = 40.0 / YoYoLevel.paceForLevel(level)
        isResting = false
        startTimer()
    }
    
    private func startRest() {
        timeRemaining = 10.0
        isResting = true
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    private func tick() {
        guard !isPaused else { return }
        timeRemaining -= 0.1
        if timeRemaining <= 0 {
            timer?.cancel()
            if isResting {
                shuttle += 1
                if shuttle > 8 {
                    shuttle = 1
                    level += 1
                }
                startShuttle()
            } else {
                startRest()
            }
        }
    }
}

