//
//  that.swift
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//


//
//  ScriptPairing.swift v1
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  Defines a struct that stores a pairing between a folder and a script.
//  Used to manage which script should run against which user-selected folder.
//  Conforms to Codable for persistence via UserDefaults or JSON.
//

import Foundation

struct ScriptPairing: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var folderPath: String       // Absolute path to the folder
    var scriptPath: String       // Absolute path to the script

    var folderName: String {
        URL(fileURLWithPath: folderPath).lastPathComponent
    }

    var scriptName: String {
        URL(fileURLWithPath: scriptPath).lastPathComponent
    }
}