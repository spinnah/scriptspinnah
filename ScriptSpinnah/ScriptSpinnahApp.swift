//
//  ScriptSpinnahApp.swift v6
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  Entry point for ScriptSpinnah, a macOS menu bar app
//  that lets users run custom scripts on selected folders.
//  Opens the Settings window using openWindow without relying on beta-only APIs.
//

import SwiftUI

@main
struct ScriptSpinnahApp: App {
    @StateObject private var scriptContext = ScriptContext()
    
    var body: some Scene {
        MenuBarExtra("ScriptSpinnah", image: "spiderweb") {
            ScriptSpinnahMenu()
                .environmentObject(scriptContext)
        }

        Window("Settings", id: "settings") {
            SettingsView()
                .environmentObject(scriptContext)
        }
        .defaultSize(width: 420, height: 360)
        .handlesExternalEvents(matching: ["settings"])
        .commandsRemoved()
    }
}
