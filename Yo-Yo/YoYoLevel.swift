//
//  YoYoLevel.swift
//  Yo-Yo
//
//  Created by Venkat Manavarthi on 5/5/25.
//

import Foundation

struct YoYoLevel {
    let level: Int
    let shuttleCount: Int
    let speed: Double // meters per second
    
    static func paceForLevel(_ level: Int) -> Double {
        // Example table: Level 1 = 10 km/h, Level 2 = 10.5 km/h, etc.
        let kmph = 10.0 + (Double(level - 1) * 0.5)
        return kmph * 1000 / 3600 // convert to meters per second
    }
}
