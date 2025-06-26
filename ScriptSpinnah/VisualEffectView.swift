//
//  VisualEffectView.swift
//  v1.0
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 2025-06-25
//  Wraps NSVisualEffectView for macOS-style translucent backgrounds.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    let emphasized: Bool

    init(material: NSVisualEffectView.Material,
         blendingMode: NSVisualEffectView.BlendingMode = .withinWindow,
         emphasized: Bool = false) {
        self.material = material
        self.blendingMode = blendingMode
        self.emphasized = emphasized
    }

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.isEmphasized = emphasized
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
