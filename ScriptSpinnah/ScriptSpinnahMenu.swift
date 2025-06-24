//
//  ScriptSpinnahMenu.swift v2
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  CS-143: Wire menu items to run the correct script for each configured folder
//
//  Renders the dynamic menubar dropdown with script/folder pairings.
//  Runs each script via security-scoped bookmark resolution.
//

import SwiftUI
import Combine

struct ScriptSpinnahMenu: View {
    @EnvironmentObject var pairingStore: ScriptPairingStore
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack {
            if pairingStore.pairings.isEmpty {
                Text("No script pairings yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(pairingStore.pairings) { pairing in
                    Button(pairing.effectiveDisplayName) {
                        run(pairing: pairing)
                    }
                }
            }

            Divider()

            Button("Open Settings") {
                openWindow(id: "Settings")
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(8)
    }

    private func run(pairing: ScriptPairing) {
        do {
            var isStale = false
            let scriptURL = try URL(
                resolvingBookmarkData: pairing.scriptBookmarkData,
                options: [.withSecurityScope],
                bookmarkDataIsStale: &isStale
            )

            if scriptURL.startAccessingSecurityScopedResource() {
                defer { scriptURL.stopAccessingSecurityScopedResource() }
                ScriptExecutor.run(scriptURL: scriptURL, with: pairing.folderPath)
            } else {
                print("❌ Failed to access secure bookmark for \(pairing.scriptName)")
            }
        } catch {
            print("❌ Failed to resolve bookmark for \(pairing.scriptName): \(error)")
        }
    }
}
