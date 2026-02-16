package com.example.boimteric_app_getx

import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.os.Build
import android.os.Looper
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.boimteric_app_getx/location"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkMockLocation" -> {
                    val mockCheck = checkMockLocation()
                    result.success(mockCheck)
                }
                "detectMockApps" -> {
                    val signatures = call.argument<List<String>>("signatures") ?: emptyList()
                    val mockApps = detectMockLocationApps(signatures)
                    result.success(mockApps)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * Comprehensive mock location detection for Android
     */
    private fun checkMockLocation(): Map<String, Any> {
        val details = mutableMapOf<String, Any>()
        var isMock = false

        try {
            // Method 1: Check if mock locations are enabled in developer settings
            val mockLocationEnabled = Settings.Secure.getInt(
                contentResolver,
                Settings.Secure.ALLOW_MOCK_LOCATION,
                0
            ) == 1
            details["mockLocationEnabled"] = mockLocationEnabled

            // Method 2: Check for mock location apps
            val mockApps = getInstalledMockLocationApps()
            details["mockAppsInstalled"] = mockApps.isNotEmpty()
            details["mockAppCount"] = mockApps.size

            // Method 3: Check if any app has mock location permission
            val hasMockPermissionApps = checkAppsWithMockPermission()
            details["appsWithMockPermission"] = hasMockPermissionApps

            // Determine if location is likely mocked
            isMock = mockLocationEnabled || mockApps.isNotEmpty()

        } catch (e: Exception) {
            details["error"] = e.message ?: "Unknown error"
        }

        return mapOf(
            "isMock" to isMock,
            "details" to details,
            "platform" to "Android",
            "apiLevel" to Build.VERSION.SDK_INT
        )
    }

    /**
     * Detect installed mock location apps by package signatures
     */
    private fun detectMockLocationApps(signatures: List<String>): Map<String, Any> {
        val detectedApps = mutableListOf<String>()

        try {
            val pm = packageManager
            val installedApps = pm.getInstalledApplications(PackageManager.GET_META_DATA)

            for (app in installedApps) {
                val packageName = app.packageName
                // Check if package name matches known mock app signatures
                for (signature in signatures) {
                    if (packageName.contains(signature, ignoreCase = true) ||
                        signature.contains(packageName, ignoreCase = true)) {
                        detectedApps.add(packageName)
                        break
                    }
                }
            }
        } catch (e: Exception) {
            return mapOf(
                "detected" to false,
                "error" to (e.message ?: "Unknown error"),
                "apps" to emptyList<String>()
            )
        }

        return mapOf(
            "detected" to detectedApps.isNotEmpty(),
            "count" to detectedApps.size,
            "apps" to detectedApps
        )
    }

    /**
     * Get list of installed mock location apps
     */
    private fun getInstalledMockLocationApps(): List<String> {
        val mockApps = mutableListOf<String>()
        val knownMockApps = listOf(
            "com.lexa.fakegps",
            "com.incorporateapps.fakegps.fre",
            "com.fakegps.mocklocation",
            "com.gps joystick",
            "com.location faker",
            "com.mock location",
            "com.fake.gps",
            "com.location.changer",
            "com.gps.emulator",
            "com.location.mockup",
            "com.fakegps.go",
            "com.gpsfaker",
            "com.locationfaker",
            "com.fake.location",
            "com.gps.location.mock"
        )

        try {
            val pm = packageManager
            val installedApps = pm.getInstalledApplications(PackageManager.GET_META_DATA)

            for (app in installedApps) {
                val packageName = app.packageName?.lowercase() ?: continue
                for (mockApp in knownMockApps) {
                    if (packageName.contains(mockApp)) {
                        mockApps.add(app.packageName)
                        break
                    }
                }
            }
        } catch (e: Exception) {
            // Ignore errors
        }

        return mockApps
    }

    /**
     * Check which apps have mock location permission
     */
    private fun checkAppsWithMockPermission(): List<String> {
        val appsWithPermission = mutableListOf<String>()

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            // On older Android versions, check if mock locations are enabled
            try {
                val mockLocationEnabled = Settings.Secure.getInt(
                    contentResolver,
                    Settings.Secure.ALLOW_MOCK_LOCATION,
                    0
                ) == 1

                if (mockLocationEnabled) {
                    appsWithPermission.add("Mock locations enabled in Developer Settings")
                }
            } catch (e: Exception) {
                // Ignore
            }
        }

        return appsWithPermission
    }
}
