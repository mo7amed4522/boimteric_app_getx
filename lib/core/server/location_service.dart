// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:boimteric_app_getx/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Services for handling attendance, location permissions, and location tracking.
/// This service manages all location-related functionality, including:
/// - Requesting location permissions
/// - Checking permission status
/// - Getting the current location
/// - Calculating the distance between coordinates
/// - Mock location detection and prevention
class LocationService {
  static const MethodChannel _platformChannel = MethodChannel(
    'com.example.boimteric_app_getx/location',
  );

  // Configuration for mock detection
  static const double _maxAcceptableAccuracy = 50.0; // meters
  static const double _maxAcceptableSpeed = 150.0; // m/s (540 km/h)
  static const double _maxAltitudeChangeRate = 100.0; // m/s
  static const double _maxTeleportDistance = 10000.0; // meters (10km)
  static const int _minSampleCount = 3;
  static const double _maxStandardDeviation = 100.0; // meters
  static const Duration _maxLocationAge = Duration(minutes: 5);
  static const Duration _temporalCheckWindow = Duration(seconds: 10);

  // Store previous position for temporal checks
  Position? _lastValidPosition;
  DateTime? _lastValidPositionTime;
  final List<Position> _positionSamples = [];

  // Mock location app signatures (known fake GPS apps)
  static final List<String> _mockAppSignatures = [
    'com.lexa.fakegps',
    'com.incorporateapps.fakegps.fre',
    'com.fakegps.mocklocation',
    'com.gps spoofing.app',
    'com.location faker.app',
    'com.mock location.provider',
    'com.fake.gps.location',
    'com.location.changer',
    'com.gps.emulator',
    'com.location.mockup',
    'com.fakegps.go',
    'com.gpsfaker.location',
    'com.locationfaker.gps',
    'com.fake.location.gps',
    'com.gps.location.mock',
  ];

  /// Checks if location services are enabled on the device
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Gets the current location permission status
  Future<LocationPermission> getLocationPermissionStatus() async {
    return await Geolocator.checkPermission();
  }

