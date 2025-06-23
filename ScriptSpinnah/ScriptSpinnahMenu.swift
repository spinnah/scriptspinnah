//
//  ScriptSpinnahMenu.swift v1
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  Menu bar dropdown for ScriptSpinnah, rendered from MenuBarExtra.
//  Handles script execution and opening the Settings window.
//
//  CS-142: Connect static menu actions to script runner.
//

import SwiftUI
import Combine

// ObservableObject to hold the shared script URL context
class ScriptContext: ObservableObject {
    @Published var grantedScriptURL: URL?
}

struct ScriptSpinnahMenu: View {
    @Environment(\.openWindow) private var openWindow
    @EnvironmentObject var scriptContext: ScriptContext

    var body: some View {
        VStack {
            Button("Run Example Script") {
                guard let scriptURL = scriptContext.grantedScriptURL else {
                    print("⚠️ No script URL has been granted via SettingsView.")
                    return
                }
                if scriptURL.startAccessingSecurityScopedResource() {
                    defer { scriptURL.stopAccessingSecurityScopedResource() }
                    let folder = "/Users/shawnstarbird/Documents/GitHub/ScriptSpinnah/TestData/TestFolder"
                    ScriptExecutor.run(scriptURL: scriptURL, with: folder)
                } else {
                    print("❌ Failed to access security-scoped resource")
                }
            }

            Divider()

            Button("Settings…") {
                openWindow(id: "settings")
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
