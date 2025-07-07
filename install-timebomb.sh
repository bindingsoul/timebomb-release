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
rm -rf "$HOME/Library/Services/dlt-*.workflow"
cp -R "$WORKFLOW_DIR"/*.workflow "$SERVICE_DIR/"
echo "✅ Quick Actions copied to: $SERVICE_DIR"

# === Step 2: Setup cleaner-epoch.sh ===
echo "🧹 Setting up cleaner script..."
mkdir -p "$INSTALL_DIR"
cp cleaner-epoch.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/cleaner-epoch.sh"
echo "✅ Cleaner script installed to: $INSTALL_DIR/cleaner-epoch.sh"

# === Step 2.5: Install GUI App (optional) ===
APP_ZIP="timebomb-release.app.zip"   # Change this to your app zip file name
APP_DEST="$HOME/Applications"
APP_NAME="timebomb-release.app"

if [[ -f "$APP_ZIP" ]]; then
  echo "📦 Found $APP_ZIP, extracting..."
  mkdir -p "$APP_DEST"
  unzip -o "$APP_ZIP" -d "$APP_DEST" >/dev/null
  if [[ -d "$APP_DEST/$APP_NAME" ]]; then
    echo "✅ Installed GUI app to: $APP_DEST/$APP_NAME"
    open "$APP_DEST/$APP_NAME"
    osascript -e 'display dialog "✅ Timebomb app installed!\nYou can drag it to your Dock from Applications folder 🚀" buttons {"OK"} with title "Installation Complete"'
  else
    echo "❌ Extraction failed. App not found in: $APP_DEST"
  fi
else
  echo "ℹ️  Skipping app install — $APP_ZIP not found in this directory."
fi

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
