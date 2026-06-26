# OneState Mod - Complete Setup Guide

## Quick Start (5 minutes)

### Option A: GitHub Actions (Recommended)

1. **Fork this repository** on GitHub
2. **Add your certificate secrets** (see GITHUB_SECRETS.md)
3. **Push any change** to trigger the build
4. **Download IPA** from GitHub Releases

### Option B: Local Build

```bash
# 1. Clone repository
git clone https://github.com/yourusername/OneStateMod.git
cd OneStateMod

# 2. Generate Xcode project
./generate_xcode_project.sh

# 3. Open in Xcode and build
open OneStateMod.xcodeproj

# 4. Or use command line
./build.sh
```

## Installation Methods

### 1. TrollStore (Best - Permanent)
- **Requirements**: iOS 14.0 - 17.0
- **Pros**: No re-signing needed, permanent installation
- **Cons**: Requires specific iOS version

**Steps**:
1. Install TrollStore from [https://github.com/opa334/TrollStore](https://github.com/opa334/TrollStore)
2. Transfer IPA to device
3. Open with TrollStore
4. Done!

### 2. AltStore (Free - 7 days)
- **Requirements**: Computer with AltServer
- **Pros**: Free, easy to use
- **Cons**: Must refresh every 7 days

**Steps**:
1. Install AltServer on your computer
2. Connect iPhone via USB
3. Install AltStore on iPhone
4. Open AltStore, add the IPA
5. Enter Apple ID
6. Done!

### 3. Sideloadly (Free - 7 days)
- **Requirements**: Computer with iTunes
- **Pros**: Free, works on Windows/Mac
- **Cons**: Must refresh every 7 days

**Steps**:
1. Download Sideloadly from [https://sideloadly.io](https://sideloadly.io)
2. Connect iPhone via USB
3. Drag IPA to Sideloadly
4. Enter Apple ID
5. Click Start
6. Done!

### 4. Apple Developer (Paid - 1 year)
- **Requirements**: $99/year Apple Developer account
- **Pros**: 1 year validity, App Store distribution
- **Cons**: Costs money

**Steps**:
1. Enroll in Apple Developer Program
2. Create certificates and provisioning profiles
3. Sign IPA with your certificate
4. Install via Xcode or TestFlight

## Troubleshooting

### "Unable to install" error
- Make sure iOS version is compatible
- Try different installation method
- Check if certificate is valid

### App crashes on launch
- Rebuild with latest Xcode
- Check iOS version compatibility
- Try debug build instead of release

### Menu not showing
- Triple-tap anywhere on screen
- Check if Metal is supported on your device
- Try rebuilding the project

### Features not working
- This is a template - add game-specific offsets
- Use Frida or IDA Pro to find memory addresses
- Modify `FeatureHooks.swift` with actual offsets

## File Structure

```
OneStateMod/
├── OneStateMod/
│   ├── AppDelegate.swift          # App entry point
│   ├── SceneDelegate.swift         # Scene management
│   ├── GameViewController.swift    # Main view controller
│   ├── ImGuiRenderer.swift       # ImGui UI rendering
│   ├── Info.plist                 # App configuration
│   └── Resources/                 # Assets
├── .github/
│   └── workflows/
│       └── build-ipa.yml          # GitHub Actions CI/CD
├── build.sh                        # Local build script
├── generate_xcode_project.sh     # Xcode project generator
├── setup_github.sh               # GitHub setup script
├── ExportOptions.plist           # IPA export settings
├── GITHUB_SECRETS.md             # Secrets setup guide
├── README.md                      # Main documentation
└── LICENSE                        # MIT License
```

## Customization

### Change App Name
Edit `OneStateMod/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

### Change Bundle ID
Edit `OneStateMod/Info.plist` and `ExportOptions.plist`:
```xml
<key>CFBundleIdentifier</key>
<string>com.yourname.yourapp</string>
```

### Change Colors
Edit `OneStateMod/ImGuiRenderer.swift`:
```swift
private var primaryColor = SIMD4<Float>(0.0, 0.6, 1.0, 1.0)    // Blue
private var secondaryColor = SIMD4<Float>(1.0, 0.2, 0.2, 1.0) // Red
```

### Add Features
1. Add toggle in `ImGuiRenderer.swift`
2. Implement hook in `FeatureHooks.swift`
3. Add memory reading in `MemoryUtils.swift`

## Support

- GitHub Issues: [Report a bug](https://github.com/yourusername/OneStateMod/issues)
- Discord: [Join server](https://discord.gg/yourserver)

## License

MIT License - See LICENSE file for details.
