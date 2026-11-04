#!/usr/bin/env sh
# Exam Tracker - macOS and Linux Launcher
cd "$(dirname "$0")"

if ! command -v node >/dev/null 2>&1; then
    echo "Node.js is required on macOS/Linux. Please install it from https://nodejs.org or run index.html directly in your browser."
    (xdg-open index.html 2>/dev/null || open index.html 2>/dev/null) &
    exit 1
fi

(sleep 1 && (xdg-open http://localhost:3000 2>/dev/null || open http://localhost:3000 2>/dev/null)) &
node server.js
