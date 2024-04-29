import SwiftUI
import SceneKit

struct ContentView: View {
    @State private var cameraPosition = SCNVector3(250, 1150, -275) // Updated default position
    @State private var cameraFOV = CGFloat(90.0) // Updated default field of view to 90 degrees

    var body: some View {
        ZStack {
            SceneContainer(cameraPosition: $cameraPosition, cameraFOV: $cameraFOV)
                .ignoresSafeArea()
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
            }
            .padding()
        }
    }
}

struct SceneContainer: UIViewRepresentable {
    @Binding var cameraPosition: SCNVector3
    @Binding var cameraFOV: CGFloat

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = loadScene()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.black
        
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

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        setupDepthOfField(cameraNode.camera)
        cameraNode.position = SCNVector3(250, 1150, -275) // Updated default camera position
        cameraNode.look(at: center)
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.camera?.fieldOfView = 90.0 // Set FOV to 90 degrees
    }
    
    private func setupDepthOfField(_ camera: SCNCamera?) {
        camera?.automaticallyAdjustsZRange = true
        camera?.focalLength = 50
        camera?.wantsDepthOfField = true
        camera?.focusDistance = 350
        camera?.fStop = 0.0001
        camera?.fieldOfView = 60 // This line is redundant and can be removed since FOV is set above
    }
    
    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var parent: SceneContainer

        init(_ parent: SceneContainer) {
            self.parent = parent
        }

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard let cameraNode = renderer.pointOfView else { return }
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
