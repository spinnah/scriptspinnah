//
//  ScriptPairingStore.swift v1
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/23/25.
//
//  ObservableObject class to manage a list of script/folder pairings,
//  using UserDefaults for persistence across app launches.
//

import Foundation
import Combine

class ScriptPairingStore: ObservableObject {
    @Published var pairings: [ScriptPairing] = []

    private let storageKey = "ScriptPairings"

    init() {
        load()
    }

    func add(scriptName: String, folderPath: String, scriptBookmarkData: Data) {
        let newPairing = ScriptPairing(
            scriptName: scriptName,
            folderPath: folderPath,
            scriptBookmarkData: scriptBookmarkData
        )
        pairings.append(newPairing)
        save()
    }

    func remove(_ pairing: ScriptPairing) {
        pairings.removeAll { $0.id == pairing.id }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([ScriptPairing].self, from: data)
        else {
            pairings = []
            return
        }
        pairings = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(pairings) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
