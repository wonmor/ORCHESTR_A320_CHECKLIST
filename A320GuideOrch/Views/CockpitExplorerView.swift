import SwiftUI
import SceneKit

// MARK: - Cockpit Explorer View

struct CockpitExplorerView: View {
    @State private var cameraPosition = SCNVector3(190, 1000, 78)
    @State private var cameraFOV = CGFloat(90.0)
    @State private var focusDistance = CGFloat(350)
    @State private var hitPosition = SCNVector3Zero
    @State private var detectedTargets: [CockpitTarget] = []
    @State private var movementDirection: CameraDirection? = nil
    @State private var movementSpeed: Float = 0.0
    @State private var movementTimer: Timer?
    @State private var showInfoPanel = false
    @State private var selectedTarget: CockpitTarget?
    @State private var showTargetList = false

    private let maxSpeed: Float = 30.0
    private let acceleration: Float = 5.0
    private let deceleration: Float = 2.5

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            CockpitSceneContainer(
                cameraPosition: $cameraPosition,
                cameraFOV: $cameraFOV,
                focusDistance: $focusDistance,
                hitPosition: $hitPosition,
                detectedTargets: $detectedTargets
            )
            .opacity(0.65)
            .ignoresSafeArea()

            CrosshairView()
                .frame(width: 20, height: 20)

            EdgeButtons(
                startMoving: startMoving,
                stopMoving: stopMoving
            )

