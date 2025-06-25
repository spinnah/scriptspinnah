//
//  ScriptSpinnahApp.swift v1
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/24/25.
//
//  Main app structure for macOS 26 Tahoe with proper SwiftUI App lifecycle
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
