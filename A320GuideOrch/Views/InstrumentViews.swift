import SwiftUI

// MARK: - Instrument Guide List

struct InstrumentGuideListView: View {
    @State private var searchText = ""

    private var filtered: [InstrumentGuide] {
        if searchText.isEmpty { return A320Database.instrumentGuides }
        return A320Database.instrumentGuides.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.abbreviation.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { guide in
                NavigationLink {
                    InstrumentGuideDetailView(guide: guide)
                } label: {
                    InstrumentGuideRow(guide: guide)
                }
            }
            .navigationTitle("Instrument Guides")
            .searchable(text: $searchText, prompt: "Search instruments...")
        }
    }
}

// MARK: - Instrument Guide Row

struct InstrumentGuideRow: View {
    let guide: InstrumentGuide

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(guide.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: guide.icon)
                    .font(.title2)
                    .foregroundStyle(guide.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(guide.abbreviation)
                        .font(.headline.monospaced())
                        .foregroundStyle(guide.color)
                    Text("—")
                        .foregroundStyle(.secondary)
                    Text(guide.name)
                        .font(.subheadline)
                }
                Text(guide.location)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Instrument Guide Detail

struct InstrumentGuideDetailView: View {
    let guide: InstrumentGuide

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: guide.icon)
                            .font(.largeTitle)
                            .foregroundStyle(guide.color)
                        VStack(alignment: .leading) {
                            Text(guide.abbreviation)
                                .font(.title.bold().monospaced())
                            Text(guide.name)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(guide.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Label(guide.location, systemImage: "location")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            ForEach(guide.sections) { section in
                Section(section.title) {
                    ForEach(section.items) { item in
                        InstrumentDetailRow(item: item, accentColor: guide.color)
                    }
                }
            }
        }
        .navigationTitle(guide.abbreviation)
    }
}

// MARK: - Instrument Detail Row

struct InstrumentDetailRow: View {
    let item: InstrumentDetail
    let accentColor: Color

    private var indicatorColor: Color {
        guard let colorName = item.color else { return accentColor }
        switch colorName.lowercased() {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "magenta", "pink": return .pink
        case "amber", "orange": return .orange
        case "yellow": return .yellow
        case "cyan": return .cyan
        case "white": return .white
        default: return accentColor
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                if item.color != nil {
                    Circle()
                        .fill(indicatorColor)
                        .frame(width: 8, height: 8)
                }
                Text(item.label)
                    .font(.subheadline.bold())
            }
            Text(item.description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}