  /// Requests user location permission
  /// Throws [LocationPermissionException] if permission is denied
  Future<bool> requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationPermissionException(
        'Location services are disabled. Please enable location services in your device settings。',
      );
    }

    // Check the current permission status
    LocationPermission permission = await getLocationPermissionStatus();

    // If permission is denied, request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionException(
          'Location permission denied. Please grant location access permission to use attendance functionality.',
        );
      }
    }

    // If permission is permanently denied, throw an exception and provide setting guidance
    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionException(
        'Location permission permanently denied. Please enable location access permission in the app settings.',
      );
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Opens app settings to manually enable location permissions
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Opens device location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Gets the current position
  /// Returns a [Position] object containing latitude, longitude, accuracy, etc.
  ///
  /// [desiredAccuracy]: Desired accuracy level (default: highest)
  /// [timeLimit]: Maximum time to wait for a location (default: 10 seconds)
  ///
  /// Throws [LocationPermissionException] if permission is denied
  /// Throws [LocationException] if unable to get location information
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    Duration timeLimit = const Duration(seconds: 10),
  }) async {
    try {
      // First, ensure we have permission.
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        throw const LocationPermissionException(
          'Location permission is required to get the current position',
        );
      }

      // Get the current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy,
        timeLimit: timeLimit,
      );
    } on LocationServiceDisabledException {
      throw const LocationPermissionException(
        'Location services are disabled. Please enable location services in your device settings。',
      );
    } on TimeoutException {
      throw const PermissionException(
        'Unable to get location: Request timed out',
      );
    } catch (e) {
      throw PermissionException(
        'Failed to get current position: ${e.toString()}',
      );
    }
  }

  /// Gets a stream of location updates for continuous tracking
  /// Used for real-time location updates
  /// [accuracy]: Desired accuracy level (default: highest)
  /// [distanceFilter]: Minimum distance for update (meters) (default: 10 meters)
  ///
  /// Returns a stream of [Position] updates
  Stream<Position> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// Calculates the distance between two coordinates (in meters)
  /// Used to check if the user is within the workplace range
  ///
  /// [startLat]: Starting latitude
  /// [startLng]: Starting longitude
  /// [endLat]: Ending latitude
  /// [endLng]: Ending longitude
  ///
  /// Returns distance in meters
  double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Checks if the user is within the specified radius
  ///
  /// [currentLat]: Current latitude
  /// [currentLng]: Current longitude
  /// [targetLat]: Target/ workplace latitude
  /// [targetLng]: Target/ workplace longitude
  /// [radiusInMeters]: Allowed radius (in meters, default: 100 meters)
  ///
  /// Returns true if within the radius, otherwise returns false
  bool isWithinRadius({
    required double currentLat,
    required double currentLng,
    required double targetLat,
    required double targetLng,
    double radiusInMeters = 100.0,
  }) {
    double distance = calculateDistance(
      startLat: currentLat,
      startLng: currentLng,
      endLat: targetLat,
      endLng: targetLng,
    );

    return distance <= radiusInMeters;
  }

  /// Requests background location permission (for Android 10 and higher)
  /// This is required for tracking location when the app is in the background.
  Future<bool> requestBackgroundLocationPermission() async {
    if (await Permission.locationAlways.isGranted) {
      return true;
    }

    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  /// Checks if background location permission has been granted
  Future<bool> hasBackgroundLocationPermission() async {
    return await Permission.locationAlways.isGranted;
  }

  /// Gets detailed permission status for debugging/ UI purposes
  Future<Map<String, dynamic>> getPermissionDetails() async {
    final serviceEnabled = await isLocationServiceEnabled();
    final permission = await getLocationPermissionStatus();
    final backgroundPermission = await hasBackgroundLocationPermission();

    return {
      'serviceEnabled': serviceEnabled,
      'permission': permission.toString(),
      'hasWhileInUse':
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always,
      'hasAlways': permission == LocationPermission.always,
      'hasBackgroundPermission': backgroundPermission,
      'isDenied': permission == LocationPermission.denied,
      'isDeniedForever': permission == LocationPermission.deniedForever,
    };
  }

  // ==================== MOCK LOCATION DETECTION METHODS ====================

  /// Comprehensive mock location detection using multiple methods
  /// Returns a [MockLocationValidationResult] with detailed analysis
  Future<MockLocationValidationResult> validateLocationAuthenticity(
    Position position, {
    bool enableMultipleSamples = true,
    bool enableTemporalCheck = true,
    bool enablePlatformCheck = true,
  }) async {
    final List<MockLocationDetectionMethod> detectedMethods = [];
    final Map<String, dynamic> details = {};

    // Method 1: Check isMock flag (basic Android check)
    if (await _checkIsMockFlag(position)) {
      detectedMethods.add(MockLocationDetectionMethod.isMockFlag);
      details['isMockFlag'] = true;
    }

    // Method 2: Check accuracy anomaly
    if (_checkAccuracyAnomaly(position)) {
      detectedMethods.add(MockLocationDetectionMethod.accuracyAnomaly);
      details['accuracy'] = position.accuracy;
      details['maxAcceptableAccuracy'] = _maxAcceptableAccuracy;
    }

    // Method 3: Check speed anomaly
    if (_checkSpeedAnomaly(position)) {
      detectedMethods.add(MockLocationDetectionMethod.speedAnomaly);
      details['speed'] = position.speed;
      details['maxAcceptableSpeed'] = _maxAcceptableSpeed;
    }

    // Method 4: Check altitude anomaly
    if (_checkAltitudeAnomaly(position)) {
      detectedMethods.add(MockLocationDetectionMethod.altitudeAnomaly);
      details['altitude'] = position.altitude;
    }

    // Method 5: Temporal consistency check
    if (enableTemporalCheck && _lastValidPosition != null) {
      final temporalResult = _checkTemporalConsistency(position);
      if (temporalResult != null) {
        detectedMethods.add(MockLocationDetectionMethod.temporalInconsistency);
        details['temporalCheck'] = temporalResult;
      }
    }

    // Method 6: Multiple samples validation
    if (enableMultipleSamples) {
      final sampleResult = await _validateWithMultipleSamples(position);
      if (sampleResult != null) {
        detectedMethods.add(
          MockLocationDetectionMethod.multipleSampleDeviation,
        );
        details['sampleValidation'] = sampleResult;
      }
    }

    // Method 7: Platform-specific checks (Android/iOS native)
    if (enablePlatformCheck) {
      final platformResult = await _checkPlatformMockLocation();
      if (platformResult['isMock'] == true) {
        detectedMethods.add(MockLocationDetectionMethod.platformChannel);
        details['platformCheck'] = platformResult;
      }
    }

    // Method 8: Check for mock location apps (Android only)
    if (Platform.isAndroid) {
      final appResult = await _detectMockLocationApps();
      if (appResult['detected'] == true) {
        detectedMethods.add(MockLocationDetectionMethod.appSignature);
        details['mockApps'] = appResult;
      }
    }

    final isAuthentic = detectedMethods.isEmpty;

    if (isAuthentic) {
      _lastValidPosition = position;
      _lastValidPositionTime = DateTime.now();
    }

    return MockLocationValidationResult(
      isAuthentic: isAuthentic,
      detectedMethods: detectedMethods,
      details: details,
      timestamp: DateTime.now(),
      position: position,
    );
  }

  /// Method 1: Check the isMock flag from Geolocator
  Future<bool> _checkIsMockFlag(Position position) async {
    try {
      // On Android, position.isMocked indicates mock location
      // On iOS, this may not be reliable, so we use additional checks
      if (Platform.isAndroid) {
        return position.isMocked;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking isMock flag: $e');
      return false;
    }
  }

  /// Method 2: Check for accuracy anomalies
  /// Mock locations often have unrealistic accuracy values
  bool _checkAccuracyAnomaly(Position position) {
    // Unusually high accuracy (low value) can indicate mock location
    if (position.accuracy < 0) return true;
    if (position.accuracy > _maxAcceptableAccuracy) return true;

    // Check if accuracy is suspiciously perfect
    if (position.accuracy < 1.0 && position.accuracy > 0) {
      return true;
    }

    return false;
  }

  /// Method 3: Check for speed anomalies
  /// Unrealistic speeds indicate mock location
  bool _checkSpeedAnomaly(Position position) {
    if (position.speed < 0) return true;
    if (position.speed > _maxAcceptableSpeed) return true;

    // Check speed accuracy if available
    if (position.speedAccuracy > 0) {
      if (position.speedAccuracy > position.speed * 2) {
        return true;
      }
    }

    return false;
  }

  /// Method 4: Check for altitude anomalies
  bool _checkAltitudeAnomaly(Position position) {
    if (position.altitude.isNaN || position.altitude.isInfinite) {
      return true;
    }

    // Check altitude accuracy
    if (position.altitudeAccuracy > 0) {
      if (position.altitudeAccuracy > 1000) return true;
    }

    return false;
  }

  /// Method 5: Check temporal consistency
  /// Detects impossible location jumps (teleportation)
  Map<String, dynamic>? _checkTemporalConsistency(Position position) {
    if (_lastValidPosition == null || _lastValidPositionTime == null) {
      return null;
    }

    final now = DateTime.now();
    final timeDiff = now.difference(_lastValidPositionTime!);

    if (timeDiff > _temporalCheckWindow) {
      return null; // Too much time passed, skip check
    }

    final distance = calculateDistance(
      startLat: _lastValidPosition!.latitude,
      startLng: _lastValidPosition!.longitude,
      endLat: position.latitude,
      endLng: position.longitude,
    );

    final timeDiffSeconds = timeDiff.inMilliseconds / 1000.0;
    final calculatedSpeed = distance / timeDiffSeconds;

    // Check for teleportation (impossible distance in short time)
    if (distance > _maxTeleportDistance && timeDiffSeconds < 60) {
      return {
        'distance': distance,
        'timeDiffSeconds': timeDiffSeconds,
        'calculatedSpeed': calculatedSpeed,
        'maxTeleportDistance': _maxTeleportDistance,
        'reason': 'Impossible distance traveled in short time',
      };
    }

    // Check for unrealistic speed
    if (calculatedSpeed > _maxAcceptableSpeed) {
      return {
        'distance': distance,
        'timeDiffSeconds': timeDiffSeconds,
        'calculatedSpeed': calculatedSpeed,
        'maxAcceptableSpeed': _maxAcceptableSpeed,
        'reason': 'Unrealistic speed detected',
      };
    }

    return null;
  }

  /// Method 6: Validate with multiple samples
  /// Takes multiple readings and checks for consistency
  Future<Map<String, dynamic>?> _validateWithMultipleSamples(
    Position position,
  ) async {
    _positionSamples.add(position);

    // Keep only recent samples
    if (_positionSamples.length > _minSampleCount) {
      _positionSamples.removeAt(0);
    }

    if (_positionSamples.length < _minSampleCount) {
      return null; // Not enough samples yet
    }

    // Calculate standard deviation of coordinates
    final latitudes = _positionSamples.map((p) => p.latitude).toList();
    final longitudes = _positionSamples.map((p) => p.longitude).toList();

    final latStdDev = _calculateStandardDeviation(latitudes);
    final lngStdDev = _calculateStandardDeviation(longitudes);

    // Check if positions are too scattered (possible mock location switching)
    if (latStdDev > _maxStandardDeviation ||
        lngStdDev > _maxStandardDeviation) {
      return {
        'latitudeStdDev': latStdDev,
        'longitudeStdDev': lngStdDev,
        'maxStandardDeviation': _maxStandardDeviation,
        'sampleCount': _positionSamples.length,
        'reason': 'High variance in position samples',
      };
    }

    // Check for identical coordinates (static mock)
    final uniqueCoords = _positionSamples
        .map(
          (p) =>
              '${p.latitude.toStringAsFixed(6)},${p.longitude.toStringAsFixed(6)}',
        )
        .toSet();

    if (uniqueCoords.length == 1 &&
        _positionSamples.length >= _minSampleCount) {
      return {
        'identicalCoordinates': uniqueCoords.first,
        'sampleCount': _positionSamples.length,
        'reason': 'Identical coordinates across multiple samples',
      };
    }

    return null;
  }

  /// Method 7: Platform-specific mock location checks
  Future<Map<String, dynamic>> _checkPlatformMockLocation() async {
    try {
      final result = await _platformChannel.invokeMethod<Map<dynamic, dynamic>>(
        'checkMockLocation',
      );
      return {
        'isMock': result?['isMock'] ?? false,
        'details': result?['details'],
        'platform': Platform.operatingSystem,
      };
    } on MissingPluginException {
      // Platform channel not implemented yet
      return {'isMock': false, 'platform': Platform.operatingSystem};
    } catch (e) {
      debugPrint('Platform mock check error: $e');
      return {'isMock': false, 'error': e.toString()};
    }
  }

  /// Method 8: Detect mock location apps (Android only)
  Future<Map<String, dynamic>> _detectMockLocationApps() async {
    if (!Platform.isAndroid) {
      return {'detected': false, 'platform': 'iOS'};
    }

    try {
      final result = await _platformChannel.invokeMethod<Map<dynamic, dynamic>>(
        'detectMockApps',
        {'signatures': _mockAppSignatures},
      );

      return {
        'detected': result?['detected'] ?? false,
        'apps': result?['apps'] ?? [],
        'count': result?['count'] ?? 0,
      };
    } on MissingPluginException {
      return {'detected': false, 'platform': 'Android'};
    } catch (e) {
      debugPrint('Mock app detection error: $e');
      return {'detected': false, 'error': e.toString()};
    }
  }

  /// Calculate standard deviation for a list of values
  double _calculateStandardDeviation(List<double> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => pow(v - mean, 2)).toList();
    final variance = squaredDiffs.reduce((a, b) => a + b) / values.length;
    return sqrt(variance);
  }

  /// Get secure location with comprehensive mock detection
  /// Throws [MockLocationException] if mock location is detected
  Future<Position> getSecurePosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    Duration timeLimit = const Duration(seconds: 10),
    bool strictMode = true,
  }) async {
    final position = await getCurrentPosition(
      desiredAccuracy: desiredAccuracy,
      timeLimit: timeLimit,
    );

    final validation = await validateLocationAuthenticity(
      position,
      enableMultipleSamples: strictMode,
      enableTemporalCheck: strictMode,
      enablePlatformCheck: strictMode,
    );

    if (!validation.isAuthentic) {
      throw MockLocationException(
        'Mock or fake GPS location detected. Please disable any location spoofing apps and try again.',
        detectionMethod: validation.detectedMethods.first,
        details: validation.details,
      );
    }

    return position;
  }

  /// Clear stored position samples and history
  void clearPositionHistory() {
    _positionSamples.clear();
    _lastValidPosition = null;
    _lastValidPositionTime = null;
  }

  /// Get current mock detection configuration
  Map<String, dynamic> getMockDetectionConfig() {
    return {
      'maxAcceptableAccuracy': _maxAcceptableAccuracy,
      'maxAcceptableSpeed': _maxAcceptableSpeed,
      'maxAltitudeChangeRate': _maxAltitudeChangeRate,
      'maxTeleportDistance': _maxTeleportDistance,
      'minSampleCount': _minSampleCount,
      'maxStandardDeviation': _maxStandardDeviation,
      'maxLocationAge': _maxLocationAge.inSeconds,
      'temporalCheckWindow': _temporalCheckWindow.inSeconds,
      'mockAppSignatures': _mockAppSignatures.length,
    };
  }
}

/// Result of mock location validation
class MockLocationValidationResult {
  final bool isAuthentic;
  final List<MockLocationDetectionMethod> detectedMethods;
  final Map<String, dynamic> details;
  final DateTime timestamp;
  final Position position;

  const MockLocationValidationResult({
    required this.isAuthentic,
    required this.detectedMethods,
    required this.details,
    required this.timestamp,
    required this.position,
  });

  @override
  String toString() {
    return 'MockLocationValidationResult(isAuthentic: $isAuthentic, '
        'methods: ${detectedMethods.map((m) => m.name).join(", ")}, '
        'timestamp: $timestamp)';
  }
}
