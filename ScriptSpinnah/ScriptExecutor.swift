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
    static func run(scriptURL: URL, with folderPath: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = [scriptURL.path, folderPath]
        process.standardOutput = Pipe()
        process.standardError = Pipe()

        do {
            try process.run()
            print("✅ Running script: \(scriptURL.path)")
            print("📂 On folder: \(folderPath)")
        } catch {
            print("❌ Failed to run script at \(scriptURL.path): \(error.localizedDescription)")
        }
    }
}
