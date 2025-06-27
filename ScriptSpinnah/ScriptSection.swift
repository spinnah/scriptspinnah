//
//  ScriptSection.swift v1.0
//  ScriptSpinnah
//
//  Created by ShastLeLow on 2025-06-26.
//
//  Data model for collapsible menu sections with SF Symbol icons.
//  Organizes script pairings into categorized, expandable groups.
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
