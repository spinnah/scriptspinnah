//
//  ScriptSpinnahLauncher.swift
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/24/25.
//


//
//  main.swift
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/24/25.
//

import Cocoa
import SwiftUI

@main
struct ScriptSpinnahLauncher {
    static func main() {
        let delegate = AppDelegate()
        let app = NSApplication.shared
        app.setActivationPolicy(.accessory) // no Dock icon
        app.delegate = delegate
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
}