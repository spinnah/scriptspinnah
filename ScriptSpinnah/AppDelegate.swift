//
//  AppDelegate.swift v1.3
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/24/25.
//
//  Controls the menu bar icon and shows NSPopover with Liquid Glass styling.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var pairingStore = ScriptPairingStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the menu bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(named: "spiderweb")
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        // Create the popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 320, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: ScriptPanelWindow(isVisible: .constant(true))
                .environmentObject(pairingStore)
        )
        
        // Hide the dock icon since this is a menu bar only app
        NSApp.setActivationPolicy(.accessory)
    }

    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
