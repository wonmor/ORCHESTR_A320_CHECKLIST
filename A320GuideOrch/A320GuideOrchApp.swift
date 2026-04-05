import SwiftUI

@main
struct A320GuideOrchApp: App {
    var body: some Scene {
        WindowGroup {
            MainNavigationView()
                .preferredColorScheme(.dark)
        }
        #if os(macOS)
        .defaultSize(width: 1200, height: 800)
        #endif

        #if os(visionOS)
        WindowGroup(id: "cockpit-3d") {
            CockpitExplorerView()
                .preferredColorScheme(.dark)
        }
        .windowStyle(.volumetric)
        #endif
    }
}
