//
//  DeviceHelper.swift
//  Yo-Yo
//
//  Created by Venkat Manavarthi on 5/5/25.
//

import SwiftUI

struct DeviceHelper {
    static var isWatch: Bool {
        #if os(watchOS)
        return true
        #else
        return false
        #endif
    }
}
