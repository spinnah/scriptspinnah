//
//  SettingsView.swift v0.20250626-145400
//  ScriptSpinnah
//
//  CS-151: Extract PairingCreationSheet to separate file
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @EnvironmentObject var pairingStore: ScriptPairingStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var editingSection: UUID? = nil
    @State private var editingSectionName: String = ""
    @State private var editingSectionIcon: String = "folder.circle.fill"
    
    // Selection states
    @State private var selectedSectionID: UUID? = nil
    @State private var selectedPairingID: UUID? = nil
    
    // Confirmation alerts
    @State private var showingSectionDeleteAlert = false
    @State private var showingPairingDeleteAlert = false
    
    // Pairing creation
    @State private var showingPairingCreation = false
    @State private var newPairingDisplayName = ""
    @State private var selectedScriptURL: URL? = nil
    @State private var selectedFolderURL: URL? = nil
    @State private var selectedPairingSectionName = "General"

    // Common SF Symbols for sections
    private let availableIcons = [
        ("folder.circle.fill", "General"),
        ("book.circle.fill", "Books/Comics"),
        ("briefcase.circle.fill", "Productivity"),
        ("photo.circle.fill", "Media"),
        ("terminal.fill", "Development"),
        ("wrench.and.screwdriver.fill", "Tools"),
        ("gamecontroller.fill", "Games"),
        ("music.note", "Audio"),
        ("video.circle.fill", "Video"),
        ("doc.circle.fill", "Documents")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)

            // Menu Sections
            VStack(alignment: .leading, spacing: 8) {
                Text("Menu Sections")
                    .font(.headline)
                
                List(selection: $selectedSectionID) {
                    ForEach(pairingStore.sections) { section in
                        HStack {
                            if editingSection == section.id {
                                // Editing mode
                                Picker("", selection: $editingSectionIcon) {
                                    ForEach(availableIcons, id: \.0) { iconName, description in
                                        Image(systemName: iconName).tag(iconName)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(width: 40)
                                
                                TextField("Section Name", text: $editingSectionName)
                                    .textFieldStyle(.roundedBorder)
                                    .onSubmit {
                                        if let index = pairingStore.sections.firstIndex(where: { $0.id == section.id }) {
                                            pairingStore.sections[index].name = editingSectionName
                                            pairingStore.sections[index].iconName = editingSectionIcon
                                        }
                                        editingSection = nil
                                    }
                            } else {
                                // Display mode
                                Image(systemName: section.iconName)
                                    .foregroundStyle(.primary)
                                    .frame(width: 20)
                                
                                Text(section.name)
                                
                                Spacer()
                                
                                if section.name == "General" {
                                    Text("Default")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 1)
                                        .background(.quaternary)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .tag(section.id)
                        .onTapGesture {
                            if section.name != "General" && editingSection != section.id {
                                editingSection = section.id
                                editingSectionName = section.name
                                editingSectionIcon = section.iconName
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let section = pairingStore.sections[index]
                            if section.name != "General" {
                                pairingStore.removeSection(section)
                            }
                        }
                    }
                }
                .frame(height: min(200, max(100, CGFloat(pairingStore.sections.count * 35 + 40))))
                
                // +/- buttons
                HStack {
                    Button(action: {
                        let newSection = ScriptSection(
                            name: "New Section",
                            iconName: "folder.circle.fill"
                        )
                        pairingStore.addSection(newSection)
                        editingSection = newSection.id
                        editingSectionName = newSection.name
                        editingSectionIcon = newSection.iconName
                        selectedSectionID = newSection.id
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 20, height: 20)
                    
                    Button(action: {
                        if let selectedID = selectedSectionID,
                           let section = pairingStore.sections.first(where: { $0.id == selectedID }),
                           section.name != "General" {
                            showingSectionDeleteAlert = true
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 20, height: 20)
                    .disabled(selectedSectionID == nil ||
                             pairingStore.sections.first(where: { $0.id == selectedSectionID })?.name == "General")
                    
                    Spacer()
                }
                .padding(.horizontal, 4)
            }

            // Configured Pairings
            VStack(alignment: .leading, spacing: 8) {
                Text("Configured Pairings")
                    .font(.headline)
                
                List(selection: $selectedPairingID) {
                    if pairingStore.pairings.isEmpty {
                        Text("No script pairings yet. Click + to add one.")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(pairingStore.pairings) { pairing in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(pairing.effectiveDisplayName)
                                Text("Section: \(pairing.sectionName)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                            .tag(pairing.id)
                        }
                        .onDelete { indexSet in
                            pairingStore.pairings.remove(atOffsets: indexSet)
                        }
                    }
                }
                .frame(height: min(150, max(60, CGFloat(max(1, pairingStore.pairings.count) * 35 + 20))))
                
                // +/- buttons for pairings
                HStack {
                    Button(action: {
                        showingPairingCreation = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 20, height: 20)
                    
                    Button(action: {
                        if selectedPairingID != nil {
                            showingPairingDeleteAlert = true
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 20, height: 20)
                    .disabled(selectedPairingID == nil)
                    
                    Spacer()
                }
                .padding(.horizontal, 4)
            }
            
            Spacer()
            
            // Done button at bottom
            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
        .frame(minWidth: 500)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxHeight: 600)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .sheet(isPresented: $showingPairingCreation) {
            PairingCreationSheet(
                pairingStore: pairingStore,
                newPairingDisplayName: $newPairingDisplayName,
                selectedScriptURL: $selectedScriptURL,
                selectedFolderURL: $selectedFolderURL,
                selectedPairingSectionName: $selectedPairingSectionName,
                isPresented: $showingPairingCreation
            )
        }
        .alert("Delete Section", isPresented: $showingSectionDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let selectedID = selectedSectionID,
                   let section = pairingStore.sections.first(where: { $0.id == selectedID }) {
                    pairingStore.removeSection(section)
                    selectedSectionID = nil
                }
            }
        } message: {
            if let selectedID = selectedSectionID,
               let section = pairingStore.sections.first(where: { $0.id == selectedID }) {
                Text("Are you sure you want to delete '\(section.name)'? Any pairings in this section will be moved to General.")
            }
        }
        .alert("Delete Pairing", isPresented: $showingPairingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let selectedID = selectedPairingID,
                   let index = pairingStore.pairings.firstIndex(where: { $0.id == selectedID }) {
                    pairingStore.pairings.remove(at: index)
                    selectedPairingID = nil
                }
            }
        } message: {
            if let selectedID = selectedPairingID,
               let pairing = pairingStore.pairings.first(where: { $0.id == selectedID }) {
                Text("Are you sure you want to delete '\(pairing.effectiveDisplayName)'?")
            }
        }
    }
}
