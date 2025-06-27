//
//  ScriptPairing.swift v1.0
//  ScriptSpinnah
//
//  Created by ShastLeLow on 2025-06-26.
//
//  Data model representing a script-folder pairing.
//  Stores script bookmarks, target paths, display names, and section organization.
//

import Foundation

struct ScriptPairing: Identifiable, Codable, Equatable {
    let id: UUID
    var scriptName: String
    var folderPath: String
    var scriptBookmarkData: Data
    var displayName: String
    var sectionName: String // New property for section organization

    var effectiveDisplayName: String {
        if !displayName.isEmpty {
            return displayName
        } else {
            let baseScriptName = (scriptName as NSString).deletingPathExtension
            let folderName = URL(fileURLWithPath: folderPath).lastPathComponent
            return "\(baseScriptName) – \(folderName)"
        }
    }

    init(scriptName: String, folderPath: String, scriptBookmarkData: Data, displayName: String = "", sectionName: String = "General") {
        self.id = UUID()
        self.scriptName = scriptName
        self.folderPath = folderPath
        self.scriptBookmarkData = scriptBookmarkData
        self.displayName = displayName
        self.sectionName = sectionName
    }
}
