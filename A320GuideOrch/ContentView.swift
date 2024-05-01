import SwiftUI
import SceneKit

struct ArrowControls: View {
    var moveLeft: () -> Void
    var moveRight: () -> Void
    var moveForward: () -> Void
    var moveBackward: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: moveLeft) {
                Image(systemName: "arrow.left.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            VStack {
                Button(action: moveForward) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                Button(action: moveBackward) {
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            Button(action: moveRight) {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
}


struct ContentView: View {
    @State private var cameraPosition = SCNVector3(190, 1182, 393)  // Updated default position
    @State private var cameraFOV = CGFloat(0.0) // Updated default field of view to 90 degrees
    @State private var focusDistance = CGFloat(350)
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            SceneContainer(cameraPosition: $cameraPosition, cameraFOV: $cameraFOV, focusDistance: $focusDistance)
                .opacity(0.85)
                .ignoresSafeArea()
            
            CrosshairView()
                .frame(width: 20, height: 20)
            
            VStack {
                Spacer()
                
                Text("Camera Position: \(cameraPosition.description)")
                    .bold()
                    .monospaced()
                    .foregroundStyle(.white)
                
                Text("Camera FOV: \(cameraFOV, specifier: "%.2f") degrees")
                    .bold()
                    .monospaced()
                    .foregroundStyle(.white)
                
                Text("Focus Distance: \(focusDistance, specifier: "%.2f")")
                    .bold()
                    .monospaced()
                    .foregroundStyle(.white)
                
                ArrowControls(
                    moveLeft: { moveCamera(direction: .left) },
                    moveRight: { moveCamera(direction: .right) },
                    moveForward: { moveCamera(direction: .forward) },
                    moveBackward: { moveCamera(direction: .backward) }
                )
                .padding()
            }
        }
    }
    
    enum CameraDirection {
        case left, right, forward, backward
    }
    
    func moveCamera(direction: CameraDirection) {
        let movementStep: Float = 5 // Increase this value to make each movement more drastic
        var moveVector = SCNVector3()
        switch direction {
        case .left:
            moveVector = SCNVector3(cameraPosition.x - movementStep, cameraPosition.y, cameraPosition.z)
        case .right:
            moveVector = SCNVector3(cameraPosition.x + movementStep, cameraPosition.y, cameraPosition.z)
        case .forward:
            moveVector = SCNVector3(cameraPosition.x, cameraPosition.y, cameraPosition.z + movementStep)
        case .backward:
            moveVector = SCNVector3(cameraPosition.x, cameraPosition.y, cameraPosition.z - movementStep)
        }
        // This just updates the state, you'll need to apply this to the SceneKit camera node
        cameraPosition = moveVector
    }
}

struct CrosshairView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let midX = geometry.size.width / 2
                let midY = geometry.size.height / 2
                path.move(to: CGPoint(x: midX, y: midY - 10))
                path.addLine(to: CGPoint(x: midX, y: midY + 10))
                path.move(to: CGPoint(x: midX - 10, y: midY))
                path.addLine(to: CGPoint(x: midX + 10, y: midY))
            }
            .stroke(Color.white, lineWidth: 2.5)
        }
    }
}

struct SceneContainer: UIViewRepresentable {
    @Binding var cameraPosition: SCNVector3
    @Binding var cameraFOV: CGFloat
    @Binding var focusDistance: CGFloat
    
    @State private var cameraNode = SCNNode()
    
    private func configureLight(scene: SCNScene) {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional  // Or .spot
        lightNode.light?.castsShadow = false
        lightNode.light?.shadowColor = UIColor.black.withAlphaComponent(0.75) // Soften the shadow with transparency
        lightNode.light?.shadowRadius = 10.0 // Adjust for softer edges
        lightNode.light?.zFar = 1000  // Set based on the size of your scene
        lightNode.light?.zNear = 1.0
        
        // Position the light to point towards the scene
        lightNode.position = SCNVector3(x: 100, y: 100, z: 100)
        lightNode.look(at: SCNVector3Zero)  // Assuming you want it to point at the origin
        scene.rootNode.addChildNode(lightNode)
    }
    
    private func configureMaterialProperties(for node: SCNNode) {
        node.enumerateChildNodes { (childNode, _) in
            if let geometry = childNode.geometry {
                for material in geometry.materials {
                    material.lightingModel = .physicallyBased // Better shadow and lighting
                    material.writesToDepthBuffer = true
                    material.readsFromDepthBuffer = true
                }
            }
        }
    }
    
    
    func setupSceneView(scnView: SCNView) {
        scnView.scene = loadScene()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.black  // Or any suitable color
        
        configureLight(scene: scnView.scene!)
        scnView.scene?.rootNode.childNodes.forEach { node in
            configureMaterialProperties(for: node)
        }
    }
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = loadScene()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.white
        
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
        setupDepthOfField(cameraNode.camera)
        cameraNode.position = cameraPosition// Updated default camera position
        cameraNode.look(at: center)
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.camera?.fieldOfView = 95.0 // Set FOV to 90 degrees
        
