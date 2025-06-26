//
//  SettingsView.swift
//  v6.0
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 2025-06-25
//  CS-151: Native +/- button design with inline editing
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var pairingStore: ScriptPairingStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var editingSection: UUID? = nil
    @State private var editingSectionName: String = ""
    @State private var editingSectionIcon: String = "folder.circle.fill"

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
                
                List {
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
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 20, height: 20)
                    
                    Button(action: {
                        // Remove selected section (implement selection if needed)
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 20, height: 20)
                    .disabled(true) // For now
                    
                    Spacer()
                }
                .padding(.horizontal, 4)
            }

            // Configured Pairings
            VStack(alignment: .leading, spacing: 8) {
                Text("Configured Pairings")
                    .font(.headline)
                
                List {
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
                        }
                    }
                }
                .frame(height: min(150, max(60, CGFloat(max(1, pairingStore.pairings.count) * 35 + 20))))
                
                // +/- buttons for pairings
                HStack {
                    Button(action: {
                        // TODO: Add pairing functionality
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 20, height: 20)
                    
                    Button(action: {
                        // Remove selected pairing
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 20, height: 20)
                    .disabled(true) // For now
                    
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
        .background(.thinMaterial)  // More translucent
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
