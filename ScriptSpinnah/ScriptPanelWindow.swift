//
//  ScriptPanelWindow.swift v1
//  ScriptSpinnah
//
//  Floating translucent panel styled like macOS 26 system controls.
//

import SwiftUI
import AppKit

struct ScriptPanelWindow: View {
    @EnvironmentObject var pairingStore: ScriptPairingStore
    @Binding var isVisible: Bool
    @State private var hoveredPairingID: UUID?

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                if pairingStore.pairings.isEmpty {
                    Text("No script pairings yet")
                        .font(.body)
                        .padding(.all, 16)
                } else {
                    Text("Scripts")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 16)
                        .padding(.horizontal, 20)

                    ForEach(pairingStore.pairings) { pairing in
                        Button(action: {
                            run(pairing: pairing)
                        }) {
                            HStack {
                                Text(pairing.effectiveDisplayName)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "arrow.right.circle")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 0)
                        }
                        .buttonStyle(.plain)
                        .onHover { hovering in
                            hoveredPairingID = hovering ? pairing.id : nil
                        }
                    }
                }

                Divider()
                    .padding(.vertical, 8)

                VStack(spacing: 0) {
                    Button(action: {
                        let settingsWindow = NSWindow(
                            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
                            styleMask: [.titled, .closable, .resizable],
                            backing: .buffered, defer: false
                        )
                        settingsWindow.center()
                        settingsWindow.title = "Settings"
                        settingsWindow.contentView = NSHostingView(
                            rootView: SettingsView().environmentObject(pairingStore)
                        )
                        let controller = NSWindowController(window: settingsWindow)
                        controller.showWindow(nil)
                    }) {
                        HStack {
                            Text("Open Settings")
                                .font(.body)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(.plain)

                    Divider()
                        .padding(.vertical, 8)

                    Button(action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        HStack {
                            Text("Quit")
                                .font(.body)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 20)
        }
        .frame(width: 320)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.13), radius: 16, y: 2)
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

/*
// COMMENTED OUT: Custom VisualEffectBlur struct - not needed with macOS 26 Liquid Glass
// The new .thinMaterial background modifier provides proper Liquid Glass effects automatically
// This custom NSViewRepresentable was conflicting with SwiftUI's built-in material system
// Can be restored if needed, but should use SwiftUI materials for macOS 26 compliance

struct VisualEffectBlur: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var state: NSVisualEffectView.State = .active

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = state
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = state
    }
}
*/
