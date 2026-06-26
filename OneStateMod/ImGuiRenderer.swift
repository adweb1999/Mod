import UIKit
import Metal
import MetalKit

// MARK: - Feature Flags
class ModFeatures {
    static let shared = ModFeatures()

    // ESP
    var espEnabled = false
    var espBox = false
    var espSkeleton = false
    var espName = false
    var espDistance = false
    var espHealth = false
    var espTeam = false
    var espLines = false

    // Aimbot
    var aimbotEnabled = false
    var aimbotSilent = false
    var aimbotLock = false
    var aimbotFOV = false
    var aimbotFOVRadius: Float = 150.0
    var aimbotSmooth: Float = 0.5
    var aimbotBone = 0

    // Player
    var speedHack = false
    var speedMultiplier: Float = 2.0
    var godMode = false
    var infiniteAmmo = false
    var noRecoil = false
    var noSpread = false
    var rapidFire = false
    var wallHack = false
    var flyMode = false
    var teleport = false

    // Vehicle
    var vehicleSpeed = false
    var vehicleSpeedMultiplier: Float = 3.0
    var vehicleGodMode = false
    var vehicleFly = false
    var vehicleInstantStop = false
    var vehicleDriftMode = false

    // Misc
    var antiBan = false
    var removeAds = false
    var unlockAll = false
    var freeShopping = false
    var xpMultiplier = false
    var xpMultiplierValue: Float = 10.0

    // Menu
    var menuAlpha: Float = 0.95
    var showWatermark = true
    var rainbowMode = false

    // Login
    var isLoggedIn = false
    var username = ""
    var showLogin = true
}

// MARK: - ImGui Renderer
class ImGuiRenderer: NSObject, MTKViewDelegate {
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var view: MTKView
    private var features = ModFeatures.shared

    // ImGui context (simplified - in real implementation use C++ bridge)
    private var context: OpaquePointer?
    private var menuOpen = true
    private var selectedTab = 0
    private var rainbowHue: Float = 0.0

    // Colors
    private var primaryColor = SIMD4<Float>(0.0, 0.6, 1.0, 1.0)
    private var secondaryColor = SIMD4<Float>(1.0, 0.2, 0.2, 1.0)
    private var successColor = SIMD4<Float>(0.2, 1.0, 0.4, 1.0)
    private var warningColor = SIMD4<Float>(1.0, 0.8, 0.0, 1.0)

    // Login fields
    private var usernameBuffer = [CChar](repeating: 0, count: 64)
    private var passwordBuffer = [CChar](repeating: 0, count: 64)

    init(device: MTLDevice, view: MTKView) {
        self.device = device
        self.view = view
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        initializeImGui()
    }

    func initializeImGui() {
        // In real implementation, initialize C++ ImGui here
        // For now, we'll use a simplified Swift-based UI
        print("[OneStateMod] ImGui initialized")
    }

