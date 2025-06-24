//
//  ScriptSpinnahApp.swift v8.1
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/24/25.
//
//  Uses a floating glass-style panel (like Shazam/Spotlight) triggered by a menu bar icon.
//

import SwiftUI

struct ScriptSpinnahApp: App {
    @StateObject private var pairingStore = ScriptPairingStore()
    @State private var isPanelVisible = false

    var body: some Scene {
        MenuBarExtra("ScriptSpinnah", image: "spiderweb") {
            Text("") // Transparent placeholder
                .padding(1)
                .onAppear {
                    print("💥 MenuBarExtra clicked")
                    isPanelVisible.toggle()
                }
        }

        // Floating panel window
        WindowGroup(id: "ScriptPanel") {
            if isPanelVisible {
                ScriptPanelWindow(isVisible: $isPanelVisible)
                    .environmentObject(pairingStore)
            }
        }
        .defaultSize(width: 320, height: 400)
        .windowResizability(.contentSize)
        .windowStyle(.plain)

        Window("Settings", id: "Settings") {
            SettingsView()
                .environmentObject(pairingStore)
        }
    }
}
