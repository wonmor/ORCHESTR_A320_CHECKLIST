import SwiftUI

// MARK: - POH Reference View

struct POHReferenceView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List(A320Database.pohSections) { section in
                NavigationLink {
                    POHSectionDetailView(section: section)
                } label: {
                    POHSectionRow(section: section)
                }
            }
            .navigationTitle("POH Reference")
            .searchable(text: $searchText, prompt: "Search POH...")
        }
    }
}

// MARK: - POH Section Row

struct POHSectionRow: View {
    let section: POHSection

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(section.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: section.icon)
                    .font(.title2)
                    .foregroundStyle(section.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(section.title)
                    .font(.headline)
                Text("\(section.subsections.count) subsections")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - POH Section Detail

struct POHSectionDetailView: View {
    let section: POHSection

    var body: some View {
        List {
            ForEach(section.subsections) { subsection in
                Section(subsection.title) {
                    ForEach(subsection.content) { entry in
                        POHEntryRow(entry: entry, accentColor: section.color)
                    }
                }
            }
        }
        .navigationTitle(section.title)
    }
}

// MARK: - POH Entry Row

struct POHEntryRow: View {
    let entry: POHEntry
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.parameter)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Spacer()
                HStack(spacing: 4) {
                    Text(entry.value)
                        .font(.subheadline.bold().monospaced())
                        .foregroundStyle(accentColor)
                    if let unit = entry.unit, !unit.isEmpty {
                        Text(unit)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            if let note = entry.note {
                Text(note)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}
