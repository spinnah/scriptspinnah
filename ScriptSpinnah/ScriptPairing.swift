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

    init(scriptName: String, folderPath: String, scriptBookmarkData: Data) {
        self.id = UUID()
        self.scriptName = scriptName
        self.folderPath = folderPath
        self.scriptBookmarkData = scriptBookmarkData
    }
}
