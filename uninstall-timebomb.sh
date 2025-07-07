#!/bin/zsh

echo "🧨 Uninstalling Timebomb..."

# 1. Remove the ~/.timebomb directory
if [ -d "$HOME/.timebomb" ]; then
    echo "🧹 Removing ~/.timebomb"
    rm -rf "$HOME/.timebomb"
else
    echo "⚠️  ~/.timebomb not found. Skipping."
fi

# 2. Remove workflows from ~/Library/Services
WORKFLOWS=(
    "dlt-1-day.workflow"
    "dlt-7-day.workflow"
    "dlt-1-mnth.workflow"
    "dlt-6-mnth.workflow"
    "dlt-1-year.workflow"
    "dlt-3-min.workflow"
)

for wf in "${WORKFLOWS[@]}"; do
    TARGET="$HOME/Library/Services/$wf"
    if [ -e "$TARGET" ]; then
        echo "🗑 Removing $wf from Services"
        rm -rf "$TARGET"
    else
        echo "⚠️  $wf not found in Services. Skipping."
    fi
done

# Optional: remove cloned repo (only if user confirms)
read "?❓ Do you want to remove the cloned project directory too? (y/n): " yn
if [[ $yn =~ ^[Yy]$ ]]; then
    CURRENT_DIR="$(pwd)"
    echo "🗑 Deleting $CURRENT_DIR"
    rm -rf "$CURRENT_DIR"
fi

echo "✅ Timebomb uninstalled successfully."

