//
//  FloatingPanel.swift v1.claude
//  ScriptSpinnah
//
//  A custom NSPanel subclass that allows full interactivity
//

import AppKit

class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: flag)
        
        // Make window completely transparent to let SwiftUI handle the glass effect
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = false  // Let SwiftUI handle shadows
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.collectionBehavior = [.canJoinAllSpaces, .transient]
        self.level = .statusBar
    }
}
