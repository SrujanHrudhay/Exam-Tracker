# 🎓 Exam Tracker

[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue.svg)](#quick-start-for-users-non-tech-friendly)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Zero%20Install-brightgreen.svg)](#features)
[![Privacy](https://img.shields.io/badge/Privacy-100%25%20Offline%20%26%20Local-orange.svg)](#privacy--data-storage)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

An elegant, distraction-free visual timeline and calendar tracker for competitive exams, academic schedules, and application deadlines. Track important dates, visualize exam windows on an interactive timeline, and never miss an application deadline again.

Designed to be **100% offline**, **private**, and **usable by anyone** without needing technical knowledge or complicated installations.

---

## 🌟 Key Features

- **📊 Visual Timeline (Gantt Chart)**: Clear, interactive visual bars showing exam durations, multi-shift dates, and application windows.
- **🎯 Exams & Applications Tracking**: Separate or combined views for exam dates and application deadlines.
- **🏷️ Category Filtering**: Color-coded badges for Banking, Railways, SSC, Regulatory, and Other exams.
- **⏰ Tentative Date Highlighting**: Mark tentative dates (from official notifications) with dashed outlines so you always know what is confirmed vs tentative.
- **🌓 Light & Dark Modes**: Clean minimalist design with automatic system theme detection and manual toggle.
- **💾 Auto-Save to File (`data.json`)**: Changes are saved locally and persistently.
- **🔄 Import & Export**: One-click JSON export to backup your schedule or transfer it to another computer.
- **🪟 Native Desktop Experience**: Runs in a frameless, clean standalone window on Windows with a custom taskbar icon.
- **⚡ Zero Setup Required**: Built-in fallback server for Windows users without Node.js. Download, click, and use.

---

## 🚀 Quick Start for Users (Non-Tech Friendly)

You do **not** need to be a programmer or know how to use the command prompt. Everything is automated.

### Method 1: The One-Click Windows Setup (Recommended)

1. Download this repository as a `.zip` (click the green **Code** button at the top of this page, then **Download ZIP**), or grab the latest release from the [Releases](https://github.com/srujanhrudhay/exam-tracker/releases) tab.
2. Extract the downloaded ZIP file to any folder on your computer (e.g., Documents or Desktop).
3. Open the folder and double-click **`Setup.bat`** (or **`Exam Tracker.vbs`**).
4. **That's it!**
   - An **Exam Tracker** shortcut will automatically appear on your Windows Desktop with the official icon.
   - A shortcut will also be added to your Windows Start Menu.
   - The application will launch in its own clean window.

---

### Method 2: Instant Browser Mode (Zero Installation)

If you don't want to run any background scripts or servers:
- Simply double-click **`index.html`** in your browser.
- It runs completely offline inside your browser and saves data safely in your browser storage (`localStorage`).
- You can export your data at any time using the download icon in the top right.

---

### Method 3: 1-Line PowerShell Web Install (Windows)

For an instant, fully automatic setup directly from PowerShell:

```powershell
irm https://raw.githubusercontent.com/srujanhrudhay/exam-tracker/main/install.ps1 | iex
```

This installs Exam Tracker to `%LOCALAPPDATA%\Programs\ExamTracker`, adds the Desktop shortcut, and opens the app immediately.

---

## 🖥️ How It Works (Under the Hood)

Exam Tracker is engineered for maximum reliability with multi-tier automatic fallbacks:

```
                      ┌──────────────────────────────────────┐
                      │    Double-Click Exam Tracker.vbs     │
                      └──────────────────┬───────────────────┘
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 ▼                                               ▼
         [Node.js Detected?]                           [Node.js Not Found]
                 │                                               │
                 ▼                                               ▼
       Runs `server.js` silently                     Runs `server.ps1` silently
  (Zero-dependency HTTP server)                 (Windows built-in .NET HttpListener)
                 │                                               │
                 └───────────────────────┬───────────────────────┘
                                         ▼
                     Launches Standalone Window Mode
                 (Edge / Chrome --app=http://localhost:3000)
                                         │
                                         ▼
                     Auto-detects window closure (/api/bye)
                          and shuts down cleanly
```

1. **Silent Background Execution**: `Exam Tracker.vbs` runs invisibly without displaying an annoying black console window.
2. **Dual-Engine Server**:
   - If **Node.js** is installed on your computer, it runs `server.js`.
   - If **Node.js is NOT installed**, it automatically falls back to `server.ps1` using the built-in Windows .NET HTTP server. No external software or admin rights required!
3. **Clean Cache Isolation**: Browser cache is isolated in `%LOCALAPPDATA%\ExamTracker\profile`, keeping the project directory clean and lightweight (under 500 KB).
4. **Auto-Shutdown**: When you close the app window, the server automatically shuts down after 4 seconds so it never consumes background system memory.

---

## 💻 Developer & Power User Guide

If you are a developer and prefer running from the command line:

### Windows (Node.js)
```cmd
start.bat
# or
node server.js
```
Then open [http://localhost:3000](http://localhost:3000) in your browser.

### Windows (PowerShell Server - No Node Required)
```powershell
powershell -ExecutionPolicy Bypass -File server.ps1
```

### macOS / Linux
```bash
chmod +x start.sh
./start.sh
```

---

## 📁 Repository Structure

```text
exam-tracker/
├── index.html                   # Core interactive web application UI
├── viewer.html                  # Lightweight read-only table viewer for data.json
├── server.js                    # Zero-dependency Node.js local REST server
├── server.ps1                   # Zero-dependency Windows PowerShell local REST server
├── Exam Tracker.vbs             # Silent Windows launcher (auto-creates desktop shortcut)
├── Setup.bat                    # One-click Windows desktop shortcut & start menu installer
├── start.bat                    # Traditional Windows batch launcher
├── start.sh                     # macOS & Linux launcher
├── push-to-github.bat           # Helper script to link and push to your GitHub repo
├── install.ps1                  # 1-line automated PowerShell installer
├── data.json                    # Local database storing all exams and application dates
├── exam-tracker.ico             # High-resolution application icon
├── lib/                         # Fully self-contained offline dependencies
│   ├── chart.umd.js             # Chart.js library (bundled locally)
│   ├── chartjs-adapter-date-fns.bundle.min.js
│   └── fonts/                   # Inter and Source Serif 4 webfonts
├── .gitignore                   # Ignores runtime caches and temp files
├── LICENSE                      # MIT License
└── README.md                    # Project documentation
```

---

## 📡 REST API Reference

When the local server is running, it exposes a lightweight local HTTP API on `http://127.0.0.1:3000`:

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/data` | Returns all records from `data.json` as JSON |
| `PUT` / `POST` | `/api/data` | Atomically saves updated exam/application entries |
| `GET` | `/api/ping` | Keeps server alive while window is open |
| `GET` | `/api/bye` | Signals server that the window closed for clean exit |

---

## 🔒 Privacy & Data Storage

- **100% Local**: All your data lives strictly on your computer inside `data.json`.
- **No Analytics / Telemetry**: No tracking, no external third-party scripts, and no remote server calls.
- **Portable**: You can copy `data.json` to any flash drive or backup folder, or use the in-app **Export (JSON)** button.

---

## ❓ Frequently Asked Questions (FAQ)

<details>
<summary><b>1. Will this work if I don't have Node.js installed?</b></summary>
Yes! On Windows, Exam Tracker automatically uses the built-in PowerShell server fallback (<code>server.ps1</code>), which runs out of the box on Windows 10 and 11 without installing anything.
</details>

<details>
<summary><b>2. Why didn't a black command prompt window pop up?</b></summary>
The launcher (<code>Exam Tracker.vbs</code>) is designed to run silently in the background so that it looks and behaves like a polished desktop application.
</details>

<details>
<summary><b>3. How do I stop the background server?</b></summary>
Simply close the Exam Tracker window! The app immediately notifies the server to gracefully exit within 4 seconds.
</details>

<details>
<summary><b>4. How do I move my tracked exams to a new computer?</b></summary>
Click the <b>Export</b> icon (arrow pointing down) in the top-right toolbar of the app to download your <code>exam-tracker.json</code> file. On your new computer, open Exam Tracker and click <b>Import</b> (arrow pointing up) to restore your schedule.
</details>

---

## 📄 License

This project is open-source and released under the [MIT License](LICENSE). Feel free to use, modify, and distribute it freely!
