NASA APOD Demo
A SwiftUI demo app that fetches NASA's Astronomy Picture of the Day (APOD).
It supports both images and videos, uses async/await networking, and demonstrates a clean MVVM architecture with testable ViewModels and local persistence.

This project is structured to show professional coding practices, including separation of concerns, unit testing, and secure handling of sensitive data.

Features
Fetch APOD for today or a specific date
Supports both image and video media types
Persistent storage of the last fetched APOD using FileStorageService
Clean MVVM architecture with ObservableObject ViewModels
Async/await networking with a repository pattern
Unit tests included for HomeViewModel and FileStorageService
Error handling and state management for robust UI updates
Architecture Highlights
Networking Layer: Handles API requests to NASA endpoints with clear separation of concerns
Storage Layer: Saves and loads the latest APOD locally for offline access
ViewModel Layer: Manages UI state (idle, loading, success, failure) in a testable way
SwiftUI Views: Reactive views updating automatically based on ViewModel state
Setup
Get a NASA API key: (https://api.nasa.gov)
Create Secrets.plist in the project root (ignored by Git):
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
    <key>NASA_API_KEY</key>
    <string>YOUR_API_KEY_HERE</string>
</dict>
</plist>
