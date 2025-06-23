//
//  SettingsView.swift v3
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  CS-143: Add pairing UI with script bookmark storage and dynamic list rendering
//
//  This view allows users to pair a shell script with a folder.
//  It persists a security-scoped bookmark for the script and lists all current pairings.
//

import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct SettingsView: View {
    @EnvironmentObject var pairingStore: ScriptPairingStore

    @State private var showingScriptImporter = false
    @State private var showingFolderPicker = false

    @State private var selectedFolderPath: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Script Pairings")
                .font(.title2.bold())

            if pairingStore.pairings.isEmpty {
                Text("No pairings yet. Add one below.")
                    .foregroundStyle(.secondary)
            } else {
                List {
                    ForEach(pairingStore.pairings) { pairing in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pairing.scriptName)
                                .font(.headline)
                            Text(pairing.folderPath)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        pairingStore.pairings.remove(atOffsets: indexSet)
                    }
                }
                .frame(maxHeight: 300)
            }

            Divider()

            HStack {
                Button("Choose Folder") {
                    showingFolderPicker = true
                }

                if let folder = selectedFolderPath {
                    Text("📂 \(folder)")
                        .font(.caption)
                        .lineLimit(1)
                } else {
                    Text("No folder selected")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Button("Add Pairing…") {
                print("🟡 Add Pairing tapped")

                let panel = NSOpenPanel()
                panel.allowedContentTypes = [.item]
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.canChooseFiles = true
                panel.title = "Choose a Script File"

                if panel.runModal() == .OK, let scriptURL = panel.url {
                    do {
                        if scriptURL.startAccessingSecurityScopedResource() {
                            defer { scriptURL.stopAccessingSecurityScopedResource() }

                            let bookmark = try scriptURL.bookmarkData(
                                options: [.withSecurityScope],
                                includingResourceValuesForKeys: nil,
                                relativeTo: nil
                            )

                            guard let folderPath = selectedFolderPath else { return }

                            let pairing = ScriptPairing(
                                scriptName: scriptURL.lastPathComponent,
                                folderPath: folderPath,
                                scriptBookmarkData: bookmark
                            )

                            pairingStore.pairings.append(pairing)
                            print("✅ Access granted to: \(scriptURL.path)")
                        } else {
                            print("❌ Failed to access: \(scriptURL.path)")
                        }
                    } catch {
                        print("❌ Script selection failed: \(error.localizedDescription)")
                    }
                }
            }
            .disabled(selectedFolderPath == nil)

            Spacer()
        }
        .padding(20)
        .frame(width: 460)
        /*
        .fileImporter(
            isPresented: $showingScriptImporter,
            allowedContentTypes: [.item],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let scriptURL = try result.get().first else { return }

                if scriptURL.startAccessingSecurityScopedResource() {
                    defer { scriptURL.stopAccessingSecurityScopedResource() }

                    let bookmark = try scriptURL.bookmarkData(
                        options: [.withSecurityScope],
                        includingResourceValuesForKeys: nil,
                        relativeTo: nil
                    )

                    guard let folderPath = selectedFolderPath else { return }

                    let pairing = ScriptPairing(
                        scriptName: scriptURL.lastPathComponent,
                        folderPath: folderPath,
                        scriptBookmarkData: bookmark
                    )

                    pairingStore.pairings.append(pairing)
                    print("✅ Access granted to: \(scriptURL.path)")
                } else {
                    print("❌ Failed to access: \(scriptURL.path)")
                }
            } catch {
                print("❌ File import error: \(error.localizedDescription)")
            }
        }
        */
        .fileImporter(
            isPresented: $showingFolderPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let folderURL = try result.get().first else { return }
                selectedFolderPath = folderURL.path
            } catch {
                print("❌ Folder selection failed: \(error.localizedDescription)")
            }
        }
    }
}
