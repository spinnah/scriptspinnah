//
//  ScriptPanelView.swift v1
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/24/25.
//
//  CS-151: Liquid Glass-style popover panel styled like macOS 26 Wi-Fi menu
//
//  This view is shown in a .popover and lists the script/folder pairings
//  with options to open Settings or Quit the app.
//

import SwiftUI

struct ScriptPanelView: View {
    @EnvironmentObject var pairingStore: ScriptPairingStore
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if pairingStore.pairings.isEmpty {
                Text("No script pairings yet")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ForEach(pairingStore.pairings) { pairing in
                    Button(action: {
                        run(pairing: pairing)
                    }) {
                        HStack {
                            Text(pairing.effectiveDisplayName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "arrow.right.circle")
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                    }
                    .buttonStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor.opacity(0.1))
                            .opacity(0)
                    )
                }
            }

            Divider()
                .padding(.vertical, 8)

            VStack(spacing: 8) {
                Button("Open Settings") {
                    openWindow(id: "Settings")
                }

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        // Background material is now applied via the NSPanel in FloatingPanel.swift
        .cornerRadius(20)
        .shadow(radius: 25)
        .frame(width: 300)
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
