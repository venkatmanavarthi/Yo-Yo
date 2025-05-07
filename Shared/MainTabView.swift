//
//  MainTabView.swift
//  Yo-Yo
//
//  Created by Venkat Manavarthi on 5/6/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            YoYoTestView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("YoYo")
                }
            
            ActivityView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Activity")
                }
        }
    }
}

#Preview {
    MainTabView()
}
