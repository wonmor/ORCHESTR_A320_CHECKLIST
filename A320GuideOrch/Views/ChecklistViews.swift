import SwiftUI

// MARK: - Checklist Category View

struct ChecklistCategoryView: View {
    @State private var checklists = A320Database.normalChecklists
    @State private var searchText = ""

    private var filteredChecklists: [Checklist] {
        if searchText.isEmpty { return checklists }
        return checklists.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var groupedChecklists: [(FlightPhase, [Checklist])] {
        let grouped = Dictionary(grouping: filteredChecklists) { $0.phase }
        return FlightPhase.allCases.compactMap { phase in
            guard let items = grouped[phase], !items.isEmpty else { return nil }
            return (phase, items)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                progressSection

                ForEach(groupedChecklists, id: \.0) { phase, items in
                    Section {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, checklist in
                            NavigationLink(value: checklistIndex(for: checklist)) {
                                ChecklistRow(checklist: checklist)
                            }
                        }
                    } header: {
                        Label(phase.rawValue, systemImage: phase.icon)
                            .font(.headline)
                            .foregroundStyle(phase.color)
                    }
                }
            }
            .navigationTitle("Normal Checklists")
            .navigationDestination(for: Int.self) { index in
                if index >= 0 && index < checklists.count {
                    ChecklistDetailView(checklist: $checklists[index])
                }
            }
            .searchable(text: $searchText, prompt: "Search checklists...")
        }
    }

    private func checklistIndex(for checklist: Checklist) -> Int {
        checklists.firstIndex(where: { $0.id == checklist.id }) ?? 0
    }

    private var progressSection: some View {
        Section {
            let total = checklists.flatMap(\.items).count
            let completed = checklists.flatMap(\.items).filter(\.isCompleted).count
            let progress = total > 0 ? Double(completed) / Double(total) : 0

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Overall Progress")
                        .font(.headline)
                    Spacer()
                    Text("\(completed)/\(total)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                ProgressView(value: progress)
                    .tint(.cyan)

                if completed == total && total > 0 {
                    Label("All checklists complete", systemImage: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                        .font(.subheadline)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Checklist Row

struct ChecklistRow: View {
    let checklist: Checklist

    private var completedCount: Int {
        checklist.items.filter(\.isCompleted).count
    }

    private var isComplete: Bool {
        completedCount == checklist.items.count
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: checklist.icon)
                .font(.title2)
                .foregroundStyle(isComplete ? .green : checklist.color)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(checklist.title)
                    .font(.headline)
                    .strikethrough(isComplete, color: .green)
                Text(checklist.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(completedCount)/\(checklist.items.count)")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isComplete ? Color.green.opacity(0.2) : Color.secondary.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Checklist Detail View

struct ChecklistDetailView: View {
    @Binding var checklist: Checklist
    @State private var showResetAlert = false

    private var completedCount: Int {
        checklist.items.filter(\.isCompleted).count
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Label(checklist.phase.rawValue, systemImage: checklist.phase.icon)
                        .font(.subheadline)
                        .foregroundStyle(checklist.phase.color)
                    Spacer()
                    Text("\(completedCount)/\(checklist.items.count)")
                        .font(.subheadline.bold())
                }

                ProgressView(value: Double(completedCount), total: Double(checklist.items.count))
                    .tint(completedCount == checklist.items.count ? .green : .cyan)
            }

            Section("Items") {
                ForEach($checklist.items) { $item in
                    ChecklistItemRow(item: $item)
                }
            }
        }
        .navigationTitle(checklist.title)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Menu {
                    Button("Complete All", systemImage: "checkmark.circle.fill") {
                        withAnimation {
                            for i in checklist.items.indices {
                                checklist.items[i].isCompleted = true
                            }
                        }
                    }
                    Button("Reset All", systemImage: "arrow.counterclockwise", role: .destructive) {
                        showResetAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Reset Checklist?", isPresented: $showResetAlert) {
            Button("Reset", role: .destructive) {
                withAnimation {
                    for i in checklist.items.indices {
                        checklist.items[i].isCompleted = false
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will uncheck all items in \(checklist.title).")
        }
    }
}

// MARK: - Checklist Item Row

struct ChecklistItemRow: View {
    @Binding var item: ChecklistItem
    @State private var showNotes = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        item.isCompleted.toggle()
                    }
                } label: {
                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(item.isCompleted ? .green : .secondary)
                        .font(.title3)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(item.challenge)
                            .font(.subheadline.bold())
                            .strikethrough(item.isCompleted)
                            .foregroundStyle(item.isCompleted ? .secondary : .primary)
                        Spacer()
                        Text(item.response)
                            .font(.subheadline.monospaced())
                            .foregroundStyle(item.isCompleted ? .green : .cyan)
                            .multilineTextAlignment(.trailing)
                    }

                    if let notes = item.notes, showNotes {
                        Text(notes)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 2)
                    }
                }
            }

            if item.notes != nil {
                Button {
                    withAnimation { showNotes.toggle() }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: showNotes ? "chevron.up" : "chevron.down")
                        Text(showNotes ? "Hide notes" : "Show notes")
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .padding(.leading, 36)
            }
        }
        .padding(.vertical, 2)
    }
}
