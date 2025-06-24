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
        VStack(alignment: .leading, spacing: 0) {
            if pairingStore.pairings.isEmpty {
                Text("No script pairings yet")
                    .foregroundStyle(.secondary)
                    .padding(.all, 16)
            } else {
                Text("Scripts")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)

                ForEach(pairingStore.pairings) { pairing in
                    let isHovering = hoveredPairingID == pairing.id

                    Button(action: {
                        run(pairing: pairing)
                    }) {
                        HStack {
                            Text(pairing.effectiveDisplayName)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "arrow.right.circle")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(isHovering ? 0.08 : 0))
                        )
                    }
                    .buttonStyle(.plain)
                    .onHover { hovering in
                        hoveredPairingID = hovering ? pairing.id : nil
                    }
                }
            }

            Divider()
                .padding(.vertical, 8)

            VStack(spacing: 8) {
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
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }
                .buttonStyle(.plain)

                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    HStack {
                        Text("Quit")
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.bottom, 12)
        .frame(width: 300)
        .background(
            VisualEffectBlur(material: .popover, blendingMode: .behindWindow)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        )
        .shadow(radius: 30)
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
