import Foundation
import SwiftUI

// MARK: - Checklist Models

struct ChecklistItem: Identifiable, Codable, Hashable {
    let id: UUID
    let challenge: String
    let response: String
    let notes: String?
    var isCompleted: Bool

    init(challenge: String, response: String, notes: String? = nil, isCompleted: Bool = false) {
        self.id = UUID()
        self.challenge = challenge
        self.response = response
        self.notes = notes
        self.isCompleted = isCompleted
    }
}

struct Checklist: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let icon: String
    let phase: FlightPhase
    var items: [ChecklistItem]
    let color: Color

    init(title: String, subtitle: String, icon: String, phase: FlightPhase, items: [ChecklistItem], color: Color = .blue) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.phase = phase
        self.items = items
        self.color = color
    }

    static func == (lhs: Checklist, rhs: Checklist) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum FlightPhase: String, CaseIterable, Codable {
    case preflight = "Pre-Flight"
    case taxi = "Taxi"
    case takeoff = "Takeoff"
    case climb = "Climb"
    case cruise = "Cruise"
    case descent = "Descent"
    case approach = "Approach"
    case landing = "Landing"
    case postFlight = "Post-Flight"

    var icon: String {
        switch self {
        case .preflight: return "wrench.and.screwdriver"
        case .taxi: return "road.lanes"
        case .takeoff: return "airplane.departure"
        case .climb: return "arrow.up.right"
        case .cruise: return "airplane"
        case .descent: return "arrow.down.right"
        case .approach: return "scope"
        case .landing: return "airplane.arrival"
        case .postFlight: return "parkingsign"
        }
    }

    var color: Color {
        switch self {
        case .preflight: return .blue
        case .taxi: return .cyan
        case .takeoff: return .green
        case .climb: return .mint
        case .cruise: return .indigo
        case .descent: return .orange
        case .approach: return .yellow
        case .landing: return .red
        case .postFlight: return .purple
        }
    }
}

// MARK: - Emergency Procedure Models

struct EmergencyProcedure: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let severity: EmergencySeverity
    let icon: String
    let memoryItems: [String]
    let steps: [ProcedureStep]
    let notes: [String]

    init(title: String, subtitle: String, severity: EmergencySeverity, icon: String, memoryItems: [String] = [], steps: [ProcedureStep], notes: [String] = []) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.severity = severity
        self.icon = icon
        self.memoryItems = memoryItems
        self.steps = steps
        self.notes = notes
    }

    static func == (lhs: EmergencyProcedure, rhs: EmergencyProcedure) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct ProcedureStep: Identifiable, Codable, Hashable {
    let id: UUID
    let action: String
    let detail: String?
    let isConditional: Bool
    let condition: String?
    var isCompleted: Bool

    init(action: String, detail: String? = nil, isConditional: Bool = false, condition: String? = nil, isCompleted: Bool = false) {
        self.id = UUID()
        self.action = action
        self.detail = detail
        self.isConditional = isConditional
        self.condition = condition
        self.isCompleted = isCompleted
    }
}

enum EmergencySeverity: String, Codable {
    case warning = "WARNING"
    case caution = "CAUTION"
    case advisory = "ADVISORY"

    var color: Color {
        switch self {
        case .warning: return .red
        case .caution: return .orange
        case .advisory: return .yellow
        }
    }

    var icon: String {
        switch self {
        case .warning: return "exclamationmark.triangle.fill"
        case .caution: return "exclamationmark.circle.fill"
        case .advisory: return "info.circle.fill"
        }
    }
}

// MARK: - Instrument Guide Models

struct InstrumentGuide: Identifiable, Hashable {
    let id: UUID
    let name: String
    let abbreviation: String
    let description: String
    let icon: String
    let location: String
    let sections: [InstrumentSection]
    let color: Color

    init(name: String, abbreviation: String, description: String, icon: String, location: String, sections: [InstrumentSection], color: Color = .blue) {
        self.id = UUID()
        self.name = name
        self.abbreviation = abbreviation
        self.description = description
        self.icon = icon
        self.location = location
        self.sections = sections
        self.color = color
    }

