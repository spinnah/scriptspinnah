//
//  SettingsWindow.swift v0.20250626-144500
//  ScriptSpinnah
//
//  Custom borderless window that can become key for text input
//

import AppKit

class SettingsWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: flag)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .transient]
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
    }
}
