#!/bin/bash
set -e

echo "========================================="
echo "  OneState Mod - Build Script"
echo "  (No Jailbreak - IPA)"
echo "========================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This script is designed for macOS"
    echo "For Windows/Linux, use GitHub Actions instead"
    exit 1
fi

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: Xcode is not installed"
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
if ! command -v ldid &> /dev/null; then
    brew install ldid
fi

# Build settings
SCHEME="OneStateMod"
CONFIGURATION="Release"
ARCHIVE_PATH="build/OneStateMod.xcarchive"
EXPORT_PATH="build/IPA"

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf build/
mkdir -p build

# Build archive
echo "Building archive..."
xcodebuild -scheme "$SCHEME"     -destination 'generic/platform=iOS'     -archivePath "$ARCHIVE_PATH"     -configuration "$CONFIGURATION"     archive

# Check if certificate is available
if security find-identity -v -p codesigning | grep -q "iPhone"; then
    echo "Certificate found, exporting signed IPA..."

    # Export IPA with certificate
    xcodebuild -exportArchive         -archivePath "$ARCHIVE_PATH"         -exportPath "$EXPORT_PATH"         -exportOptionsPlist ExportOptions.plist

    echo ""
    echo "✅ Signed IPA created at: $EXPORT_PATH/"
else
    echo "No certificate found, using ldid for fake-signing..."

    # Create Payload directory
    mkdir -p Payload
    cp -R "$ARCHIVE_PATH/Products/Applications/OneStateMod.app" Payload/

    # Sign with ldid (for TrollStore or similar)
    ldid -S Payload/OneStateMod.app/OneStateMod

    # Create IPA
    zip -r build/OneStateMod-unsigned.ipa Payload
    rm -rf Payload

    echo ""
    echo "⚠️  Unsigned IPA created at: build/OneStateMod-unsigned.ipa"
    echo "Install with: TrollStore, AltStore, or Sideloadly"
fi

echo ""
echo "========================================="
echo "  Build Complete!"
echo "========================================="
