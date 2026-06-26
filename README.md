# OneState Mod Menu - iOS (No Jailbreak)

## Features

### ESP (Extra Sensory Perception)
- Box ESP
- Skeleton ESP
- Name ESP
- Distance ESP
- Health Bar
- Team ESP
- Snap Lines

### Aimbot
- Silent Aim
- Lock Target
- Customizable FOV
- Smooth Aim
- Bone Selection (Head, Neck, Body, Legs)
- No Recoil
- No Spread
- Rapid Fire
- Infinite Ammo

### Player Mods
- God Mode
- Speed Hack (adjustable multiplier)
- Wall Hack
- Fly Mode
- No Clip
- Teleport
- XP Multiplier
- Free Shopping
- Unlock All Items

### Vehicle Mods
- Speed Hack
- God Mode
- Vehicle Fly
- Instant Stop
- Drift Mode

### Misc
- Anti Ban
- Remove Ads
- Customizable Menu
- Watermark
- Rainbow Mode
- Local Login (Offline Mode)

## Requirements

- iOS 14.0+
- No Jailbreak Required!
- One of the following installation methods:
  - **Apple Developer Certificate** (paid or free)
  - **TrollStore** (iOS 14.0 - 17.0)
  - **AltStore** (free, 7-day refresh)
  - **Sideloadly** (free, 7-day refresh)

## Installation Methods

### Method 1: GitHub Actions (Automatic Build)

1. **Fork this repository** to your GitHub account
2. **Add secrets** (see GITHUB_SECRETS.md)
3. **Push to main branch** → GitHub Actions will build automatically
4. **Download IPA** from Releases or Artifacts

### Method 2: Local Build with Certificate

```bash
# Clone repository
git clone https://github.com/yourusername/OneStateMod.git
cd OneStateMod

# Update bundle ID in Info.plist and ExportOptions.plist
# Add your Team ID to ExportOptions.plist

# Build
./build.sh
```

### Method 3: TrollStore (No Certificate)

```bash
# Build unsigned IPA
./build.sh

# Install with TrollStore
# Transfer build/OneStateMod-unsigned.ipa to your device
# Open with TrollStore
```

### Method 4: AltStore / Sideloadly

1. Build unsigned IPA with `./build.sh`
2. Install AltStore or Sideloadly on your computer
3. Connect iPhone via USB
4. Drag and drop the IPA file
5. Enter your Apple ID (free developer account works)

## Login System

This mod uses **local login** without any API server:

- **Default credentials**: `admin` / `123456`
- **Offline Mode**: Click "Skip Login" to bypass login entirely
- **Change credentials**: Edit `ImGuiRenderer.swift`:
  ```swift
  let validUser = "admin"
  let validPass = "123456"
  ```

## How to Use

1. **Open the app** - You'll see the login screen
2. **Login** with `admin` / `123456` or click "Skip Login"
3. **Triple tap** anywhere on screen to toggle the menu
4. **Select tabs** to enable/disable features
5. **Enjoy!**

## Project Structure

```
OneStateMod/
├── .github/
│   └── workflows/
│       └── build-ipa.yml      # GitHub Actions CI/CD
├── OneStateMod/
│   ├── AppDelegate.swift      # App entry point
│   ├── SceneDelegate.swift    # Scene management
│   ├── GameViewController.swift # Main game view
│   ├── ImGuiRenderer.swift    # ImGui UI rendering
│   └── Info.plist             # App configuration
├── ExportOptions.plist        # IPA export settings
├── build.sh                   # Local build script
├── GITHUB_SECRETS.md          # Secrets setup guide
└── README.md                  # This file
```

## Customization

### Change Colors
Edit `ImGuiRenderer.swift`:
```swift
private var primaryColor = SIMD4<Float>(0.0, 0.6, 1.0, 1.0)    // Blue
private var secondaryColor = SIMD4<Float>(1.0, 0.2, 0.2, 1.0) // Red
```

### Change Bundle ID
Edit `OneStateMod/Info.plist` and `ExportOptions.plist`:
```xml
<key>CFBundleIdentifier</key>
<string>com.yourname.onestatemod</string>
```

### Add New Features
1. Add toggle in `ImGuiRenderer.swift` tab renderer
2. Implement game-specific hooks in `FeatureHooks.swift`

## Troubleshooting

### Build Failed: "No signing certificate"
- Use `./build.sh` for unsigned build
- Or add certificate secrets to GitHub

### App Crashes on Launch
- Check iOS version compatibility (requires iOS 14.0+)
- Try rebuilding with latest Xcode

### Menu Not Showing
- Make sure you're triple-tapping the screen
- Check if `menuOpen` is set to `true` in `ImGuiRenderer.swift`

### Features Not Working
- This is a template - you need to add game-specific memory offsets
- Use tools like Frida, IDA Pro, or Ghidra to find offsets

## License

MIT License - For educational purposes only.

## Disclaimer

This tool is for educational and research purposes only. Using cheats in online games may result in bans. Use at your own risk.

## Credits

- ImGui by Omar Cornut
- OneState game by CarX Technologies
