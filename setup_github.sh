#!/bin/bash
# setup_github.sh
# Setup script for GitHub repository

echo "========================================="
echo "  OneState Mod - GitHub Setup"
echo "========================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed"
    exit 1
fi

# Initialize git repository
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
fi

# Add all files
echo "Adding files..."
git add .

# Initial commit
echo "Creating initial commit..."
git commit -m "Initial commit: OneState Mod Menu - No Jailbreak"

# Instructions
echo ""
echo "========================================="
echo "  Next Steps:"
echo "========================================="
echo ""
echo "1. Create a new repository on GitHub"
echo "   https://github.com/new"
echo ""
echo "2. Link your local repository:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/OneStateMod.git"
echo ""
echo "3. Push to GitHub:"
echo "   git push -u origin main"
echo ""
echo "4. Add GitHub Secrets (see GITHUB_SECRETS.md)"
echo ""
echo "5. GitHub Actions will automatically build the IPA!"
echo ""
