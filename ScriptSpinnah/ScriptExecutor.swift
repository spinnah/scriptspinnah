//
//  ScriptExecutor.swift v1.0
//  ScriptSpinnah
//
//  Created by ShastLeLow on 2025-06-26.
//
//  Core script execution engine using macOS Process API.
//  Runs shell scripts with target folder paths and handles output/error streaming.
//

import Foundation

struct ScriptExecutor {
    static func run(scriptURL: URL, with folderPath: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = [scriptURL.path, folderPath]
        process.standardOutput = Pipe()
        process.standardError = Pipe()

        let outputPipe = process.standardOutput as! Pipe
        let errorPipe = process.standardError as! Pipe

        outputPipe.fileHandleForReading.readabilityHandler = { handle in
            if let output = String(data: handle.availableData, encoding: .utf8), !output.isEmpty {
                print("📤 \(output.trimmingCharacters(in: .whitespacesAndNewlines))")
            }
        }

        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            if let error = String(data: handle.availableData, encoding: .utf8), !error.isEmpty {
                print("🛑 \(error.trimmingCharacters(in: .whitespacesAndNewlines))")
            }
        }

        do {
            try process.run()
            process.terminationHandler = { process in
                if process.terminationStatus == 0 {
                    print("✅ Script completed successfully.")
                } else {
                    print("❌ Script exited with status code \(process.terminationStatus).")
                }
            }
            print("✅ Running script: \(scriptURL.path)")
            print("📂 On folder: \(folderPath)")
        } catch {
            print("❌ Failed to run script at \(scriptURL.path): \(error.localizedDescription)")
        }
    }
}
