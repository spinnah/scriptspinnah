//
//  ScriptPairing.swift v2
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  CS-143: Add bookmark-based script/folder pairing model
//
//  Represents a pairing between a shell script and a target folder.
//  Stores script name, folder path, and bookmark data for the script.
//

import Foundation

struct ScriptPairing: Identifiable, Codable, Equatable {
    let id: UUID
    var scriptName: String
    var folderPath: String
    var scriptBookmarkData: Data
    var displayName: String

    var effectiveDisplayName: String {
        if !displayName.isEmpty {
            return displayName
        } else {
            let baseScriptName = (scriptName as NSString).deletingPathExtension
            let folderName = URL(fileURLWithPath: folderPath).lastPathComponent
            return "\(baseScriptName) – \(folderName)"
        }
    }

    init(scriptName: String, folderPath: String, scriptBookmarkData: Data, displayName: String = "") {
        self.id = UUID()
        self.scriptName = scriptName
        self.folderPath = folderPath
        self.scriptBookmarkData = scriptBookmarkData
        self.displayName = displayName
    }
}
