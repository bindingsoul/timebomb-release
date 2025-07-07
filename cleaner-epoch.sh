#!/bin/bash

# Run extra cleanup to remove orphaned tracker entries before deleting expired files
CLEAN_TRACKER_SCRIPT="$HOME/timebomb-release/clean-timebomb-tracker.sh"
if [ -x "$CLEAN_TRACKER_SCRIPT" ]; then
  "$CLEAN_TRACKER_SCRIPT"
fi

JSON_FILE="$HOME/.timebomb/tracker.json"
NOW=$(date +%s)

jq -c '.[]' "$JSON_FILE" 2>/dev/null | while read -r item; do
  path=$(echo "$item" | jq -r '.path')
  expiry_epoch=$(echo "$item" | jq -r '.delete_epoch')

  if [[ "$expiry_epoch" -lt "$NOW" && -e "$path" ]]; then
    echo "💣 Deleting: $path"
    rm -rf "$path"
  fi
done

# Remove expired entries from JSON
jq --argjson now "$NOW" '[.[] | select(.delete_epoch >= $now)]' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"

