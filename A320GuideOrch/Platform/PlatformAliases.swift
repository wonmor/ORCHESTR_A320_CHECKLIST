import SwiftUI
import SceneKit

// MARK: - Cross-Platform Type Aliases

#if os(iOS) || os(visionOS)
import UIKit
typealias PlatformColor = UIColor
typealias PlatformImage = UIImage
typealias PlatformFont = UIFont
#elseif os(macOS)
import AppKit
typealias PlatformColor = NSColor
typealias PlatformImage = NSImage
typealias PlatformFont = NSFont
#endif

// MARK: - Cross-Platform SceneKit View

#if os(iOS) || os(visionOS)
typealias PlatformViewRepresentable = UIViewRepresentable
typealias PlatformSCNView = UIViewRepresentable
#elseif os(macOS)
typealias PlatformViewRepresentable = NSViewRepresentable
typealias PlatformSCNView = NSViewRepresentable
#endif
