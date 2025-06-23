//
//  SettingsView.swift v2
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  Provides a basic UI to view, add, and remove folder+script pairings.
//  Each pairing links a user-selected folder with a shell script to run.
//

import SwiftUI
import UniformTypeIdentifiers
import Combine

struct SettingsView: View {
    @StateObject private var store = ScriptPairingStore()
    @EnvironmentObject var scriptContext: ScriptContext

    @State private var selectedFolder: URL?
    @State private var selectedScript: URL?

    @State private var showingFolderPicker = false
    @State private var showingScriptPicker = false
    @State private var isImportingScript = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Script Pairings")
                .font(.title2)
                .padding(.bottom, 4)

            List {
                ForEach(store.pairings) { pairing in
                    VStack(alignment: .leading) {
                        Text(pairing.folderName)
                            .font(.headline)
                        Text("→ \(pairing.scriptName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { store.pairings[$0] }.forEach(store.remove)
                }
            }

            HStack {
                Button("Add Pairing…") {
                    isImportingScript = true
                }

                Spacer()
            }
        }
        .padding()
        .frame(width: 420, height: 360)
        .fileImporter(
            isPresented: $showingFolderPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let folderURLs):
                selectedFolder = folderURLs.first
                showingScriptPicker = true
            case .failure(let error):
                print("Folder picker failed: \(error)")
            }
        }
        .fileImporter(
            isPresented: $showingScriptPicker,
            allowedContentTypes: [.item],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let scriptURLs):
                if let folder = selectedFolder,
                   let script = scriptURLs.first {
                    store.add(folderPath: folder.path, scriptPath: script.path)
                    selectedFolder = nil
                }
            case .failure(let error):
                print("Script picker failed: \(error)")
            }
        }
        .fileImporter(
            isPresented: $isImportingScript,
            allowedContentTypes: [.item],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }
                    scriptContext.grantedScriptURL = url
                    print("✅ Access granted to: \(url.path)")
                } else {
                    print("❌ Failed to access security-scoped resource.")
                }
            case .failure(let error):
                print("❌ Failed to import file: \(error.localizedDescription)")
            }
        }
    }
}
