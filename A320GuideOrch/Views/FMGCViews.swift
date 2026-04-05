import SwiftUI

// MARK: - FMGC Operations List

struct FMGCOperationsListView: View {
    @State private var searchText = ""

    private var filtered: [FMGCOperation] {
        if searchText.isEmpty { return A320Database.fmgcOperations }
        return A320Database.fmgcOperations.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { operation in
                NavigationLink {
                    FMGCOperationDetailView(operation: operation)
                } label: {
                    FMGCOperationRow(operation: operation)
                }
            }
            .navigationTitle("FMGC Operations")
            .searchable(text: $searchText, prompt: "Search FMGC operations...")
        }
    }
}

// MARK: - FMGC Operation Row

struct FMGCOperationRow: View {
    let operation: FMGCOperation

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(operation.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: operation.icon)
                    .font(.title2)
                    .foregroundStyle(operation.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(operation.title)
                    .font(.headline)
                HStack {
                    Text(operation.mcduPage)
                        .font(.caption.monospaced())
                        .foregroundStyle(.cyan)
                }
                Text(operation.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - FMGC Operation Detail

struct FMGCOperationDetailView: View {
    let operation: FMGCOperation

    var body: some View {
        List {
            // Header
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: operation.icon)
                            .font(.largeTitle)
                            .foregroundStyle(operation.color)
                        VStack(alignment: .leading) {
                            Text(operation.title)
                                .font(.headline)
                            Text(operation.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Label(operation.mcduPage, systemImage: "keyboard")
                        .font(.subheadline.monospaced())
                        .foregroundStyle(.cyan)
                }
            }

            // Steps
            Section("MCDU Steps") {
                ForEach(Array(operation.steps.enumerated()), id: \.element.id) { index, step in
                    FMGCStepRow(step: step, stepNumber: index + 1, color: operation.color)
                }
            }

            // Tips
            if !operation.tips.isEmpty {
                Section("Tips & Notes") {
                    ForEach(operation.tips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb")
                                .foregroundStyle(.yellow)
                                .font(.caption)
                                .padding(.top, 2)
                            Text(tip)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(operation.title)
    }
}

// MARK: - FMGC Step Row

struct FMGCStepRow: View {
    let step: FMGCStep
    let stepNumber: Int
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(stepNumber)")
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(color)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(step.keyPress)
                        .font(.caption.bold().monospaced())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                    if let display = step.display {
                        Text(display)
                            .font(.caption.monospaced())
                            .foregroundStyle(.green)
                    }
                }

                Text(step.action)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}
