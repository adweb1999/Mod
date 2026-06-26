import UIKit
import Metal
import MetalKit
import QuartzCore

class GameViewController: UIViewController {
    var metalView: MTKView!
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var renderer: ImGuiRenderer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Metal
        device = MTLCreateSystemDefaultDevice()
        guard device != nil else {
            print("Metal is not supported on this device")
            return
        }

        // Create Metal view
        metalView = MTKView(frame: view.bounds, device: device)
        metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        metalView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.framebufferOnly = false
        metalView.preferredFramesPerSecond = 60
        metalView.enableSetNeedsDisplay = false
        metalView.isPaused = false
        view.addSubview(metalView)

        // Create command queue
        commandQueue = device.makeCommandQueue()

        // Initialize ImGui renderer
        renderer = ImGuiRenderer(device: device, view: metalView)
        metalView.delegate = renderer

        // Setup touch handler
        setupTouchHandler()
    }

    func setupTouchHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.numberOfTapsRequired = 3  // Triple tap to toggle menu
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        renderer.toggleMenu()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}
