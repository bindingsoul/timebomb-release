#!/bin/zsh

# === Setup Paths ===
WORKFLOW_DIR="$(pwd)/workflows"
SERVICE_DIR="$HOME/Library/Services"
INSTALL_DIR="$HOME/.timebomb"

echo ""
echo "🧨 Timebomb Installer"
echo "-----------------------------"

# === Step 1: Install Automator Workflows ===
echo "📁 Installing Quick Actions to Finder..."
mkdir -p "$SERVICE_DIR"
cp -R "$WORKFLOW_DIR"/*.workflow "$SERVICE_DIR/"

echo "✅ Quick Actions copied to: $SERVICE_DIR"

# === Step 2: Setup cleaner-epoch.sh ===
echo "🧹 Setting up cleaner script..."
mkdir -p "$INSTALL_DIR"
cp cleaner-epoch.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/cleaner-epoch.sh"

echo "✅ Cleaner script installed to: $INSTALL_DIR/cleaner-epoch.sh"

# === Step 3: Check for 'jq' dependency ===
if ! command -v jq &> /dev/null; then
  echo "⚠️  'jq' not found. Please install it using:"
  echo "    brew install jq"
else
  echo "✅ 'jq' is installed"
fi

# === Done ===
echo ""
echo "🎉 Timebomb setup complete!"
echo "📂 Right-click any file or folder in Finder and choose:"
echo "   • Delete in 3 min"
echo "   • Delete in 1 Day"
echo "   • Delete in 7 Days"
echo "   • Delete in 1 Month"
echo "   ...and more!"
echo ""
echo "🧽 To clean expired files manually, run:"
echo "   $INSTALL_DIR/cleaner-epoch.sh"
echo ""
echo "🕘 You can also automate it with a launch agent (optional)."
echo "⚠️  Restart Finder if Quick Actions don’t show immediately."

