import SwiftUI
import SceneKit

struct ContentView: View {
    @State private var cameraPosition = SCNVector3(0, 0, 0)
    @State private var cameraFOV = CGFloat(60.0) // Default field of view

    var body: some View {
        VStack {
            SceneContainer(cameraPosition: $cameraPosition, cameraFOV: $cameraFOV)
                .ignoresSafeArea()
            VStack {
                Text("Camera Position: \(cameraPosition.description)")
                Text("Camera FOV: \(cameraFOV, specifier: "%.2f") degrees")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
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
        cameraNode.position = SCNVector3(center.x, center.y, center.z + 10)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func setupDepthOfField(_ camera: SCNCamera?) {
        camera?.automaticallyAdjustsZRange = true
        camera?.focalLength = 50
        camera?.fStop = 1.4
        camera?.focusDistance = 10
        camera?.fieldOfView = 60
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