    func toggleMenu() {
        menuOpen = !menuOpen
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else { return }

        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!

        // Update rainbow animation
        if features.rainbowMode {
            rainbowHue += 0.01
            if rainbowHue > 1.0 { rainbowHue = 0.0 }
            primaryColor = SIMD4<Float>(
                abs(sin(rainbowHue * 6.283)),
                abs(sin((rainbowHue + 0.33) * 6.283)),
                abs(sin((rainbowHue + 0.66) * 6.283)),
                1.0
            )
        }

        // Draw UI (simplified - in real implementation use ImGui draw commands)
        if menuOpen {
            drawMenu(renderEncoder: renderEncoder)
        }

        // Draw watermark
        if features.showWatermark {
            drawWatermark(renderEncoder: renderEncoder)
        }

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    // MARK: - Drawing Methods

    private func drawMenu(renderEncoder: MTLRenderCommandEncoder) {
        // In real implementation, this would render ImGui widgets
        // For now, we draw a placeholder background

        if features.showLogin {
            drawLoginScreen(renderEncoder: renderEncoder)
        } else {
            drawMainMenu(renderEncoder: renderEncoder)
        }
    }

    private func drawLoginScreen(renderEncoder: MTLRenderCommandEncoder) {
        // Draw login background
        let rect = CGRect(x: 60, y: 100, width: 300, height: 350)
        drawRoundedRect(rect: rect, color: SIMD4<Float>(0.06, 0.06, 0.1, features.menuAlpha), 
                       renderEncoder: renderEncoder, cornerRadius: 8)

        // Title
        drawText("OneState Mod Menu", x: 150, y: 130, 
                color: primaryColor, size: 20, renderEncoder: renderEncoder)
        drawText("Premium Edition", x: 170, y: 155, 
                color: SIMD4<Float>(0.5, 0.5, 0.5, 1.0), size: 12, renderEncoder: renderEncoder)

        // Login fields (simplified)
        drawText("Username: admin", x: 80, y: 200, 
                color: SIMD4<Float>(1, 1, 1, 1), size: 14, renderEncoder: renderEncoder)
        drawText("Password: 123456", x: 80, y: 230, 
                color: SIMD4<Float>(1, 1, 1, 1), size: 14, renderEncoder: renderEncoder)

        // Login button
        let btnRect = CGRect(x: 80, y: 280, width: 260, height: 45)
        drawRoundedRect(rect: btnRect, color: primaryColor, 
                       renderEncoder: renderEncoder, cornerRadius: 6)
        drawText("Login", x: 200, y: 295, 
                color: SIMD4<Float>(1, 1, 1, 1), size: 16, renderEncoder: renderEncoder)

        // Skip button
        let skipRect = CGRect(x: 80, y: 340, width: 260, height: 35)
        drawRoundedRect(rect: skipRect, color: SIMD4<Float>(0.3, 0.3, 0.4, 1.0), 
                       renderEncoder: renderEncoder, cornerRadius: 6)
        drawText("Skip Login (Offline)", x: 155, y: 350, 
                color: SIMD4<Float>(1, 1, 1, 1), size: 12, renderEncoder: renderEncoder)
    }

    private func drawMainMenu(renderEncoder: MTLRenderCommandEncoder) {
        let menuWidth: CGFloat = 500
        let menuHeight: CGFloat = 600
        let menuX = (view.bounds.width - menuWidth) / 2
        let menuY = (view.bounds.height - menuHeight) / 2

        // Background
        let bgRect = CGRect(x: menuX, y: menuY, width: menuWidth, height: menuHeight)
        drawRoundedRect(rect: bgRect, color: SIMD4<Float>(0.06, 0.06, 0.1, features.menuAlpha), 
                       renderEncoder: renderEncoder, cornerRadius: 8)

        // Header
        drawText("Welcome, \(features.username)", x: menuX + 20, y: menuY + 20, 
                color: primaryColor, size: 16, renderEncoder: renderEncoder)
        drawText("[Offline]", x: menuX + 350, y: menuY + 20, 
                color: warningColor, size: 12, renderEncoder: renderEncoder)

        // Tabs
        let tabs = ["ESP", "Aimbot", "Player", "Vehicle", "Misc"]
        for (index, tab) in tabs.enumerated() {
            let tabX = menuX + 20 + CGFloat(index) * 95
            let tabColor = selectedTab == index ? primaryColor : SIMD4<Float>(0.15, 0.15, 0.2, 1.0)
            let tabRect = CGRect(x: tabX, y: menuY + 50, width: 85, height: 35)
            drawRoundedRect(rect: tabRect, color: tabColor, 
                           renderEncoder: renderEncoder, cornerRadius: 6)
            drawText(tab, x: tabX + 25, y: menuY + 60, 
                    color: SIMD4<Float>(1, 1, 1, 1), size: 12, renderEncoder: renderEncoder)
        }

        // Content area
        drawContentForTab(tabIndex: selectedTab, menuX: menuX, menuY: menuY + 100, 
                         renderEncoder: renderEncoder)
    }

    private func drawContentForTab(tabIndex: Int, menuX: CGFloat, menuY: CGFloat, 
                                   renderEncoder: MTLRenderCommandEncoder) {
        switch tabIndex {
        case 0: // ESP
            drawToggle("Enable ESP", isOn: features.espEnabled, x: menuX + 20, y: menuY, 
                      renderEncoder: renderEncoder)
            if features.espEnabled {
                drawToggle("Box ESP", isOn: features.espBox, x: menuX + 40, y: menuY + 30, 
                          renderEncoder: renderEncoder)
                drawToggle("Skeleton ESP", isOn: features.espSkeleton, x: menuX + 40, y: menuY + 55, 
                          renderEncoder: renderEncoder)
                drawToggle("Name ESP", isOn: features.espName, x: menuX + 40, y: menuY + 80, 
                          renderEncoder: renderEncoder)
                drawToggle("Health Bar", isOn: features.espHealth, x: menuX + 40, y: menuY + 105, 
                          renderEncoder: renderEncoder)
                drawToggle("Snap Lines", isOn: features.espLines, x: menuX + 40, y: menuY + 130, 
                          renderEncoder: renderEncoder)
            }
        case 1: // Aimbot
            drawToggle("Enable Aimbot", isOn: features.aimbotEnabled, x: menuX + 20, y: menuY, 
                      renderEncoder: renderEncoder)
            if features.aimbotEnabled {
                drawToggle("Silent Aim", isOn: features.aimbotSilent, x: menuX + 40, y: menuY + 30, 
                          renderEncoder: renderEncoder)
                drawToggle("Show FOV", isOn: features.aimbotFOV, x: menuX + 40, y: menuY + 55, 
                          renderEncoder: renderEncoder)
                drawSlider("FOV Radius", value: features.aimbotFOVRadius, min: 50, max: 500, 
                          x: menuX + 20, y: menuY + 90, renderEncoder: renderEncoder)
                drawSlider("Smoothness", value: features.aimbotSmooth, min: 0, max: 1, 
                          x: menuX + 20, y: menuY + 120, renderEncoder: renderEncoder)
            }
            drawToggle("No Recoil", isOn: features.noRecoil, x: menuX + 20, y: menuY + 160, 
                      renderEncoder: renderEncoder)
            drawToggle("No Spread", isOn: features.noSpread, x: menuX + 20, y: menuY + 185, 
                      renderEncoder: renderEncoder)
            drawToggle("Rapid Fire", isOn: features.rapidFire, x: menuX + 20, y: menuY + 210, 
                      renderEncoder: renderEncoder)
        case 2: // Player
            drawToggle("God Mode", isOn: features.godMode, x: menuX + 20, y: menuY, 
                      renderEncoder: renderEncoder)
            drawToggle("Speed Hack", isOn: features.speedHack, x: menuX + 20, y: menuY + 30, 
                      renderEncoder: renderEncoder)
            if features.speedHack {
                drawSlider("Speed Multiplier", value: features.speedMultiplier, min: 1, max: 10, 
                          x: menuX + 40, y: menuY + 60, renderEncoder: renderEncoder)
            }
            drawToggle("Wall Hack", isOn: features.wallHack, x: menuX + 20, y: menuY + 100, 
                      renderEncoder: renderEncoder)
            drawToggle("Fly Mode", isOn: features.flyMode, x: menuX + 20, y: menuY + 130, 
                      renderEncoder: renderEncoder)
            drawToggle("XP Multiplier", isOn: features.xpMultiplier, x: menuX + 20, y: menuY + 170, 
                      renderEncoder: renderEncoder)
        case 3: // Vehicle
            drawToggle("Vehicle Speed", isOn: features.vehicleSpeed, x: menuX + 20, y: menuY, 
                      renderEncoder: renderEncoder)
            drawToggle("Vehicle God Mode", isOn: features.vehicleGodMode, x: menuX + 20, y: menuY + 30, 
                      renderEncoder: renderEncoder)
            drawToggle("Vehicle Fly", isOn: features.vehicleFly, x: menuX + 20, y: menuY + 55, 
                      renderEncoder: renderEncoder)
            drawToggle("Drift Mode", isOn: features.vehicleDriftMode, x: menuX + 20, y: menuY + 80, 
                      renderEncoder: renderEncoder)
        case 4: // Misc
            drawToggle("Anti Ban", isOn: features.antiBan, x: menuX + 20, y: menuY, 
                      renderEncoder: renderEncoder)
            drawToggle("Remove Ads", isOn: features.removeAds, x: menuX + 20, y: menuY + 30, 
                      renderEncoder: renderEncoder)
            drawToggle("Rainbow Mode", isOn: features.rainbowMode, x: menuX + 20, y: menuY + 60, 
                      renderEncoder: renderEncoder)
            drawSlider("Menu Opacity", value: features.menuAlpha, min: 0.5, max: 1.0, 
                      x: menuX + 20, y: menuY + 100, renderEncoder: renderEncoder)
        default:
            break
        }
    }

    private func drawWatermark(renderEncoder: MTLRenderCommandEncoder) {
        let rect = CGRect(x: 10, y: 10, width: 250, height: 50)
        drawRoundedRect(rect: rect, color: SIMD4<Float>(0.0, 0.0, 0.0, 0.5), 
                       renderEncoder: renderEncoder, cornerRadius: 6)
        drawText("OneState Mod Menu", x: 20, y: 18, 
                color: primaryColor, size: 14, renderEncoder: renderEncoder)
        drawText("v2.0 | Offline Mode", x: 20, y: 38, 
                color: SIMD4<Float>(0.5, 0.5, 0.5, 1.0), size: 10, renderEncoder: renderEncoder)
    }

    // MARK: - Helper Drawing Methods

    private func drawRoundedRect(rect: CGRect, color: SIMD4<Float>, 
                                renderEncoder: MTLRenderCommandEncoder, cornerRadius: CGFloat) {
        // Simplified - in real implementation use proper Metal rendering
        // This is a placeholder for the actual ImGui rendering
    }

    private func drawText(_ text: String, x: CGFloat, y: CGFloat, 
                         color: SIMD4<Float>, size: CGFloat, 
                         renderEncoder: MTLRenderCommandEncoder) {
        // Simplified - in real implementation use proper text rendering
        // This is a placeholder for the actual ImGui text rendering
    }

    private func drawToggle(_ label: String, isOn: Bool, x: CGFloat, y: CGFloat, 
                           renderEncoder: MTLRenderCommandEncoder) {
        let boxColor = isOn ? successColor : SIMD4<Float>(0.2, 0.2, 0.3, 1.0)
        let boxRect = CGRect(x: x, y: y, width: 20, height: 20)
        drawRoundedRect(rect: boxRect, color: boxColor, 
                       renderEncoder: renderEncoder, cornerRadius: 4)
        drawText(label, x: x + 30, y: y + 3, 
                color: SIMD4<Float>(1, 1, 1, 1), size: 14, renderEncoder: renderEncoder)
    }

    private func drawSlider(_ label: String, value: Float, min: Float, max: Float, 
                           x: CGFloat, y: CGFloat, renderEncoder: MTLRenderCommandEncoder) {
        drawText(label, x: x, y: y, 
                color: SIMD4<Float>(1, 1, 1, 1), size: 12, renderEncoder: renderEncoder)
        let sliderWidth: CGFloat = 200
        let progress = (value - min) / (max - min)
        let fillWidth = sliderWidth * CGFloat(progress)
        let bgRect = CGRect(x: x, y: y + 20, width: sliderWidth, height: 8)
        drawRoundedRect(rect: bgRect, color: SIMD4<Float>(0.2, 0.2, 0.3, 1.0), 
                       renderEncoder: renderEncoder, cornerRadius: 4)
        let fillRect = CGRect(x: x, y: y + 20, width: fillWidth, height: 8)
        drawRoundedRect(rect: fillRect, color: primaryColor, 
                       renderEncoder: renderEncoder, cornerRadius: 4)
    }
}
