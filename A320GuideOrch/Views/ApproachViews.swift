import SwiftUI

// MARK: - Approach Procedure List

struct ApproachProcedureListView: View {
    @State private var searchText = ""
    @State private var selectedType: ApproachType?

    private var filtered: [ApproachProcedure] {
        var result = A320Database.approachProcedures
        if let type = selectedType {
            result = result.filter { $0.type == type }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            FilterChip(label: "All", isSelected: selectedType == nil) {
                                selectedType = nil
                            }
                            ForEach(ApproachType.allCases, id: \.self) { type in
                                FilterChip(label: type.rawValue, color: type.color, isSelected: selectedType == type) {
                                    selectedType = type
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                ForEach(filtered) { procedure in
                    NavigationLink {
                        ApproachProcedureDetailView(procedure: procedure)
                    } label: {
                        ApproachProcedureRow(procedure: procedure)
                    }
                }
            }
            .navigationTitle("Approach Procedures")
            .searchable(text: $searchText, prompt: "Search approaches...")
        }
    }
}

// MARK: - Approach Procedure Row

struct ApproachProcedureRow: View {
    let procedure: ApproachProcedure

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(procedure.type.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: procedure.icon)
                    .font(.title2)
                    .foregroundStyle(procedure.type.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(procedure.name)
                    .font(.headline)
                Text(procedure.type.rawValue)
                    .font(.caption.bold())
                    .foregroundStyle(procedure.type.color)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Approach Procedure Detail

struct ApproachProcedureDetailView: View {
    let procedure: ApproachProcedure
    @State private var completedSteps: Set<UUID> = []

    var body: some View {
        List {
            // Header
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: procedure.icon)
                            .font(.largeTitle)
                            .foregroundStyle(procedure.type.color)
                        VStack(alignment: .leading) {
                            Text(procedure.type.rawValue)
                                .font(.caption.bold())
                                .foregroundStyle(procedure.type.color)
                            Text(procedure.name)
                                .font(.headline)
                        }
                    }
                    Text(procedure.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            // Minimums
            Section("Minimums") {
                Text(procedure.minimums)
                    .font(.subheadline.monospaced())
                    .foregroundStyle(.cyan)
            }

            // Required Equipment
            Section("Required Equipment") {
                ForEach(procedure.requiredEquipment, id: \.self) { equip in
                    Label(equip, systemImage: "checkmark.seal")
                        .font(.subheadline)
                }
            }

            // FMGC Setup
            if !procedure.fmgcSetup.isEmpty {
                Section("FMGC Setup") {
                    ForEach(procedure.fmgcSetup, id: \.self) { step in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "keyboard")
                                .foregroundStyle(.cyan)
                                .font(.caption)
                                .padding(.top, 2)
                            Text(step)
                                .font(.caption)
                        }
                    }
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
        .navigationTitle(procedure.type.rawValue)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Reset", systemImage: "arrow.counterclockwise") {
                    withAnimation { completedSteps.removeAll() }
                }
            }
        }
    }
}