    static func == (lhs: InstrumentGuide, rhs: InstrumentGuide) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct InstrumentSection: Identifiable, Hashable {
    let id: UUID
    let title: String
    let items: [InstrumentDetail]

    init(title: String, items: [InstrumentDetail]) {
        self.id = UUID()
        self.title = title
        self.items = items
    }

    static func == (lhs: InstrumentSection, rhs: InstrumentSection) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct InstrumentDetail: Identifiable, Codable, Hashable {
    let id: UUID
    let label: String
    let description: String
    let color: String?

    init(label: String, description: String, color: String? = nil) {
        self.id = UUID()
        self.label = label
        self.description = description
        self.color = color
    }
}

// MARK: - Approach Procedure Models

struct ApproachProcedure: Identifiable, Hashable {
    let id: UUID
    let name: String
    let type: ApproachType
    let icon: String
    let description: String
    let minimums: String
    let requiredEquipment: [String]
    let steps: [ProcedureStep]
    let fmgcSetup: [String]
    let notes: [String]

    init(name: String, type: ApproachType, icon: String, description: String, minimums: String, requiredEquipment: [String], steps: [ProcedureStep], fmgcSetup: [String] = [], notes: [String] = []) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.icon = icon
        self.description = description
        self.minimums = minimums
        self.requiredEquipment = requiredEquipment
        self.steps = steps
        self.fmgcSetup = fmgcSetup
        self.notes = notes
    }

    static func == (lhs: ApproachProcedure, rhs: ApproachProcedure) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum ApproachType: String, CaseIterable, Codable {
    case ils = "ILS"
    case vor = "VOR"
    case vorDme = "VOR/DME"
    case ndb = "NDB"
    case rnav = "RNAV (GPS)"
    case visual = "Visual"
    case circling = "Circling"
    case loc = "LOC Only"

    var color: Color {
        switch self {
        case .ils: return .green
        case .vor: return .blue
        case .vorDme: return .cyan
        case .ndb: return .orange
        case .rnav: return .purple
        case .visual: return .yellow
        case .circling: return .mint
        case .loc: return .teal
        }
    }
}

// MARK: - FMGC Models

struct FMGCOperation: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let icon: String
    let mcduPage: String
    let steps: [FMGCStep]
    let tips: [String]
    let color: Color

    init(title: String, subtitle: String, icon: String, mcduPage: String, steps: [FMGCStep], tips: [String] = [], color: Color = .cyan) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.mcduPage = mcduPage
        self.steps = steps
        self.tips = tips
        self.color = color
    }

    static func == (lhs: FMGCOperation, rhs: FMGCOperation) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct FMGCStep: Identifiable, Codable, Hashable {
    let id: UUID
    let keyPress: String
    let action: String
    let display: String?

    init(keyPress: String, action: String, display: String? = nil) {
        self.id = UUID()
        self.keyPress = keyPress
        self.action = action
        self.display = display
    }
}

// MARK: - POH Reference Models

struct POHSection: Identifiable, Hashable {
    let id: UUID
    let title: String
    let icon: String
    let subsections: [POHSubsection]
    let color: Color

    init(title: String, icon: String, subsections: [POHSubsection], color: Color = .indigo) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.subsections = subsections
        self.color = color
    }

    static func == (lhs: POHSection, rhs: POHSection) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct POHSubsection: Identifiable, Hashable {
    let id: UUID
    let title: String
    let content: [POHEntry]

    init(title: String, content: [POHEntry]) {
        self.id = UUID()
        self.title = title
        self.content = content
    }

    static func == (lhs: POHSubsection, rhs: POHSubsection) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct POHEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let parameter: String
    let value: String
    let unit: String?
    let note: String?

    init(parameter: String, value: String, unit: String? = nil, note: String? = nil) {
        self.id = UUID()
        self.parameter = parameter
        self.value = value
        self.unit = unit
        self.note = note
    }
}

// MARK: - Cockpit Target Model

struct CockpitTarget: Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let position: SIMD3<Float>
    let category: CockpitZone

    init(name: String, description: String, position: SIMD3<Float>, category: CockpitZone) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.position = position
        self.category = category
    }

    static func == (lhs: CockpitTarget, rhs: CockpitTarget) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum CockpitZone: String, CaseIterable, Codable {
    case glareshield = "Glareshield"
    case overheadPanel = "Overhead Panel"
    case mainInstrumentPanel = "Main Instrument Panel"
    case pedestal = "Center Pedestal"
    case sidePanel = "Side Panel"
}
