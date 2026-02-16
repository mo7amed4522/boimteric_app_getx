import Flutter
import UIKit
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let locationChannel = "com.example.boimteric_app_getx/location"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Setup method channel for location services
        setupLocationMethodChannel()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func setupLocationMethodChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }

        let channel = FlutterMethodChannel(
            name: locationChannel,
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "checkMockLocation":
                let mockCheck = self?.checkMockLocation() ?? [:]
                result(mockCheck)
            case "detectMockApps":
                // On iOS, we can't detect specific apps due to sandboxing
                // But we can check for jailbreak indicators
                let mockApps = self?.detectMockIndicators() ?? [:]
                result(mockApps)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    /**
     * iOS mock location detection
     * Note: iOS is more restrictive, so detection methods are limited
     */
    private func checkMockLocation() -> [String: Any] {
        var details: [String: Any] = [:]
        var isMock = false

        // Method 1: Check if device is jailbroken
        let isJailbroken = checkJailbreak()
        details["isJailbroken"] = isJailbroken

        // Method 2: Check for suspicious apps (limited on iOS)
        let suspiciousApps = checkSuspiciousApps()
        details["suspiciousAppsDetected"] = suspiciousApps

        // Method 3: Check for simulator
        #if targetEnvironment(simulator)
        details["isSimulator"] = true
        isMock = true
        #else
        details["isSimulator"] = false
        #endif

        // iOS doesn't have mock location settings like Android
        // But jailbreak + location spoofing apps is a red flag
        isMock = isJailbroken && suspiciousApps

        return [
            "isMock": isMock,
            "details": details,
            "platform": "iOS",
            "osVersion": UIDevice.current.systemVersion
        ]
    }

    /**
     * Detect mock indicators on iOS
     */
    private func detectMockIndicators() -> [String: Any] {
        var detected = false
        var apps: [String] = []

        // Check for jailbreak
        if checkJailbreak() {
            detected = true
            apps.append("Jailbreak detected - potential for mock location apps")
        }

        return [
            "detected": detected,
            "count": apps.count,
            "apps": apps
        ]
    }

    /**
     * Check if device is jailbroken
     */
    private func checkJailbreak() -> Bool {
        // Check for common jailbreak indicators

        // 1. Check for Cydia app
        if UIApplication.shared.canOpenURL(URL(string: "cydia://")!) {
            return true
        }

        // 2. Check for suspicious file paths
        let suspiciousPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]

        for path in suspiciousPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        // 3. Check if we can write to restricted directories
        let testPath = "/private/jailbreak_test.txt"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            // Expected behavior on non-jailbroken devices
        }

        return false
    }

    /**
     * Check for suspicious apps (limited capability on iOS)
     */
    private func checkSuspiciousApps() -> Bool {
        // On iOS, we can't enumerate installed apps due to sandboxing
        // This is a placeholder for any heuristic checks we might add
        return false
    }
}
