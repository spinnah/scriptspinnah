//
//  ScriptPanelWindow.swift v1.0
//  ScriptSpinnah
//
//  Created by ShastLeLow on 2025-06-26.
//
//  Main popover panel UI with collapsible sections and Liquid Glass styling.
//  Displays organized script pairings with Settings/Quit controls.
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
                if pairingStore.sections.isEmpty {
                    Text("No sections yet")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.all, 16)
                } else {
                    // Script sections - always show sections, even if empty
                    ForEach(pairingStore.sections) { section in
                        let sectionPairings = pairingStore.pairings.filter { $0.sectionName == section.name }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            // Section header
                            Button(action: {
                                pairingStore.toggleSectionCollapse(section)
                            }) {
                                HStack(spacing: 12) {
                                    // Icon in circle
                                    ZStack {
                                        Circle()
                                            .fill(.tertiary)
                                            .frame(width: 28, height: 28)
                                        Image(systemName: section.iconName)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(.primary)
                                    }
                                    
                                    Text(section.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: section.isCollapsed ? "chevron.right" : "chevron.down")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                            }
                            .buttonStyle(.plain)
                            
                            // Section content
                            if !section.isCollapsed {
                                if sectionPairings.isEmpty {
                                    Text("No scripts in this section")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 52)
                                        .padding(.trailing, 20)
                                        .padding(.vertical, 4)
                                } else {
                                    ForEach(sectionPairings) { pairing in
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
                                            .padding(.vertical, 6)
                                            .padding(.leading, 52) // Indent under icon
                                            .padding(.trailing, 20)
                                        }
                                        .buttonStyle(.plain)
                                        .background(
                                            hoveredPairingID == pairing.id ?
                                            Color.accentColor.opacity(0.08) : Color.clear
                                        )
                                        .onHover { hovering in
                                            hoveredPairingID = hovering ? pairing.id : nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Divider()
                    .padding(.vertical, 12)

                // Settings and Quit section
                VStack(spacing: 0) {
                    Button(action: {
                        let settingsWindow = SettingsWindow(
                            contentRect: NSRect(x: 0, y: 0, width: 500, height: 100),
                            styleMask: [.borderless],
                            backing: .buffered, defer: false
                        )
                        
                        let hostingView = NSHostingView(
                            rootView: SettingsView().environmentObject(pairingStore)
                        )
                        settingsWindow.contentView = hostingView
                        
                        // Auto-size the window to fit content
                        hostingView.translatesAutoresizingMaskIntoConstraints = false
                        let size = hostingView.fittingSize
                        settingsWindow.setContentSize(size)
                        settingsWindow.center()
                        
                        let controller = NSWindowController(window: settingsWindow)
                        controller.showWindow(nil)
                        settingsWindow.makeKeyAndOrderFront(nil)
                        NSApp.activate(ignoringOtherApps: true)
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.tertiary)
                                    .frame(width: 28, height: 28)
                                Image(systemName: "gear")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.primary)
                            }
                            
                            Text("Settings")
                                .font(.body)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(.plain)

                    Button(action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.tertiary)
                                    .frame(width: 28, height: 28)
                                Image(systemName: "power")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.primary)
                            }
                            
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
            .padding(.vertical, 16)
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