            // Bottom HUD
            VStack {
                // Top bar
                HStack {
                    Button {
                        showTargetList = true
                    } label: {
                        Image(systemName: "list.bullet")
                            .font(.title3)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .foregroundStyle(.white)

                    Spacer()

                    Text("3D COCKPIT EXPLORER")
                        .font(.caption.bold().monospaced())
                        .foregroundStyle(.white.opacity(0.6))

                    Spacer()

                    Text(String(format: "(%.0f, %.0f, %.0f)", cameraPosition.x, cameraPosition.y, cameraPosition.z))
                        .font(.caption2.monospaced())
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()

                // Target detection display
                VStack(spacing: 8) {
                    if detectedTargets.isEmpty {
                        Text("POINT AT AN INSTRUMENT")
                            .font(.headline.monospaced())
                            .foregroundStyle(.white.opacity(0.5))
                    } else {
                        ForEach(detectedTargets) { target in
                            Button {
                                selectedTarget = target
                                showInfoPanel = true
                            } label: {
                                VStack(spacing: 4) {
                                    Text(target.name)
                                        .font(.title3.bold().monospaced())
                                        .foregroundStyle(.white)
                                    Text(target.category.rawValue)
                                        .font(.caption2)
                                        .foregroundStyle(.cyan)
                                    Text("Tap for details")
                                        .font(.caption2)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }

                ArrowControls(
                    startMoving: startMoving,
                    stopMoving: stopMoving
                )
                .padding()
                .padding(.bottom, 60)
            }
        }
        .sheet(isPresented: $showInfoPanel) {
            if let target = selectedTarget {
                TargetInfoSheet(target: target)
            }
        }
        .sheet(isPresented: $showTargetList) {
            CockpitTargetListSheet()
        }
    }

    func startMoving(direction: CameraDirection) {
        movementDirection = direction
        if movementTimer == nil {
            movementTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.updateMovement()
                }
            }
        }
    }

    func stopMoving() {
        movementDirection = nil
    }

    func updateMovement() {
        if movementDirection != nil {
            if movementSpeed < maxSpeed {
                movementSpeed += acceleration
            }
        } else {
            if movementSpeed > 0 {
                movementSpeed -= deceleration
                if movementSpeed < 0 {
                    movementSpeed = 0
                    movementTimer?.invalidate()
                    movementTimer = nil
                }
            }
        }
        moveCamera()
    }

    func moveCamera() {
        guard let direction = movementDirection, movementSpeed > 0 else { return }
        switch direction {
        case .left:
            cameraPosition = SCNVector3(cameraPosition.x, cameraPosition.y, cameraPosition.z + movementSpeed)
        case .right:
            cameraPosition = SCNVector3(cameraPosition.x, cameraPosition.y, cameraPosition.z - movementSpeed)
        case .forward:
            cameraPosition = SCNVector3(cameraPosition.x - movementSpeed, cameraPosition.y, cameraPosition.z)
        case .backward:
            cameraPosition = SCNVector3(cameraPosition.x + movementSpeed, cameraPosition.y, cameraPosition.z)
        }
    }
}

// MARK: - Target Info Sheet

struct TargetInfoSheet: View {
    let target: CockpitTarget
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(target.category.rawValue, systemImage: "location")
                            .font(.caption)
                            .foregroundStyle(.cyan)
                        Text(target.name)
                            .font(.title2.bold())
                        Text(target.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                // Find related content
                let relatedInstrument = A320Database.instrumentGuides.first {
                    target.name.localizedCaseInsensitiveContains($0.abbreviation) ||
                    target.name.localizedCaseInsensitiveContains($0.name)
                }

                if let instrument = relatedInstrument {
                    Section("Related Instrument Guide") {
                        NavigationLink {
                            InstrumentGuideDetailView(guide: instrument)
                        } label: {
                            InstrumentGuideRow(guide: instrument)
                        }
                    }
                }
            }
            .navigationTitle("Cockpit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Cockpit Target List Sheet

struct CockpitTargetListSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedZone: CockpitZone?

    private var grouped: [(CockpitZone, [CockpitTarget])] {
        let all = A320Database.cockpitTargets
        let filtered = selectedZone.map { zone in all.filter { $0.category == zone } } ?? all
        let grouped = Dictionary(grouping: filtered) { $0.category }
        return CockpitZone.allCases.compactMap { zone in
            guard let items = grouped[zone], !items.isEmpty else { return nil }
            return (zone, items)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            FilterChip(label: "All", isSelected: selectedZone == nil) {
                                selectedZone = nil
                            }
                            ForEach(CockpitZone.allCases, id: \.self) { zone in
                                FilterChip(label: zone.rawValue, isSelected: selectedZone == zone) {
                                    selectedZone = zone
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                ForEach(grouped, id: \.0) { zone, targets in
                    Section(zone.rawValue) {
                        ForEach(targets) { target in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(target.name)
                                    .font(.subheadline.bold())
                                Text(target.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("Cockpit Targets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Cross-Platform Scene Container

#if os(iOS) || os(visionOS)
struct CockpitSceneContainer: UIViewRepresentable {
    @Binding var cameraPosition: SCNVector3
    @Binding var cameraFOV: CGFloat
    @Binding var focusDistance: CGFloat
    @Binding var hitPosition: SCNVector3
    @Binding var detectedTargets: [CockpitTarget]

    @State private var cameraNode = SCNNode()

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = loadScene()
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.white

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        scnView.addGestureRecognizer(pinchGesture)

        context.coordinator.setupObservers(for: scnView)
        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.pointOfView?.position = cameraPosition
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func loadScene() -> SCNScene {
        let scene = SCNScene(named: "a320-cockpit.scn")!
        configureCamera(scene)
        configureLight(scene: scene)
        addTargetSpheres(scene)
        applyShaderModifier(to: scene)
        configureMaterials(scene)
        return scene
    }

    private func configureCamera(_ scene: SCNScene) {
        let boundingBox = scene.rootNode.boundingBox
        let center = SCNVector3(
            x: (boundingBox.max.x + boundingBox.min.x) / 2,
            y: (boundingBox.max.y + boundingBox.min.y) / 2,
            z: (boundingBox.max.z + boundingBox.min.z) / 2
        )
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.automaticallyAdjustsZRange = true
        cameraNode.camera?.focalLength = 50
        cameraNode.camera?.wantsDepthOfField = true
        cameraNode.camera?.focusDistance = 350
        cameraNode.camera?.fStop = 1.8 * pow(10, -4)
        cameraNode.camera?.fieldOfView = 95.0
        cameraNode.position = cameraPosition
        cameraNode.look(at: center)
        scene.rootNode.addChildNode(cameraNode)
    }

    private func configureLight(scene: SCNScene) {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.light?.castsShadow = false
        lightNode.light?.shadowColor = UIColor.black.withAlphaComponent(0.75)
        lightNode.light?.shadowRadius = 10.0
        lightNode.light?.zFar = 1000
        lightNode.light?.zNear = 1.0
        lightNode.position = SCNVector3(x: 100, y: 100, z: 100)
        lightNode.look(at: SCNVector3Zero)
        scene.rootNode.addChildNode(lightNode)
    }

    private func addTargetSpheres(_ scene: SCNScene) {
        for target in A320Database.cockpitTargets {
            let sphere = SCNSphere(radius: 30)
            sphere.firstMaterial?.diffuse.contents = UIColor.white
            sphere.firstMaterial?.transparency = 0.35
            sphere.firstMaterial?.isDoubleSided = true
            let node = SCNNode(geometry: sphere)
            node.position = SCNVector3(target.position.x, target.position.y, target.position.z)
            scene.rootNode.addChildNode(node)
        }
    }

    private func configureMaterials(_ scene: SCNScene) {
        scene.rootNode.enumerateChildNodes { node, _ in
            if let geometry = node.geometry {
                for material in geometry.materials {
                    material.lightingModel = .physicallyBased
                    material.writesToDepthBuffer = true
                    material.readsFromDepthBuffer = true
                }
            }
        }
    }

    private func applyShaderModifier(to scene: SCNScene) {
        let shaderModifier = """
           #pragma transparent
           #pragma body
           vec3 coolTint = vec3(0.0, 0.1, 0.1);
           float contrastFactor = 1.5;
           float brightnessFactor = 0.9;
           float saturationFactor = 1.1;
           vec3 currentColor = _output.color.rgb;
           vec3 mean = vec3(0.5);
           currentColor = (currentColor - mean) * contrastFactor + mean;
           currentColor *= brightnessFactor;
           float avg = (currentColor.r + currentColor.g + currentColor.b) / 3.0;
           currentColor = mix(vec3(avg), currentColor, saturationFactor);
           currentColor += coolTint;
           currentColor = clamp(currentColor, 0.0, 1.0);
           _output.color.rgb = currentColor;
           """
        scene.rootNode.enumerateChildNodes { node, _ in
            node.geometry?.shaderModifiers = [.fragment: shaderModifier]
        }
    }

    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var parent: CockpitSceneContainer

        init(_ parent: CockpitSceneContainer) {
            self.parent = parent
        }

        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            if gesture.state == .changed {
                let scale = gesture.scale
                let newFOV = max(15, min(90, parent.cameraFOV / CGFloat(scale)))
                parent.cameraFOV = newFOV
                gesture.scale = 1.0
            }
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: gesture.view)
            let deltaAngleX = Float(translation.x) / 100.0
            let deltaAngleY = Float(translation.y) / 100.0

            if let view = gesture.view as? SCNView, let cameraNode = view.pointOfView {
                var eulerAngles = cameraNode.eulerAngles
                eulerAngles.y -= deltaAngleX
                eulerAngles.x -= deltaAngleY
                eulerAngles.x = max(min(eulerAngles.x, Float.pi / 2), -Float.pi / 2)
                cameraNode.eulerAngles = eulerAngles
                gesture.setTranslation(.zero, in: view)
            }
        }

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard let scnView = renderer as? SCNView, let cameraNode = renderer.pointOfView else { return }
            DispatchQueue.main.async {
                let centerPoint = CGPoint(x: scnView.bounds.midX, y: scnView.bounds.midY)
                self.performHitTest(scnView, centerPoint: centerPoint, cameraNode: cameraNode)
                if let fov = cameraNode.camera?.fieldOfView {
                    self.parent.cameraFOV = fov
                }
            }
        }

        private func performHitTest(_ scnView: SCNView, centerPoint: CGPoint, cameraNode: SCNNode) {
            let hitResults = scnView.hitTest(centerPoint, options: nil)
            guard let closestHit = hitResults.first else { return }

            let hitPos = closestHit.worldCoordinates
            let camPos = cameraNode.position
            let distance = sqrt(
                pow(hitPos.x - camPos.x, 2) +
                pow(hitPos.y - camPos.y, 2) +
                pow(hitPos.z - camPos.z, 2)
            )

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            cameraNode.camera?.focusDistance = CGFloat(distance)
            SCNTransaction.commit()

            self.parent.hitPosition = hitPos
            let tolerance: Float = 50

            var found: [CockpitTarget] = []
            for target in A320Database.cockpitTargets {
                let d = sqrt(
                    pow(hitPos.x - target.position.x, 2) +
                    pow(hitPos.y - target.position.y, 2) +
                    pow(hitPos.z - target.position.z, 2)
                )
                if d <= tolerance {
                    found.append(target)
                }
            }

            DispatchQueue.main.async {
                self.parent.detectedTargets = found
                self.parent.focusDistance = CGFloat(distance)
            }
        }

        func setupObservers(for scnView: SCNView) {
            scnView.delegate = self
        }
    }
}
#elseif os(macOS)
struct CockpitSceneContainer: NSViewRepresentable {
    @Binding var cameraPosition: SCNVector3
    @Binding var cameraFOV: CGFloat
    @Binding var focusDistance: CGFloat
    @Binding var hitPosition: SCNVector3
    @Binding var detectedTargets: [CockpitTarget]

    @State private var cameraNode = SCNNode()

    func makeNSView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = loadScene()
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = NSColor.white
        context.coordinator.setupObservers(for: scnView)
        return scnView
    }

    func updateNSView(_ scnView: SCNView, context: Context) {
        scnView.pointOfView?.position = cameraPosition
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func loadScene() -> SCNScene {
        let scene = SCNScene(named: "a320-cockpit.scn")!
        configureCamera(scene)

        // Add target spheres
        for target in A320Database.cockpitTargets {
            let sphere = SCNSphere(radius: 30)
            sphere.firstMaterial?.diffuse.contents = NSColor.white
            sphere.firstMaterial?.transparency = 0.35
            sphere.firstMaterial?.isDoubleSided = true
            let node = SCNNode(geometry: sphere)
            node.position = SCNVector3(target.position.x, target.position.y, target.position.z)
            scene.rootNode.addChildNode(node)
        }

        // Light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.position = SCNVector3(100, 100, 100)
        lightNode.look(at: SCNVector3Zero)
        scene.rootNode.addChildNode(lightNode)

        return scene
    }

    private func configureCamera(_ scene: SCNScene) {
        let boundingBox = scene.rootNode.boundingBox
        let center = SCNVector3(
            x: (boundingBox.max.x + boundingBox.min.x) / 2,
            y: (boundingBox.max.y + boundingBox.min.y) / 2,
            z: (boundingBox.max.z + boundingBox.min.z) / 2
        )
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.automaticallyAdjustsZRange = true
        cameraNode.camera?.fieldOfView = 95.0
        cameraNode.position = cameraPosition
        cameraNode.look(at: center)
        scene.rootNode.addChildNode(cameraNode)
    }

    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var parent: CockpitSceneContainer

        init(_ parent: CockpitSceneContainer) {
            self.parent = parent
        }

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard let scnView = renderer as? SCNView, let cameraNode = renderer.pointOfView else { return }
            DispatchQueue.main.async {
                let centerPoint = CGPoint(x: scnView.bounds.midX, y: scnView.bounds.midY)
                let hitResults = scnView.hitTest(centerPoint, options: nil)
                guard let closestHit = hitResults.first else { return }

                let hitPos = closestHit.worldCoordinates
                self.parent.hitPosition = hitPos
                let tolerance: Float = 50

                var found: [CockpitTarget] = []
                for target in A320Database.cockpitTargets {
                    let d = sqrt(
                        pow(hitPos.x - target.position.x, 2) +
                        pow(hitPos.y - target.position.y, 2) +
                        pow(hitPos.z - target.position.z, 2)
                    )
                    if d <= tolerance {
                        found.append(target)
                    }
                }
                self.parent.detectedTargets = found
            }
        }

        func setupObservers(for scnView: SCNView) {
            scnView.delegate = self
        }
    }
}
#endif
