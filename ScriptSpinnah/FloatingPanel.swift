//
//  FloatingPanel.swift
//  ScriptSpinnah
//
//  A custom NSPanel subclass that allows full interactivity
//

import AppKit

class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
