import SwiftUI

// MARK: - Main Navigation

struct MainNavigationView: View {
    @State private var selectedTab: AppTab = .checklists
    @State private var searchText = ""
    @State private var checklistStore = ChecklistStore()

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
            ChecklistCategoryView(store: checklistStore)
                .tabItem {
                    Label("Checklists", systemImage: "checklist")
                }
                .tag(AppTab.checklists)

            EmergencyProceduresListView()
                .tabItem {
                    Label("Emergency", systemImage: "exclamationmark.triangle.fill")
                }
                .tag(AppTab.emergency)

            VisualSightPictureView()
                .tabItem {
                    Label("Visual", systemImage: "eye.fill")
                }
                .tag(AppTab.visual)

            ApproachProcedureListView()
                .tabItem {
                    Label("Approaches", systemImage: "scope")
                }
                .tag(AppTab.approaches)

            QuizView()
                .tabItem {
                    Label("Quiz", systemImage: "brain.head.profile")
                }
                .tag(AppTab.quiz)

            CockpitExplorerView()
                .tabItem {
                    Label("3D Cockpit", systemImage: "view.3d")
                }
                .tag(AppTab.cockpit3D)

            MoreView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
                .tag(AppTab.more)
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
                    Label("Visual Sight Picture", systemImage: "eye.fill")
                        .tag(AppTab.visual)
                    Label("FMGC", systemImage: "keyboard")
                        .tag(AppTab.fmgc)
                    Label("POH", systemImage: "book.closed")
                        .tag(AppTab.poh)
                }
                Section("Interactive") {
                    Label("Quiz", systemImage: "brain.head.profile")
                        .tag(AppTab.quiz)
                    Label("3D Cockpit", systemImage: "view.3d")
                        .tag(AppTab.cockpit3D)
                }
            }
            .navigationTitle("A320 Guide")
        } detail: {
            switch selectedTab {
            case .checklists: ChecklistCategoryView(store: checklistStore)
            case .emergency: EmergencyProceduresListView()
            case .instruments: InstrumentGuideListView()
            case .approaches: ApproachProcedureListView()
            case .visual: VisualSightPictureView()
            case .fmgc: FMGCOperationsListView()
            case .poh: POHReferenceView()
            case .quiz: QuizView()
            case .cockpit3D: CockpitExplorerView()
            case .more: MoreView()
            }
        }
    }
    #endif
}

// MARK: - More View (overflow tabs for iOS)

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Reference") {
                    NavigationLink {
                        InstrumentGuideListView()
                    } label: {
                        Label("Instrument Guides", systemImage: "gauge.with.dots.needle.33percent")
                    }

                    NavigationLink {
                        FMGCOperationsListView()
                    } label: {
                        Label("FMGC Operations", systemImage: "keyboard")
                    }

                    NavigationLink {
                        POHReferenceView()
                    } label: {
                        Label("POH Reference", systemImage: "book.closed")
                    }
                }
            }
            .navigationTitle("More")
        }
    }
}

enum AppTab: Hashable {
    case checklists
    case emergency
    case instruments
    case approaches
    case visual
    case fmgc
    case poh
    case quiz
    case cockpit3D
    case more
}
