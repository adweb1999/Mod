# GitHub Secrets Setup Guide

To enable automatic signing and building of the IPA, you need to add the following secrets to your GitHub repository:

## 1. SIGNING_CERTIFICATE_BASE64

Convert your `.p12` certificate to base64:
```bash
base64 -i your_certificate.p12 -o cert_base64.txt
cat cert_base64.txt
```

Copy the output and add it as a secret named `SIGNING_CERTIFICATE_BASE64`.

## 2. CERTIFICATE_PASSWORD

The password for your `.p12` certificate.

## 3. PROVISIONING_PROFILE_BASE64

Convert your `.mobileprovision` file to base64:
```bash
base64 -i your_profile.mobileprovision -o profile_base64.txt
cat profile_base64.txt
```

Copy the output and add it as a secret named `PROVISIONING_PROFILE_BASE64`.

## How to Get These Files

### Option 1: Apple Developer Account (Paid - $99/year)
1. Go to [Apple Developer Portal](https://developer.apple.com/)
2. Create an App ID: `com.yourname.onestatemod`
3. Create a Distribution Certificate
4. Create a Provisioning Profile (Ad Hoc or App Store)
5. Download and convert to base64

### Option 2: Free Developer Account
1. Use Xcode to create a free developer certificate
2. Build and run on your device
3. Extract the certificate and profile from Keychain

### Option 3: No Certificate (TrollStore)
If you don't have a certificate, the build will fallback to `ldid` signing.
You can install the unsigned IPA using:
- **TrollStore** (requires iOS 14.0 - 17.0)
- **AltStore** (free, requires refresh every 7 days)
- **Sideloadly** (free, requires refresh every 7 days)

## Setting Up Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret one by one

## Alternative: Manual Build Without Certificate

If you don't want to use GitHub Actions with certificates, you can:

1. Build locally with `build.sh`
2. Use `ldid` for fake-signing
3. Install with TrollStore

```bash
./build.sh
# Then install build/OneStateMod-unsigned.ipa with TrollStore
```
