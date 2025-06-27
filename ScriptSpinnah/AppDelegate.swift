//
//  AppDelegate.swift v1.0
//  ScriptSpinnah
//
//  Created by ShastLeLow on 2025-06-26.
//
//  Controls the menu bar icon and displays the floating script panel.
//  Manages the app lifecycle for menu bar-only operation with Liquid Glass UI.
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
        
        // Create the popover with Liquid Glass styling
        popover = NSPopover()
        popover.contentSize = NSSize(width: 320, height: 200) // Start with minimum height
        popover.behavior = .transient
        popover.appearance = NSAppearance(named: .aqua) // Force system appearance
        
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
