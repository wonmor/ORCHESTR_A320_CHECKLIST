import SwiftUI

// MARK: - Visual Sight Picture View

struct VisualSightPictureView: View {
    @State private var approachAngle: Double = 3.0
    @State private var distanceNM: Double = 3.0
    @State private var selectedPAPI: PAPIConfiguration = .onGlideslope
    @State private var showPAPIGuide = false
    @State private var selectedVisualRef: VisualReference?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Interactive Approach Angle Visualizer
                    approachAngleSection

                    // PAPI Light Interpretation
                    papiSection

                    // Visual Reference Points
                    visualReferenceSection

                    // Runway Visual Cues
                    runwayCuesSection
                }
                .padding()
            }
            .navigationTitle("Visual Sight Picture")
        }
    }

    // MARK: - Approach Angle Visualizer

    private var approachAngleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Approach Profile", systemImage: "airplane.arrival")
                .font(.headline)

            // Approach visualization
            GeometryReader { geo in
                let width = geo.size.width
                let height: CGFloat = 200

                Canvas { context, size in
                    // Sky gradient
                    let skyGradient = Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)])
                    context.fill(
                        Path(CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.7)),
                        with: .linearGradient(skyGradient, startPoint: .zero, endPoint: CGPoint(x: 0, y: size.height * 0.7))
                    )

                    // Ground
                    let groundGradient = Gradient(colors: [Color.green.opacity(0.3), Color.green.opacity(0.15)])
                    context.fill(
                        Path(CGRect(x: 0, y: size.height * 0.7, width: size.width, height: size.height * 0.3)),
                        with: .linearGradient(groundGradient, startPoint: CGPoint(x: 0, y: size.height * 0.7), endPoint: CGPoint(x: 0, y: size.height))
                    )

                    // Runway (perspective)
                    let runwayStart = CGPoint(x: width * 0.15, y: height * 0.7)
                    let runwayWidth: CGFloat = 60
                    let perspectiveNarrow: CGFloat = max(5, runwayWidth * (1 - distanceNM / 10))

                    var runwayPath = Path()
                    runwayPath.move(to: CGPoint(x: runwayStart.x - runwayWidth / 2, y: runwayStart.y))
                    runwayPath.addLine(to: CGPoint(x: runwayStart.x + runwayWidth / 2, y: runwayStart.y))
                    runwayPath.addLine(to: CGPoint(x: runwayStart.x + perspectiveNarrow / 2, y: runwayStart.y - 80))
                    runwayPath.addLine(to: CGPoint(x: runwayStart.x - perspectiveNarrow / 2, y: runwayStart.y - 80))
                    runwayPath.closeSubpath()
                    context.fill(runwayPath, with: .color(.gray.opacity(0.6)))

                    // Centerline
                    var centerPath = Path()
                    centerPath.move(to: CGPoint(x: runwayStart.x, y: runwayStart.y))
                    centerPath.addLine(to: CGPoint(x: runwayStart.x, y: runwayStart.y - 80))
                    context.stroke(centerPath, with: .color(.white.opacity(0.5)), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    // Glideslope line (3° reference)
                    let gsEndY = runwayStart.y - 80
                    let gsEndX = runwayStart.x
                    let angleRad = 3.0 * .pi / 180
                    let gsLength = width * 0.75
                    let refStartX = gsEndX + gsLength
                    let refStartY = gsEndY - gsLength * CGFloat(tan(angleRad))

                    var refPath = Path()
                    refPath.move(to: CGPoint(x: gsEndX, y: gsEndY))
                    refPath.addLine(to: CGPoint(x: refStartX, y: refStartY))
                    context.stroke(refPath, with: .color(.green.opacity(0.4)), style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

                    // Actual approach line
                    let actualAngleRad = approachAngle * .pi / 180
                    let actualStartY = gsEndY - gsLength * CGFloat(tan(actualAngleRad))

                    var actualPath = Path()
                    actualPath.move(to: CGPoint(x: gsEndX, y: gsEndY))
                    actualPath.addLine(to: CGPoint(x: refStartX, y: actualStartY))
                    context.stroke(actualPath, with: .color(approachAngleColor), style: StrokeStyle(lineWidth: 2))

                    // Aircraft position
                    let distanceFraction = distanceNM / 10
                    let acX = gsEndX + gsLength * distanceFraction
                    let acY = gsEndY - gsLength * distanceFraction * CGFloat(tan(actualAngleRad))

                    // Aircraft symbol
                    let acRect = CGRect(x: acX - 10, y: acY - 5, width: 20, height: 10)
                    context.fill(Path(ellipseIn: acRect), with: .color(.cyan))

                    // Altitude readout
                    let altFt = Int(distanceNM * 6076 * tan(actualAngleRad * .pi / 180 > 0 ? actualAngleRad : 0.05))
                    let altText = Text("\(altFt) ft AGL")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)
                    context.draw(context.resolve(altText), at: CGPoint(x: acX, y: acY - 18))
                }
                .frame(height: height)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(height: 200)

            // Angle slider
            VStack(spacing: 8) {
                HStack {
                    Text("Approach Angle")
                        .font(.subheadline)
                    Spacer()
                    Text(String(format: "%.1f°", approachAngle))
                        .font(.subheadline.monospaced().bold())
                        .foregroundStyle(approachAngleColor)
                }

                Slider(value: $approachAngle, in: 1.5...5.0, step: 0.1)
                    .tint(approachAngleColor)

                HStack {
                    Text("Shallow")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Spacer()
                    Text("3° Standard")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    Spacer()
                    Text("Steep")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
            }

            // Distance slider
            VStack(spacing: 8) {
                HStack {
                    Text("Distance from Runway")
                        .font(.subheadline)
                    Spacer()
                    Text(String(format: "%.1f NM", distanceNM))
                        .font(.subheadline.monospaced().bold())
                        .foregroundStyle(.cyan)
                }

                Slider(value: $distanceNM, in: 0.5...10.0, step: 0.5)
                    .tint(.cyan)
            }

            // Calculated values
            let altitudeFt = distanceNM * 6076 * tan(approachAngle * .pi / 180)
            let descentRate = Int(tan(approachAngle * .pi / 180) * 140 * 101.3)

            HStack(spacing: 16) {
                InfoBadge(label: "ALT", value: "\(Int(altitudeFt)) ft", color: .cyan)
                InfoBadge(label: "VS", value: "\(descentRate) fpm", color: .orange)
                InfoBadge(label: "GS", value: "~140 kt", color: .green)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var approachAngleColor: Color {
        if abs(approachAngle - 3.0) < 0.3 { return .green }
        if approachAngle < 2.5 || approachAngle > 3.8 { return .red }
        return .yellow
    }

    // MARK: - PAPI Section

    private var papiSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("PAPI Interpretation", systemImage: "light.max")
                    .font(.headline)
                Spacer()
                Button {
                    withAnimation { showPAPIGuide.toggle() }
                } label: {
                    Image(systemName: showPAPIGuide ? "info.circle.fill" : "info.circle")
                        .foregroundStyle(.cyan)
                }
            }

            if showPAPIGuide {
                Text("PAPI (Precision Approach Path Indicator) uses 4 light units beside the runway. Red means you're below the light's transition angle; white means above.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }

            // Interactive PAPI display
            VStack(spacing: 16) {
                ForEach(PAPIConfiguration.allCases) { config in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedPAPI = config
                        }
                    } label: {
                        HStack(spacing: 12) {
                            // PAPI lights
                            HStack(spacing: 6) {
                                ForEach(0..<4, id: \.self) { i in
                                    Circle()
                                        .fill(config.lights[i] == .red ? Color.red : Color.white)
                                        .frame(width: 24, height: 24)
                                        .shadow(color: config.lights[i] == .red ? .red.opacity(0.6) : .white.opacity(0.6), radius: 4)
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(config.title)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(config.statusColor)
                                Text(config.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if selectedPAPI == config {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.cyan)
                            }
                        }
                        .padding()
                        .background(selectedPAPI == config ? config.statusColor.opacity(0.1) : Color.secondary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedPAPI == config ? config.statusColor.opacity(0.5) : Color.clear, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            // Action guidance based on selected PAPI
            HStack(spacing: 8) {
                Image(systemName: selectedPAPI.actionIcon)
                    .foregroundStyle(selectedPAPI.statusColor)
                Text(selectedPAPI.action)
                    .font(.subheadline.bold())
                    .foregroundStyle(selectedPAPI.statusColor)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(selectedPAPI.statusColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Visual Reference Points

    private var visualReferenceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Visual Reference Points", systemImage: "eye.fill")
                .font(.headline)

            ForEach(VisualReference.allCases) { ref in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedVisualRef = selectedVisualRef == ref ? nil : ref
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: ref.icon)
                                .foregroundStyle(ref.color)
                                .frame(width: 30)
                            VStack(alignment: .leading) {
                                Text(ref.title)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.primary)
                                Text(ref.distance)
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.cyan)
                            }
                            Spacer()
                            Image(systemName: selectedVisualRef == ref ? "chevron.up" : "chevron.down")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }

                        if selectedVisualRef == ref {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(ref.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Divider()

                                Text("What You Should See:")
                                    .font(.caption.bold())
                                    .foregroundStyle(.cyan)

                                ForEach(ref.visualCues, id: \.self) { cue in
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "eye")
                                            .font(.caption2)
                                            .foregroundStyle(.cyan)
                                            .padding(.top, 2)
                                        Text(cue)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                if let pilotAction = ref.pilotAction {
                                    Divider()
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "hand.point.up.left.fill")
                                            .font(.caption2)
                                            .foregroundStyle(.yellow)
                                            .padding(.top, 2)
                                        Text(pilotAction)
                                            .font(.caption.bold())
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                            .padding(.leading, 38)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Runway Visual Cues

    private var runwayCuesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Runway Markings Guide", systemImage: "road.lanes")
                .font(.headline)

            VStack(spacing: 0) {
                RunwayMarkingRow(name: "Threshold", description: "White stripes at runway start", marking: "||||", color: .white)
                RunwayMarkingRow(name: "Aiming Point", description: "Two bold rectangles, ~300m from threshold", marking: "██", color: .white)
                RunwayMarkingRow(name: "Touchdown Zone", description: "Symmetric stripe pairs, target landing area", marking: "== ==", color: .white)
                RunwayMarkingRow(name: "Centerline", description: "Dashed line along runway center", marking: "- - -", color: .white)
                RunwayMarkingRow(name: "Edge Markings", description: "Continuous white lines at runway edges", marking: "|   |", color: .white)
            }

            // Approach lighting note
            VStack(alignment: .leading, spacing: 6) {
                Label("Approach Lighting", systemImage: "light.beacon.max")
                    .font(.subheadline.bold())
                    .foregroundStyle(.yellow)
                Text("Most ILS-equipped runways have approach lighting (ALS/ALSF) extending up to 900m before the threshold. These provide visual guidance transitioning from instruments to visual references.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Supporting Views

struct InfoBadge: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2.bold())
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.monospaced().bold())
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RunwayMarkingRow: View {
    let name: String
    let description: String
    let marking: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Text(marking)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundStyle(color)
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}

// MARK: - PAPI Configuration

enum PAPILight {
    case red, white
}

enum PAPIConfiguration: String, CaseIterable, Identifiable {
    case tooHigh = "tooHigh"
    case slightlyHigh = "slightlyHigh"
    case onGlideslope = "onGlideslope"
    case slightlyLow = "slightlyLow"
    case tooLow = "tooLow"

    var id: String { rawValue }

    var lights: [PAPILight] {
        switch self {
        case .tooHigh: return [.white, .white, .white, .white]
        case .slightlyHigh: return [.red, .white, .white, .white]
        case .onGlideslope: return [.red, .red, .white, .white]
        case .slightlyLow: return [.red, .red, .red, .white]
        case .tooLow: return [.red, .red, .red, .red]
        }
    }

    var title: String {
        switch self {
        case .tooHigh: return "Too High"
        case .slightlyHigh: return "Slightly High"
        case .onGlideslope: return "On Glideslope (3°)"
        case .slightlyLow: return "Slightly Low"
        case .tooLow: return "Too Low"
        }
    }

    var description: String {
        switch self {
        case .tooHigh: return "All white — well above glideslope"
        case .slightlyHigh: return "1 red, 3 white — slightly above"
        case .onGlideslope: return "2 red, 2 white — on glideslope"
        case .slightlyLow: return "3 red, 1 white — slightly below"
        case .tooLow: return "All red — well below glideslope"
        }
    }

    var statusColor: Color {
        switch self {
        case .tooHigh: return .orange
        case .slightlyHigh: return .yellow
        case .onGlideslope: return .green
        case .slightlyLow: return .yellow
        case .tooLow: return .red
        }
    }

    var action: String {
        switch self {
        case .tooHigh: return "Increase rate of descent — reduce power"
        case .slightlyHigh: return "Minor correction — slight power reduction"
        case .onGlideslope: return "Maintain current approach path — stable"
        case .slightlyLow: return "Minor correction — add slight power"
        case .tooLow: return "Increase power immediately — risk of undershoot"
        }
    }

    var actionIcon: String {
        switch self {
        case .tooHigh: return "arrow.down.circle.fill"
        case .slightlyHigh: return "arrow.down.right.circle"
        case .onGlideslope: return "checkmark.circle.fill"
        case .slightlyLow: return "arrow.up.right.circle"
        case .tooLow: return "arrow.up.circle.fill"
        }
    }
}

// MARK: - Visual Reference Points

enum VisualReference: String, CaseIterable, Identifiable {
    case tenMile = "tenMile"
    case fiveMile = "fiveMile"
    case threeMile = "threeMile"
    case oneMile = "oneMile"
    case halfMile = "halfMile"
    case threshold = "threshold"
    case flare = "flare"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tenMile: return "10 NM — Initial Approach"
        case .fiveMile: return "5 NM — Intermediate"
        case .threeMile: return "3 NM — Final Approach"
        case .oneMile: return "1 NM — Short Final"
        case .halfMile: return "0.5 NM — Decision Point"
        case .threshold: return "Threshold — Over the Piano Keys"
        case .flare: return "Flare — Touchdown"
        }
    }

    var distance: String {
        switch self {
        case .tenMile: return "~3,100 ft AGL"
        case .fiveMile: return "~1,550 ft AGL"
        case .threeMile: return "~950 ft AGL"
        case .oneMile: return "~320 ft AGL"
        case .halfMile: return "~160 ft AGL"
        case .threshold: return "~50 ft AGL"
        case .flare: return "~15-30 ft AGL"
        }
    }

    var icon: String {
        switch self {
        case .tenMile: return "airplane"
        case .fiveMile: return "scope"
        case .threeMile: return "location.fill"
        case .oneMile: return "arrow.down.to.line"
        case .halfMile: return "exclamationmark.triangle"
        case .threshold: return "road.lanes"
        case .flare: return "airplane.arrival"
        }
    }

    var color: Color {
        switch self {
        case .tenMile: return .blue
        case .fiveMile: return .cyan
        case .threeMile: return .green
        case .oneMile: return .yellow
        case .halfMile: return .orange
        case .threshold: return .red
        case .flare: return .purple
        }
    }

    var description: String {
        switch self {
        case .tenMile: return "Intercepting the glideslope. Runway may be visible in good weather as a thin line."
        case .fiveMile: return "Established on approach. Runway shape becoming discernible. Configure flaps as appropriate."
        case .threeMile: return "Stable approach should be established. Runway rectangle clearly visible with markings."
        case .oneMile: return "Short final. Runway filling a significant portion of the windscreen. Detail visible."
        case .halfMile: return "Decision height region for CAT I ILS. Must have visual references to continue."
        case .threshold: return "Crossing the threshold markings. Begin transition from approach to landing attitude."
        case .flare: return "Pitch up gently to arrest descent. Look toward far end of runway for attitude reference."
        }
    }

    var visualCues: [String] {
        switch self {
        case .tenMile: return [
            "Runway may appear as a thin white/gray line",
            "Approach lights not yet individually distinguishable",
            "Terrain and landmarks for orientation",
            "PAPI not yet visible at most airports"
        ]
        case .fiveMile: return [
            "Runway shape becoming rectangular",
            "Approach lighting system visible as a line of lights",
            "Surrounding taxiways and buildings becoming visible",
            "PAPI lights may become visible"
        ]
        case .threeMile: return [
            "Runway clearly a rectangle — not a trapezoid (if on correct path)",
            "Threshold markings distinguishable",
            "PAPI clearly visible — check 2 red / 2 white",
            "Aiming point markings visible"
        ]
        case .oneMile: return [
            "Runway detail clear — centerline, edge markings",
            "Touchdown zone markings visible",
            "Aiming point filling significant windscreen area",
            "PAPI very prominent — use for fine glidepath control"
        ]
        case .halfMile: return [
            "Runway environment dominates forward view",
            "Individual runway edge lights clearly visible",
            "Able to assess surface condition (wet/dry)",
            "CAT I decision height: must see approach lights or runway"
        ]
        case .threshold: return [
            "Threshold (piano keys) passing below",
            "Aiming point ahead — do not land on threshold",
            "Runway width perspective confirms alignment",
            "Begin looking toward end of runway for pitch reference"
        ]
        case .flare: return [
            "Peripheral vision detects increasing closure rate with ground",
            "Far end of runway used for pitch attitude reference",
            "Runway edge lights rushing past peripherally",
            "Gentle pitch increase to 2-3° above approach attitude"
        ]
        }
    }

    var pilotAction: String? {
        switch self {
        case .tenMile: return "Configure aircraft, verify approach briefing complete"
        case .fiveMile: return "Final configuration — gear down, flaps set, checklist complete"
        case .threeMile: return "Confirm STABLE approach: speed, config, path, sink rate"
        case .oneMile: return "Call \"Runway in sight\" — crosscheck instruments vs visual"
        case .halfMile: return "At minimums: LAND or GO AROUND — no hesitation"
        case .threshold: return "Retard thrust levers, begin flare"
        case .flare: return "RETARD callout — idle thrust, hold attitude, let it settle"
        }
    }
}
