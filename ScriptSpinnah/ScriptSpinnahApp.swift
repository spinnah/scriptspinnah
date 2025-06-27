//
//  ScriptSpinnahApp.swift v1.0
//  ScriptSpinnah
//
//  Created by ShastLeLow on 2025-06-26.
//
//  Main SwiftUI app entry point for menu bar-only operation.
//  Configures AppDelegate and shared data store for macOS 26 Tahoe.
//

import SwiftUI

@main
struct ScriptSpinnahApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var pairingStore = ScriptPairingStore()
    
    var body: some Scene {
        // We don't want a main window - the app runs entirely from the menu bar
        Settings {
            SettingsView()
                .environmentObject(pairingStore)
        }
    }
}
