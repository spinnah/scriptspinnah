//
//  ScriptPairingStore.swift v2
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  CS-151: Add section management alongside pairing management
//
//  ObservableObject class to manage script pairings and sections,
//  using UserDefaults for persistence across app launches.
//

import Foundation
import Combine

class ScriptPairingStore: ObservableObject {
    @Published var pairings: [ScriptPairing] = []
    @Published var sections: [ScriptSection] = []

    private let pairingsStorageKey = "ScriptPairings"
    private let sectionsStorageKey = "ScriptSections"

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
        save()
    }

    func remove(_ pairing: ScriptPairing) {
        pairings.removeAll { $0.id == pairing.id }
        save()
    }
    
    func addSection(_ section: ScriptSection) {
        sections.append(section)
        save()
    }
    
    func removeSection(_ section: ScriptSection) {
        // Move pairings in this section to "General"
        for index in pairings.indices {
            if pairings[index].sectionName == section.name {
                pairings[index].sectionName = "General"
            }
        }
        sections.removeAll { $0.id == section.id }
        save()
    }
    
    func toggleSectionCollapse(_ section: ScriptSection) {
        if let index = sections.firstIndex(where: { $0.id == section.id }) {
            sections[index].isCollapsed.toggle()
            save()
        }
    }

    private func load() {
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
    }

    private func save() {
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
