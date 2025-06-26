//
//  ScriptPairing.swift v3
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  CS-151: Add section support for organizing pairings
//
//  Represents a pairing between a shell script and a target folder.
//  Stores script name, folder path, bookmark data, and section information.
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
