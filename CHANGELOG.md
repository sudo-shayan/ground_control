# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2026-04-25

### Fixed
- Fixed broken GIF preview paths in README for pub.dev compatibility.
- Resolved repository URL mismatch for pub.dev analysis.
- Aligned project metadata with the official GitHub repository link.

## [1.0.2] - 2026-04-25

### Fixed
- Fixed broken GIF preview paths in README for pub.dev compatibility.
- Renamed and organized preview assets for better package structure.

## [1.0.1] - 2026-04-25

### Fixed
- Updated deprecated `withOpacity` to `withValues` for improved performance and 100/100 Pana score support.
- Corrected repository and issue tracker links in `pubspec.yaml`.
- Optimized package size by excluding internal documentation and build artifacts.

## [1.0.0] - 2026-04-18

### Added
- Initial release of GroundControl.
- `GroundControlShell` widget for wrapping the entire application.
- Remote JSON configuration support.
- Maintenance Mode with blocking UI and estimated end time.
- Force Update logic with platform-specific store redirection.
- "What's New" changelog popup with local version persistence.
- No-internet detection with automatic/manual retry and countdown.
- Full theme customization via `GroundControlTheme`.
- Support for custom screen overrides.
- Background periodic re-checking and foreground resume detection.
- Config caching for robust offline performance.
- Interactive example app with "Mock Server Panel".
- Semantic version comparison utility.
