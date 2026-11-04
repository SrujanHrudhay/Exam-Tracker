# Exam Tracker — Release Checklist

Use this checklist before publishing a GitHub Release. A checklist does not mean a release has been published.

## 1. Prepare the release

- [ ] Choose the release version using Semantic Versioning (for example, v0.1.0 for an initial preview).
- [ ] Review README.md and verify download links, installation commands, filenames, and platform claims.
- [ ] Move completed entries from CHANGELOG.md → Unreleased into a dated version section.
- [ ] Inspect data.json and confirm it contains only intentional sample/default data, not personal information.
- [ ] Test Browser Mode by opening index.html.
- [ ] On Windows, test the relevant launch paths: Setup.bat, Exam Tracker.vbs, server.ps1, and server.js where applicable.
- [ ] Test import and export with disposable sample data.
- [ ] Verify the application starts, saves changes, and exits cleanly.
- [ ] Confirm the MIT LICENSE file is present.

## 2. Prepare a Windows ZIP

- [ ] Create a clean release folder from the exact commit being released.
- [ ] Include the application HTML, local lib assets, server and launcher scripts, icon, license, and instructions needed by the documented setup.
- [ ] Exclude .git, temporary logs, caches, development-only files, credentials, and personal data.
- [ ] Confirm Setup.bat and Exam Tracker.vbs are included.
- [ ] Compress the folder into a clearly named asset, for example Exam-Tracker-v0.1.0-Windows.zip.
- [ ] Extract the ZIP into a fresh folder and test the extracted copy before uploading.

## 3. Publish on GitHub

1. Push the reviewed release commit to main.
2. Open the repository's Releases page and select **Draft a new release**.
3. Create a tag matching the selected version and target the reviewed commit.
4. Add a clear release title, such as **Exam Tracker v0.1.0**.
5. Add the reviewed release notes and known limitations.
6. Upload the tested Windows ZIP asset.
7. Review the tag, target commit, notes, and uploaded file before publishing.

GitHub provides source-code archives for tags. The separately attached Windows ZIP should be the tested, ready-to-extract package with the intended launcher files.
