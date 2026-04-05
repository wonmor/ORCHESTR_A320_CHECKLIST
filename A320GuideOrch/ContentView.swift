import SwiftUI
import SceneKit

// MARK: - Shared UI Components

enum CameraDirection {
    case left, right, forward, backward
}

struct EdgeButtons: View {
    var startMoving: (CameraDirection) -> Void
    var stopMoving: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Spacer()
                Button(action: { startMoving(.left) }) {
                    VStack {
                        Text("L"); Text("E"); Text("F"); Text("T")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                    .bold()
                }
                .buttonStyle(.bordered)
                .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                    if pressing { startMoving(.left) } else { stopMoving() }
                }, perform: {})
                Spacer()
            }
            .frame(width: 50)

            Spacer()

            VStack {
                Spacer()
                Button(action: { startMoving(.right) }) {
                    VStack {
                        Text("R"); Text("I"); Text("G"); Text("H"); Text("T")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                    .bold()
                }
                .buttonStyle(.bordered)
                .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                    if pressing { startMoving(.right) } else { stopMoving() }
                }, perform: {})
                Spacer()
            }
            .frame(width: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ArrowControls: View {
    var startMoving: (CameraDirection) -> Void
    var stopMoving: () -> Void

    var body: some View {
        VStack {
            Button(action: { startMoving(.forward) }) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.white)
            }
            .buttonStyle(.bordered)
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                if pressing { startMoving(.forward) } else { stopMoving() }
            }, perform: {})

            Button(action: { startMoving(.backward) }) {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.white)
            }
            .buttonStyle(.bordered)
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                if pressing { startMoving(.backward) } else { stopMoving() }
            }, perform: {})
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

// MARK: - Preview

#Preview {
    MainNavigationView()
        .preferredColorScheme(.dark)
}
