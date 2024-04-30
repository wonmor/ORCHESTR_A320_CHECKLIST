import SwiftUI
import SceneKit

struct ContentView: View {
    @State private var cameraPosition = SCNVector3(0, 0, 0) // Updated default position
    @State private var cameraFOV = CGFloat(0.0) // Updated default field of view to 90 degrees
    @State private var focusDistance = CGFloat(350)

    var body: some View {
        ZStack {
            SceneContainer(cameraPosition: $cameraPosition, cameraFOV: $cameraFOV, focusDistance: $focusDistance)
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
            }
            .padding()
        }
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
        // Updates are managed by SceneKit's rendering loop and observers
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func loadScene() -> SCNScene {
        let scene = SCNScene(named: "a320-cockpit.scn")!
        configureCamera(scene)
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
        cameraNode.position = SCNVector3(190, 1182, 393) // Updated default camera position
        cameraNode.look(at: center)
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.camera?.fieldOfView = 95.0 // Set FOV to 90 degrees
        
        applyShaderModifier(to: scene)
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

            // Ensure UI interactions are on the main thread
            DispatchQueue.main.async {
                let centerPoint = CGPoint(x: scnView.bounds.midX, y: scnView.bounds.midY)
                self.performHitTest(scnView, centerPoint: centerPoint, cameraNode: cameraNode)
            }
        }

        private func performHitTest(_ scnView: SCNView, centerPoint: CGPoint, cameraNode: SCNNode) {
            let hitResults = scnView.hitTest(centerPoint, options: nil)

            if let closestHit = hitResults.first {
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

#Preview {
    ContentView()
}
