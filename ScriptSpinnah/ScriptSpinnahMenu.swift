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

struct ScriptSpinnahMenu: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack {
            Button("Run Example Script") {
                // Replace with real paths for testing
                let script = "/Users/shawnstarbird/test.sh"
                let folder = "/Users/shawnstarbird/Documents/TestFolder"
                ScriptExecutor.run(scriptPath: script, with: folder)
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