        applyShaderModifier(to: scene)
    }
    
    enum CollisionCategory: Int {
        case camera = 1  // equivalent to 1 << 0
        case geometry = 2  // equivalent to 1 << 1
    }
    
    private func applyShaderModifier(to scene: SCNScene) {
        let shaderModifier = """
           #pragma transparent
           #pragma body
           
           // Base color adjustments
           vec3 coolTint = vec3(0.0, 0.1, 0.1); // Slightly blue tint
           float contrastFactor = 1.5; // Higher contrast
           float brightnessFactor = 0.9; // Slightly darker
           float saturationFactor = 1.1; // Slightly more saturated
           
           // Extract current pixel color
           vec3 currentColor = _output.color.rgb;
           
           // Apply contrast
           vec3 mean = vec3(0.5);
           currentColor = (currentColor - mean) * contrastFactor + mean;
           
           // Apply brightness
           currentColor *= brightnessFactor;
           
           // Apply saturation
           float avg = (currentColor.r + currentColor.g + currentColor.b) / 3.0;
           currentColor = mix(vec3(avg), currentColor, saturationFactor);
           
           // Mix with cool tint
           currentColor += coolTint;
           
           // Ensure the color is within the valid range
           currentColor = clamp(currentColor, 0.0, 1.0);
           
           _output.color.rgb = currentColor;
           """
        scene.rootNode.enumerateChildNodes { node, _ in
            node.geometry?.shaderModifiers = [.fragment: shaderModifier]
        }
    }
    
    
    private func setupDepthOfField(_ camera: SCNCamera?) {
        camera?.automaticallyAdjustsZRange = true
        camera?.focalLength = 50
        camera?.wantsDepthOfField = true
        camera?.focusDistance = 350
        camera?.fStop = 1.2 * pow(10, -4) // f 1.2
        camera?.fieldOfView = 60 // This line is redundant and can be removed since FOV is set above
    }
    
    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var parent: SceneContainer
        
        init(_ parent: SceneContainer) {
            self.parent = parent
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
        
        private func createRectangleAtHitResult(hitResult: SCNHitTestResult, scene: SCNScene) {
            // Main rectangle
            let rectangle = SCNPlane(width: 1.0, height: 1.0)
            let rectangleNode = SCNNode(geometry: rectangle)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white.withAlphaComponent(0.5) // Semi-transparent white
            rectangle.materials = [material]

            // Border rectangle
            let borderSize: CGFloat = 1.05 // 5% larger
            let borderRectangle = SCNPlane(width: rectangle.width * borderSize, height: rectangle.height * borderSize)
            let borderNode = SCNNode(geometry: borderRectangle)
            let borderMaterial = SCNMaterial()
            borderMaterial.diffuse.contents = UIColor.white
            borderRectangle.materials = [borderMaterial]

            // Position border behind the main rectangle
            borderNode.position = SCNVector3(0, 0, -0.01) // Slightly behind the main rectangle

            // Position the rectangle at the hit point
            rectangleNode.position = SCNVector3(
                x: hitResult.worldCoordinates.x,
                y: hitResult.worldCoordinates.y,
                z: hitResult.worldCoordinates.z
            )

            // Rotate to align with the surface normal
            let normal = hitResult.worldNormal
            rectangleNode.eulerAngles = SCNVector3(
                x: -atan2(normal.z, normal.y) + Float.pi / 2,
                y: 0,
                z: atan2(normal.x, normal.y)
            )

            // Add border node as a child to the main rectangle node
            rectangleNode.addChildNode(borderNode)

            // Add the whole setup to the scene
            scene.rootNode.addChildNode(rectangleNode)
        }

        
        private func performHitTest(_ scnView: SCNView, centerPoint: CGPoint, cameraNode: SCNNode) {
            let hitResults = scnView.hitTest(centerPoint, options: nil)
            
            if let closestHit = hitResults.first {
                createRectangleAtHitResult(hitResult: closestHit, scene: scnView.scene!)
                let hitPosition = closestHit.worldCoordinates
                let cameraPosition = cameraNode.position
                let distance = sqrt(
                    pow(hitPosition.x - cameraPosition.x, 2) +
                    pow(hitPosition.y - cameraPosition.y, 2) +
                    pow(hitPosition.z - cameraPosition.z, 2)
                )
                
                // Animate the change in focus distance
                let duration: TimeInterval = 0.5 // Duration of the animation in seconds
                SCNTransaction.begin()
                SCNTransaction.animationDuration = duration
                cameraNode.camera?.focusDistance = CGFloat(distance)
                SCNTransaction.commit()
                
                DispatchQueue.main.async {
                    self.parent.focusDistance = CGFloat(distance)
                }
            }
            
            DispatchQueue.main.async {
                self.parent.cameraPosition = cameraNode.position
                if let fov = cameraNode.camera?.fieldOfView {
                    self.parent.cameraFOV = fov
                }
            }
        }
        
        func setupObservers(for scnView: SCNView) {
            scnView.delegate = self
        }
    }
}

extension SCNVector3 {
    var description: String {
        return "(\(x), \(y), \(z))"
    }
}

extension SceneContainer.Coordinator {
    func calculateNewCameraPosition() -> SCNVector3 {
        // Example of moving forward while checking for obstacles
        let forwardMovement = SCNVector3(0, 0, -1)  // Move forward along z-axis
        let potentialNewPosition = SCNVector3(
            x: parent.cameraNode.position.x + forwardMovement.x,
            y: parent.cameraNode.position.y + forwardMovement.y,
            z: parent.cameraNode.position.z + forwardMovement.z
        )
        
        // Here you can check if the new position would result in a collision
        // If a collision is expected, you can adjust the position or cancel the movement
        return potentialNewPosition  // Adjust as needed based on collision checks
    }
}


#Preview {
    ContentView()
}
