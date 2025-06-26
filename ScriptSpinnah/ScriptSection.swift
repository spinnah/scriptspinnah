//
//  ScriptSection.swift v1
//  ScriptSpinnah
//
//  Created by Shawn Starbird on 6/24/25.
//
//  CS-151: Section model for organizing script pairings with icons
//
//  Represents a collapsible section in the menu with an SF Symbol icon
//

import Foundation

struct ScriptSection: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var iconName: String // SF Symbol name
    var isCollapsed: Bool
    
    init(name: String, iconName: String, isCollapsed: Bool = false) {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.isCollapsed = isCollapsed
    }
    
    // Default sections
    static let defaultSections = [
        ScriptSection(name: "General", iconName: "folder.circle.fill")
    ]
}
