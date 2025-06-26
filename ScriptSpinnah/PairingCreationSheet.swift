//
//  PairingCreationSheet.swift v0.20250626-145400
//  ScriptSpinnah
//
//  Pairing creation sheet with native macOS styling
//

import SwiftUI
import UniformTypeIdentifiers

struct PairingCreationSheet: View {
    @ObservedObject var pairingStore: ScriptPairingStore
    @Binding var newPairingDisplayName: String
    @Binding var selectedScriptURL: URL?
    @Binding var selectedFolderURL: URL?
    @Binding var selectedPairingSectionName: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Create New Pairing")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Form content
            Form {
                Section("Script File") {
                    HStack {
                        Button("Choose Script...") {
                            let panel = NSOpenPanel()
                            panel.allowedContentTypes = [.item]
                            panel.allowsMultipleSelection = false
                            panel.canChooseDirectories = false
                            panel.canChooseFiles = true
                            panel.title = "Choose a Script File"
                            
                            if panel.runModal() == .OK {
                                selectedScriptURL = panel.url
                            }
                        }
                        
                        Spacer()
                        
                        if let scriptURL = selectedScriptURL {
                            Text(scriptURL.lastPathComponent)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("No script selected")
                                .font(.body)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                Section("Target Folder") {
                    HStack {
                        Button("Choose Folder...") {
                            let panel = NSOpenPanel()
                            panel.allowedContentTypes = [.folder]
                            panel.allowsMultipleSelection = false
                            panel.canChooseDirectories = true
                            panel.canChooseFiles = false
                            panel.title = "Choose Target Folder"
                            
                            if panel.runModal() == .OK {
                                selectedFolderURL = panel.url
                            }
                        }
                        
                        Spacer()
                        
                        if let folderURL = selectedFolderURL {
                            Text(folderURL.lastPathComponent)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("No folder selected")
                                .font(.body)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                Section("Organization") {
                    HStack {
                        Text("Section")
                        Spacer()
                        Picker("Section", selection: $selectedPairingSectionName) {
                            ForEach(pairingStore.sections, id: \.name) { section in
                                Text(section.name).tag(section.name)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: 200)
                    }
                    
                    HStack {
                        Text("Display Name")
                        Spacer()
                        TextField("Optional custom name", text: $newPairingDisplayName)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 200)
                    }
                }
            }
            .formStyle(.grouped)
            
            // Button bar
            HStack {
                Button("Cancel") {
                    resetForm()
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                Button("Create Pairing") {
                    createPairing()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
                .disabled(selectedScriptURL == nil || selectedFolderURL == nil)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.regularMaterial)
        }
        .frame(width: 480)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxHeight: 500)
        .background(.thinMaterial)
        .onAppear {
            selectedPairingSectionName = pairingStore.sections.first?.name ?? "General"
        }
    }
    
    private func createPairing() {
        guard let scriptURL = selectedScriptURL,
              let folderURL = selectedFolderURL else { return }
        
        do {
            if scriptURL.startAccessingSecurityScopedResource() {
                defer { scriptURL.stopAccessingSecurityScopedResource() }
                
                let bookmark = try scriptURL.bookmarkData(
                    options: [.withSecurityScope],
                    includingResourceValuesForKeys: nil,
                    relativeTo: nil
                )
                
                let pairing = ScriptPairing(
                    scriptName: scriptURL.lastPathComponent,
                    folderPath: folderURL.path,
                    scriptBookmarkData: bookmark,
                    displayName: newPairingDisplayName,
                    sectionName: selectedPairingSectionName
                )
                
                pairingStore.pairings.append(pairing)
                resetForm()
                isPresented = false
                
                print("✅ Created pairing: \(pairing.effectiveDisplayName)")
            }
        } catch {
            print("❌ Failed to create pairing: \(error)")
        }
    }
    
    private func resetForm() {
        newPairingDisplayName = ""
        selectedScriptURL = nil
        selectedFolderURL = nil
        selectedPairingSectionName = "General"
    }
}
