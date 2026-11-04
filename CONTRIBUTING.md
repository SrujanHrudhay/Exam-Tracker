# Contributing to Exam Tracker

Thank you for considering a contribution. Improvements to reliability, usability, accessibility, documentation, and platform compatibility are welcome.

## Before you start

- For a significant change, open an issue first so the proposed approach can be discussed.
- For bugs, use the **Bug report** issue form and include clear reproduction steps.
- Keep pull requests focused and reasonably small.
- Avoid adding runtime dependencies unless necessary. The project is designed to keep setup simple and support offline use.
- Never commit personal examination schedules, exported user data, credentials, access tokens, or machine-specific files.

## Development setup

1. Fork the repository on GitHub.
2. Clone your fork:

   ```bash
   git clone https://github.com/<your-username>/Exam-Tracker.git
   cd Exam-Tracker
   ```

3. Create a branch:

   ```bash
   git checkout -b feat/short-description
   ```

4. Run the application using the mode relevant to your change:
   - Browser Mode: open `index.html` in a browser.
   - Windows with Node.js: run `node server.js` or `start.bat`.
   - Windows PowerShell server: run `powershell -ExecutionPolicy Bypass -File server.ps1`.
   - macOS/Linux: run `./start.sh` with Node.js installed.

## Making changes

- Preserve the lightweight, offline-first design.
- Keep Browser Mode and Desktop Mode data behavior clear.
- Avoid changing the stored JSON format without documenting compatibility and migration implications.
- Keep platform-specific behavior isolated where practical.
- Update `README.md` when installation, features, supported platforms, project structure, or API behavior changes.
- Add user-visible changes to `CHANGELOG.md` under **Unreleased**.
- Document any new external network calls, analytics, telemetry, or third-party services and explain their privacy implications.

## Manual verification

There is no automated test suite documented yet. Before opening a pull request, manually test the functionality affected by your change.

Where relevant, verify:

- The application opens and the main interface renders.
- Examination records can be added, edited, and deleted.
- Data remains available after closing and reopening the application.
- JSON import and export work with disposable test data.
- Timeline and category filters behave as expected.
- Light and dark themes remain usable.
- The local server starts, saves data, and shuts down cleanly.
- The relevant launcher or installer works on the operating system you tested.

Do not use real personal schedules as test fixtures in commits, screenshots, or issue reports.

## Commit and pull request

1. Review your changes:

   ```bash
   git status
   git diff
   ```

2. Commit with a descriptive message:

   ```bash
   git add <files-you-changed>
   git commit -m "Describe the change"
   ```

3. Push your branch and open a pull request against `main`.
4. Complete the pull request template, explaining the problem, your solution, and the checks performed.
5. Link any related issue. Include screenshots for interface changes when useful, after removing private information.

By submitting a contribution, you confirm that you have the right to contribute the submitted work and agree that it may be distributed under the repository's MIT License.
