import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Emergency Procedures List

struct EmergencyProceduresListView: View {
    @State private var searchText = ""
    @State private var selectedSeverity: EmergencySeverity?

    private var filtered: [EmergencyProcedure] {
        var result = A320Database.emergencyProcedures
        if let severity = selectedSeverity {
            result = result.filter { $0.severity == severity }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 8) {
                        FilterChip(label: "All", isSelected: selectedSeverity == nil) {
                            selectedSeverity = nil
                        }
                        FilterChip(label: "WARNING", color: .red, isSelected: selectedSeverity == .warning) {
                            selectedSeverity = .warning
                        }
                        FilterChip(label: "CAUTION", color: .orange, isSelected: selectedSeverity == .caution) {
                            selectedSeverity = .caution
                        }
                        FilterChip(label: "ADVISORY", color: .yellow, isSelected: selectedSeverity == .advisory) {
                            selectedSeverity = .advisory
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .padding(.horizontal)
                }

                ForEach(filtered) { procedure in
                    NavigationLink {
                        EmergencyProcedureDetailView(procedure: procedure)
                    } label: {
                        EmergencyProcedureRow(procedure: procedure)
                    }
                }
            }
            .navigationTitle("Emergency Procedures")
            .searchable(text: $searchText, prompt: "Search procedures...")
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let label: String
    var color: Color = .cyan
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isSelected ? color.opacity(0.3) : Color.secondary.opacity(0.1))
                .foregroundStyle(isSelected ? color : .secondary)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(isSelected ? color : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Emergency Procedure Row

struct EmergencyProcedureRow: View {
    let procedure: EmergencyProcedure

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: procedure.icon)
                .font(.title2)
                .foregroundStyle(procedure.severity.color)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(procedure.title)
                        .font(.headline)
                    Spacer()
                    Text(procedure.severity.rawValue)
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(procedure.severity.color.opacity(0.2))
                        .foregroundStyle(procedure.severity.color)
                        .clipShape(Capsule())
                }
                Text(procedure.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Emergency Procedure Detail View

struct EmergencyProcedureDetailView: View {
    let procedure: EmergencyProcedure
    @State private var completedSteps: Set<UUID> = []

    var body: some View {
        List {
            // Severity Banner
            Section {
                HStack {
                    Image(systemName: procedure.severity.icon)
                    Text(procedure.severity.rawValue)
                        .font(.headline.bold())
                    Spacer()
                    Image(systemName: procedure.icon)
                        .font(.title2)
                }
                .foregroundStyle(procedure.severity.color)
                .listRowBackground(procedure.severity.color.opacity(0.1))
            }

            // Memory Items
            if !procedure.memoryItems.isEmpty {
                Section {
                    ForEach(procedure.memoryItems, id: \.self) { item in
                        HStack(spacing: 8) {
                            Image(systemName: "brain.head.profile")
                                .foregroundStyle(.red)
                                .font(.caption)
                            Text(item)
                                .font(.subheadline.bold().monospaced())
                                .foregroundStyle(.red)
                        }
                    }
                } header: {
                    Label("MEMORY ITEMS", systemImage: "brain.head.profile")
                        .foregroundStyle(.red)
                } footer: {
                    Text("Memory items must be performed from recall — no reference to checklist required.")
                        .font(.caption2)
                }
            }

            // Procedure Steps
            Section("Procedure Steps") {
                ForEach(procedure.steps) { step in
                    ProcedureStepRow(step: step, isCompleted: completedSteps.contains(step.id)) {
                        withAnimation(.spring(response: 0.3)) {
                            if completedSteps.contains(step.id) {
                                completedSteps.remove(step.id)
                            } else {
                                completedSteps.insert(step.id)
                            }
                        }
                    }
                }
            }

            // Notes
            if !procedure.notes.isEmpty {
                Section("Notes") {
                    ForEach(procedure.notes, id: \.self) { note in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.blue)
                                .font(.caption)
                                .padding(.top, 2)
                            Text(note)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(procedure.title)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Reset", systemImage: "arrow.counterclockwise") {
                    withAnimation { completedSteps.removeAll() }
                }
            }
        }
    }
}

// MARK: - Procedure Step Row

struct ProcedureStepRow: View {
    let step: ProcedureStep
    let isCompleted: Bool
    let onToggle: () -> Void
    #if os(iOS)
    private let hapticLight = UIImpactFeedbackGenerator(style: .light)
    private let hapticSuccess = UINotificationFeedbackGenerator()
    #endif

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isCompleted ? .green : .secondary)
                .font(.title3)
                .contentTransition(.symbolEffect(.replace))

            VStack(alignment: .leading, spacing: 2) {
                Text(step.action)
                    .font(.subheadline.bold())
                    .strikethrough(isCompleted)
                    .foregroundStyle(isCompleted ? .secondary : .primary)

                if let detail = step.detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(isCompleted ? .secondary : .cyan)
                }

                if step.isConditional, let condition = step.condition {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.turn.down.right")
                        Text("IF: \(condition)")
                    }
                    .font(.caption2)
                    .foregroundStyle(.orange)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle()
            #if os(iOS)
            if !isCompleted {
                hapticSuccess.notificationOccurred(.success)
            } else {
                hapticLight.impactOccurred()
            }
            #endif
        }
        .padding(.vertical, 2)
    }
}
