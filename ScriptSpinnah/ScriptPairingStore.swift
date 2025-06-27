//
//  ScriptPairingStore.swift v1.0
//  ScriptSpinnah
//
//  Created by ShastLeLow on 2025-06-26.
//
//  Persistent data store for script pairings and menu sections.
//  Manages UserDefaults persistence with automatic saving on data changes.
//

import Foundation
import Combine

class ScriptPairingStore: ObservableObject {
    @Published var pairings: [ScriptPairing] = [] {
        didSet { save() }
    }
    
    @Published var sections: [ScriptSection] = [] {
        didSet { save() }
    }

    private let pairingsStorageKey = "ScriptPairings"
    private let sectionsStorageKey = "ScriptSections"
    private var isLoading = false // Prevent save during initial load

    init() {
        load()
    }

    func add(scriptName: String, folderPath: String, scriptBookmarkData: Data, sectionName: String = "General") {
        let newPairing = ScriptPairing(
            scriptName: scriptName,
            folderPath: folderPath,
            scriptBookmarkData: scriptBookmarkData,
            sectionName: sectionName
        )
        pairings.append(newPairing)
    }

    func remove(_ pairing: ScriptPairing) {
        pairings.removeAll { $0.id == pairing.id }
    }
    
    func addSection(_ section: ScriptSection) {
        sections.append(section)
    }
    
    func removeSection(_ section: ScriptSection) {
        // Move pairings in this section to "General"
        for index in pairings.indices {
            if pairings[index].sectionName == section.name {
                pairings[index].sectionName = "General"
            }
        }
        sections.removeAll { $0.id == section.id }
    }
    
    func toggleSectionCollapse(_ section: ScriptSection) {
        if let index = sections.firstIndex(where: { $0.id == section.id }) {
            sections[index].isCollapsed.toggle()
        }
    }

    private func load() {
        isLoading = true
        
        // Load pairings
        if let pairingsData = UserDefaults.standard.data(forKey: pairingsStorageKey),
           let decodedPairings = try? JSONDecoder().decode([ScriptPairing].self, from: pairingsData) {
            pairings = decodedPairings
        } else {
            pairings = []
        }
        
        // Load sections
        if let sectionsData = UserDefaults.standard.data(forKey: sectionsStorageKey),
           let decodedSections = try? JSONDecoder().decode([ScriptSection].self, from: sectionsData) {
            sections = decodedSections
        } else {
            sections = ScriptSection.defaultSections
        }
        
        isLoading = false
    }

    private func save() {
        // Don't save during initial loading
        guard !isLoading else { return }
        
        // Save pairings
        if let pairingsData = try? JSONEncoder().encode(pairings) {
            UserDefaults.standard.set(pairingsData, forKey: pairingsStorageKey)
        }
        
        // Save sections
        if let sectionsData = try? JSONEncoder().encode(sections) {
            UserDefaults.standard.set(sectionsData, forKey: sectionsStorageKey)
        }
    }
}
