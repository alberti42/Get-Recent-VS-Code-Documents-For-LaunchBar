# Changelog

All notable changes to the Get Recent VS Code Documents action are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- macOS reported that Apple could not verify the action when it was opened from a browser download. The action is now signed with a Developer ID and notarized by Apple. The bundle contains a small executable, `Contents/MacOS/RecentVSCodeDocuments`, that LaunchBar does not run; it carries the signature, which seals `default.py`.

## [1.0.0] - 2026-11-03

### Fixed

- LaunchBar described the action as a list of Sublime Text files; it now names Visual Studio Code.

### Changed

- The action's bundle identifier is now `Alberti42.LaunchBar.action.RecentVSCodeDocuments` (was `org.alberti42.LaunchBar-Action.RecentVSCode`), following the pattern `Alberti42.LaunchBar.action.Recent*` of the other actions. LaunchBar treats it as a new action: delete the old `Recent VS Code Opened Files` action after installing this one.
- `Get-Recent-VS-Code-Documents-For-LaunchBar.zip` is attached to each GitHub release, with a build provenance attestation, instead of being kept in the repository.

### Removed

- `open_with_sublime.py`, which the action never ran, and the compiled `__pycache__` folder.

[Unreleased]: https://github.com/alberti42/Get-Recent-VS-Code-Documents-For-LaunchBar/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/alberti42/Get-Recent-VS-Code-Documents-For-LaunchBar/releases/tag/v1.0.0
