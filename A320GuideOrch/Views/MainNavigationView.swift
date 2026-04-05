import SwiftUI

// MARK: - Main Navigation

struct MainNavigationView: View {
    @State private var selectedTab: AppTab = .checklists
    @State private var searchText = ""

    var body: some View {
        #if os(iOS)
        tabNavigation
        #elseif os(macOS)
        sidebarNavigation
        #elseif os(visionOS)
        tabNavigation
        #endif
    }

    private var tabNavigation: some View {
        TabView(selection: $selectedTab) {
            ChecklistCategoryView()
                .tabItem {
                    Label("Checklists", systemImage: "checklist")
                }
                .tag(AppTab.checklists)

            EmergencyProceduresListView()
                .tabItem {
                    Label("Emergency", systemImage: "exclamationmark.triangle.fill")
                }
                .tag(AppTab.emergency)

            InstrumentGuideListView()
                .tabItem {
                    Label("Instruments", systemImage: "gauge.with.dots.needle.33percent")
                }
                .tag(AppTab.instruments)

            ApproachProcedureListView()
                .tabItem {
                    Label("Approaches", systemImage: "scope")
                }
                .tag(AppTab.approaches)

            FMGCOperationsListView()
                .tabItem {
                    Label("FMGC", systemImage: "keyboard")
                }
                .tag(AppTab.fmgc)

            POHReferenceView()
                .tabItem {
                    Label("POH", systemImage: "book.closed")
                }
                .tag(AppTab.poh)

            CockpitExplorerView()
                .tabItem {
                    Label("3D Cockpit", systemImage: "view.3d")
                }
                .tag(AppTab.cockpit3D)
        }
        .tint(.cyan)
    }

    #if os(macOS)
    private var sidebarNavigation: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Section("Operations") {
                    Label("Checklists", systemImage: "checklist")
                        .tag(AppTab.checklists)
                    Label("Emergency", systemImage: "exclamationmark.triangle.fill")
                        .tag(AppTab.emergency)
                }
                Section("Reference") {
                    Label("Instruments", systemImage: "gauge.with.dots.needle.33percent")
                        .tag(AppTab.instruments)
                    Label("Approaches", systemImage: "scope")
                        .tag(AppTab.approaches)
                    Label("FMGC", systemImage: "keyboard")
                        .tag(AppTab.fmgc)
                    Label("POH", systemImage: "book.closed")
                        .tag(AppTab.poh)
                }
                Section("Interactive") {
                    Label("3D Cockpit", systemImage: "view.3d")
                        .tag(AppTab.cockpit3D)
                }
            }
            .navigationTitle("A320 Guide")
        } detail: {
            switch selectedTab {
            case .checklists: ChecklistCategoryView()
            case .emergency: EmergencyProceduresListView()
            case .instruments: InstrumentGuideListView()
            case .approaches: ApproachProcedureListView()
            case .fmgc: FMGCOperationsListView()
            case .poh: POHReferenceView()
            case .cockpit3D: CockpitExplorerView()
            }
        }
    }
    #endif
}

enum AppTab: Hashable {
    case checklists
    case emergency
    case instruments
    case approaches
    case fmgc
    case poh
    case cockpit3D
}
