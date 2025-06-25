//
//  AppDelegate.swift
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/24/25.
//
//  Controls the menu bar icon and toggles the floating glass panel.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusItem: NSStatusItem!
    var panelWindowController: NSWindowController?
    var pairingStore = ScriptPairingStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the menu bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(named: "spiderweb")
            button.action = #selector(togglePanel)
            button.target = self
        }
        
        // Hide the dock icon since this is a menu bar only app
        NSApp.setActivationPolicy(.accessory)
    }

    @objc func togglePanel() {
        if panelWindowController == nil {
            let panelView = ScriptPanelWindow(isVisible: .constant(true))
                .environmentObject(pairingStore)

            let hosting = NSHostingController(rootView: panelView)
            let panel = FloatingPanel(
                contentRect: NSRect(x: 0, y: 0, width: 320, height: 400),
                styleMask: [.nonactivatingPanel, .borderless],
                backing: .buffered, defer: true
            )
            panel.titleVisibility = .hidden
            panel.titlebarAppearsTransparent = true
            panel.standardWindowButton(.closeButton)?.isHidden = true
            panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
            panel.standardWindowButton(.zoomButton)?.isHidden = true
            panel.isMovableByWindowBackground = false
            panel.collectionBehavior = [.canJoinAllSpaces, .transient]
            panel.isReleasedWhenClosed = false
            panel.delegate = self
            panel.isFloatingPanel = true
            panel.level = .floating
            panel.isOpaque = false
            panel.backgroundColor = .clear
            panel.contentView?.wantsLayer = true
            panel.contentView?.layer?.backgroundColor = NSColor.clear.cgColor
            panel.contentView?.superview?.wantsLayer = true
            panel.contentView?.superview?.layer?.cornerRadius = 20
            panel.contentView?.superview?.layer?.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner
            ]
            panel.hasShadow = true
            panel.contentView = hosting.view

            panelWindowController = NSWindowController(window: panel)
        }

        if let window = panelWindowController?.window {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                if let screen = NSScreen.main {
                    let screenFrame = screen.visibleFrame
                    let origin = CGPoint(x: screenFrame.midX - 160, y: screenFrame.maxY - 50)
                    window.setFrameOrigin(origin)
                }
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    func windowDidResignKey(_ notification: Notification) {
        panelWindowController?.window?.orderOut(nil)
    }
}
