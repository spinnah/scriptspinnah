//
//  ScriptExecutor.swift v1
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  CS-142: Implement actual shell script execution using Process and launchPath/executableURL
//
//  Provides a helper function to run a user-selected shell script
//  on a given folder path. This is the core execution logic for ScriptPairings.
//

import Foundation

struct ScriptExecutor {
    static func run(scriptPath: String, with folderPath: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: scriptPath)
        process.arguments = [folderPath]
        process.standardOutput = Pipe()
        process.standardError = Pipe()

        do {
            try process.run()
            print("✅ Running script: \(scriptPath)")
            print("📂 On folder: \(folderPath)")
        } catch {
            print("❌ Failed to run script at \(scriptPath): \(error.localizedDescription)")
        }
    }
}