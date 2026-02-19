// ignore_for_file: unnecessary_brace_in_string_interps, prefer_final_fields, strict_top_level_inference

import 'dart:async';
import 'dart:convert';

import 'package:boimteric_app_getx/core/constants/app_constatn.dart';
import 'package:boimteric_app_getx/core/constants/curd.dart';
import 'package:boimteric_app_getx/core/constants/loader.dart';
import 'package:boimteric_app_getx/core/errors/exceptions.dart';
import 'package:boimteric_app_getx/core/server/biometric_auth_service.dart';
import 'package:boimteric_app_getx/core/server/location_service.dart';
import 'package:boimteric_app_getx/core/server/serves.dart';
import 'package:boimteric_app_getx/core/theme/app_colors.dart';
import 'package:boimteric_app_getx/model/attendance_model.dart';
import 'package:boimteric_app_getx/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

/// Controller for Home Tab View Screen with location tracking and safe zone detection
abstract class HomeTabViewScreenController extends GetxController {
  /// Current user position
  Position? get currentPosition;

  /// Whether user is within any safe zone
  bool get isInSafeZone;

  /// Distance to nearest safe zone in meters
  double get distanceToSafeZone;

  /// Nearest safe zone location
  Locations? get nearestLocation;

  /// Location validation status message
  String get locationStatusMessage;

  /// Location status type for UI theming
  LocationStatus get locationStatus;

  /// Whether location tracking is active
  bool get isTracking;

  /// Whether check-in is enabled (in safe zone)
  bool get canCheckIn;

  /// Whether user is checked in
  bool get isCheckedIn;

  /// Loading state
  bool get isLoading;

  /// Error message if any
  String? get errorMessage;

  /// Whether biometric authentication is enabled
  bool get isBiometricEnabled;

  /// Whether biometric authentication is available on device
  bool get isBiometricAvailable;

  /// Name of the available biometric type
  String get biometricTypeName;

  /// Whether user is biometric authenticated
  bool get isBiometricAuthenticated;

  /// Start location tracking
  void startLocationTracking();

  /// Stop location tracking
  void stopLocationTracking();

  /// Perform check-in
  Future<void> checkIn();

  /// Perform check-out
  Future<void> checkOut();

  /// Refresh location manually
  Future<void> refreshLocation();

  /// Authenticate with biometric
  Future<bool> authenticateWithBiometric();

  /// Check biometric availability
  Future<void> checkBiometricAvailability();
}

/// Location status enum for UI theming
enum LocationStatus {
  /// Initial/unknown state
  unknown,

  /// Location services disabled
  serviceDisabled,

  /// Permission denied
  permissionDenied,

  /// Searching for location
  searching,

  /// In safe zone - success state
  inSafeZone,

  /// Outside safe zone - warning state
  outsideSafeZone,

  /// Error occurred
  error,
}

/// Implementation of HomeTabViewScreenController
class HomeTabViewScreenControllerImp extends HomeTabViewScreenController {
  // Services
  final LocationService _locationService = LocationService();
  final BiometricAuthService _biometricAuthService = BiometricAuthService();
  final MyServices _myServices = Get.find<MyServices>();
  final Crud _crud = Crud();

  // State variables
  Position? _currentPosition;
  bool _isInSafeZone = false;
  double _distanceToSafeZone = double.infinity;
  Locations? _nearestLocation;
  String _locationStatusMessage = 'Initializing location services...';
  LocationStatus _locationStatus = LocationStatus.unknown;
  bool _isTracking = false;
  bool _isCheckedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Biometric authentication state
  bool _isBiometricEnabled = true;
  bool _isBiometricAvailable = false;
  String _biometricTypeName = 'Biometric';
  bool _isBiometricAuthenticated = false;

  // Stream subscription for location updates
  StreamSubscription<Position>? _locationStreamSubscription;

  // User data
  LoginModel? _loginModel;
  List<Locations> get _safeZones => _loginModel?.locations ?? [];

  // Getters
  @override
  Position? get currentPosition => _currentPosition;

  @override
  bool get isInSafeZone => _isInSafeZone;

  @override
  double get distanceToSafeZone => _distanceToSafeZone;

  @override
  Locations? get nearestLocation => _nearestLocation;

  @override
  String get locationStatusMessage => _locationStatusMessage;

  @override
  LocationStatus get locationStatus => _locationStatus;

  @override
  bool get isTracking => _isTracking;

  @override
  bool get canCheckIn => _isInSafeZone && !_isCheckedIn;

  @override
  bool get isCheckedIn => _isCheckedIn;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  @override
  bool get isBiometricEnabled => _isBiometricEnabled;

  @override
  bool get isBiometricAvailable => _isBiometricAvailable;

  @override
  String get biometricTypeName => _biometricTypeName;

  @override
  bool get isBiometricAuthenticated => _isBiometricAuthenticated;

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadCheckInState();
    checkBiometricAvailability();
    _requestPermissionAndStartTracking();
  }

  @override
  void onClose() {
    _isDisposed = true;
    stopLocationTracking();
    super.onClose();
  }

  /// Safe update that checks if controller is still alive
  void _safeUpdate() {
    if (!_isDisposed && !isClosed) {
      update();
    }
  }

  /// Request location permission and start tracking
  Future<void> _requestPermissionAndStartTracking() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationStatus = LocationStatus.serviceDisabled;
        _locationStatusMessage =
            'Location services are disabled. Please enable location services.';
        _showLocationServiceDialog();
        _safeUpdate();
        return;
      }

      // Check permission status
      final permissionStatus = await _locationService
          .getLocationPermissionStatus();

      if (permissionStatus == LocationPermission.denied) {
        // Show permission request dialog
        final shouldRequest = await _showPermissionRequestDialog();
        if (!shouldRequest) {
          _locationStatus = LocationStatus.permissionDenied;
          _locationStatusMessage =
              'Location permission is required for attendance tracking.';
          _safeUpdate();
          return;
        }
      }

      // Request permission and start tracking
      await _locationService.requestLocationPermission();
      startLocationTracking();
    } on LocationPermissionException catch (e) {
      _locationStatus = LocationStatus.permissionDenied;
      _locationStatusMessage = e.message;
      _showPermissionDeniedDialog();
      _safeUpdate();
    } catch (e) {
      _locationStatus = LocationStatus.error;
      _locationStatusMessage = 'Error initializing location: ${e.toString()}';
      _safeUpdate();
    }
  }

  /// Show dialog to request location permission
  Future<bool> _showPermissionRequestDialog() async {
    final result = await Get.dialog<bool>(
      barrierDismissible: false,
      AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: AppColors.primary),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Location Permission',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Text(
          'This app needs access to your location for attendance tracking.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Deny',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show dialog when permission is denied
  void _showPermissionDeniedDialog() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block, color: AppColors.error),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Permission Required',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Text(
          'Location permission is required for attendance tracking. Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _locationService.openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show dialog when location service is disabled
  void _showLocationServiceDialog() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, color: AppColors.warning),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Location Services Disabled',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Text(
          'Please enable location services on your device to use attendance features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _locationService.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Enable Location'),
          ),
        ],
      ),
    );
  }

  /// Load user data from shared preferences
  void _loadUserData() {
    final userDataString = _myServices.sharedPreferences.getString('userdata');
    if (userDataString != null) {
      _loginModel = LoginModel.fromJson(
        jsonDecode(userDataString) as Map<String, dynamic>,
      );
    }
  }

  /// Load check-in state from user data first, then fall back to shared preferences
  void _loadCheckInState() {
    // First check SharedPreferences
    final sharedPrefValue = _myServices.sharedPreferences.getBool(
      AttendanceConfig.isCheckedInKey,
    );
    debugPrint('Loaded isCheckedIn from SharedPreferences: $sharedPrefValue');
    if (sharedPrefValue != null) {
      // Use value from SharedPreferences if it exists
      _isCheckedIn = sharedPrefValue;
    } else {
      // Fall back to LoginModel if no value in SharedPreferences
      _isCheckedIn = _loginModel?.isCheckedIn ?? false;
      debugPrint('Loaded isCheckedIn from LoginModel: ${_isCheckedIn}');
    }
  }

  @override
  void startLocationTracking() {
    if (_isTracking || _isDisposed) return;

    _isTracking = true;
    _locationStatus = LocationStatus.searching;
    _locationStatusMessage = 'Acquiring location...';
    _safeUpdate();

    // Start location stream with 30cm distance filter
    _locationStreamSubscription = _locationService
        .getLocationStream(
          accuracy: LocationAccuracy.best,
          distanceFilter: (AttendanceConfig.distanceFilter * 100).toInt(),
        )
        .listen(_onLocationUpdate, onError: _onLocationError);
  }

  @override
  void stopLocationTracking() {
    _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
    _isTracking = false;
    if (!_isDisposed) {
      update();
    }
  }

  /// Handle location updates from stream
  Future<void> _onLocationUpdate(Position position) async {
    _currentPosition = position;

    // Check if within any safe zone
    _checkSafeZoneStatus(position);
  }

  /// Check if position is within any safe zone
  void _checkSafeZoneStatus(Position position) {
    if (_safeZones.isEmpty) {
      _locationStatus = LocationStatus.error;
      _locationStatusMessage = 'No safe zones configured';
      _isInSafeZone = false;
      _safeUpdate();
      return;
    }

    double minDistance = double.infinity;
    Locations? nearest;
    bool inAnyZone = false;

    for (final zone in _safeZones) {
      if (zone.latitude == null ||
          zone.longitude == null ||
          zone.radius == null) {
        continue;
      }

      final distance = _locationService.calculateDistance(
        startLat: position.latitude,
        startLng: position.longitude,
        endLat: zone.latitude!,
        endLng: zone.longitude!,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearest = zone;
      }

      if (distance <= zone.radius!) {
        inAnyZone = true;
      }
    }

    _distanceToSafeZone = minDistance;
    _nearestLocation = nearest;
    _isInSafeZone = inAnyZone;

    if (_isInSafeZone) {
      _locationStatus = LocationStatus.inSafeZone;
      _locationStatusMessage =
          'You are in safe zone: ${nearest?.name ?? 'Unknown'}';
    } else {
      _locationStatus = LocationStatus.outsideSafeZone;
      final distanceText = _formatDistance(minDistance);
      _locationStatusMessage =
          'You are $distanceText away from ${nearest?.name ?? 'nearest safe zone'}';
    }

    _safeUpdate();
  }

  /// Format distance for display
  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }

  /// Handle location errors
  void _onLocationError(dynamic error) {
    if (_isDisposed) return;

    _isTracking = false;

    if (error is LocationPermissionException) {
      _locationStatus = LocationStatus.permissionDenied;
      _locationStatusMessage =
          'Location permission denied. Please enable in settings.';
      _showPermissionDeniedDialog();
    } else {
      _locationStatus = LocationStatus.error;
      _locationStatusMessage = 'Location error: ${error.toString()}';
    }

    _errorMessage = error.toString();
    _safeUpdate();
  }

  @override
  Future<void> checkBiometricAvailability() async {
    try {
      final isAvailable = await _biometricAuthService.canCheckBiometrics();
      final isSupported = await _biometricAuthService.isDeviceSupported();
      final availableBiometrics = await _biometricAuthService
          .getAvailableBiometrics();

      debugPrint('Biometric - canCheckBiometrics: $isAvailable');
      debugPrint('Biometric - isDeviceSupported: $isSupported');
      debugPrint('Biometric - availableBiometrics: $availableBiometrics');

      _isBiometricAvailable = isAvailable && isSupported;

      if (_isBiometricAvailable) {
        _biometricTypeName = await _biometricAuthService
            .getPrimaryBiometricName();
        debugPrint('Biometric - typeName: $_biometricTypeName');
      } else {
        debugPrint(
          'Biometric - Not available. isAvailable: $isAvailable, isSupported: $isSupported',
        );
      }

      _safeUpdate();
    } catch (e) {
      debugPrint('Biometric - Error checking availability: $e');
      _isBiometricAvailable = false;
    }
  }

  @override
  Future<bool> authenticateWithBiometric() async {
    if (!_isBiometricEnabled) {
      debugPrint('Biometric - Skipped: biometric is disabled');
      return true; // Skip biometric if disabled
    }

    if (!_isBiometricAvailable) {
      debugPrint('Biometric - Skipped: biometric not available on this device');
      // Show a message to the user that biometric is not available
      Get.snackbar(
        'Biometric Not Available',
        'This device does not support biometric authentication. Proceeding without it.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return true; // Allow proceeding without biometric
    }

    debugPrint('Biometric - Starting authentication with $_biometricTypeName');

    try {
      final result = await _biometricAuthService.authenticateWithRetry(
        localizedReason:
            'Authenticate with $_biometricTypeName to proceed with attendance',
        retryMessage: 'Authentication failed. Please try again.',
      );

      debugPrint('Biometric - Authentication result: $result');

      _isBiometricAuthenticated = result;
      _safeUpdate();
      return result;
    } on BiometricAuthException catch (e) {
      debugPrint('Biometric - Exception: ${e.type} - ${e.message}');
      _isBiometricAuthenticated = false;

      // Show appropriate error message
      String errorTitle = 'Authentication Failed';
      String errorMessage = e.message;

      if (e.type == BiometricAuthErrorType.notAvailable) {
        errorTitle = 'Biometric Not Available';
      } else if (e.type == BiometricAuthErrorType.notEnrolled) {
        errorTitle = 'Biometric Not Set Up';
        errorMessage =
            'Please set up $_biometricTypeName in your device settings.';
      } else if (e.type == BiometricAuthErrorType.lockedOut) {
        errorTitle = 'Too Many Attempts';
        errorMessage =
            'Biometric authentication is temporarily locked. Please try again later.';
      } else if (e.type == BiometricAuthErrorType.permanentlyLockedOut) {
        errorTitle = 'Biometric Locked';
        errorMessage =
            'Biometric authentication is permanently locked. Please use device settings to unlock.';
      } else if (e.type == BiometricAuthErrorType.cancelled) {
        errorTitle = 'Authentication Cancelled';
        errorMessage = 'You cancelled the biometric authentication.';
      }

      Get.snackbar(
        errorTitle,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      _safeUpdate();
      return false;
    }
  }

  @override
  Future<void> refreshLocation() async {
    _isLoading = true;
    _locationStatus = LocationStatus.searching;
    _locationStatusMessage = 'Refreshing location...';
    _safeUpdate();

    try {
      final position = await _locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );
      await _onLocationUpdate(position);
    } catch (e) {
      _onLocationError(e);
    } finally {
      _isLoading = false;
      _safeUpdate();
    }
  }

  @override
  Future<void> checkIn() async {
    if (!_isInSafeZone) {
      Get.snackbar(
        'Cannot Check In',
        'You must be within a safe zone to check in',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (_currentPosition == null) {
      Get.snackbar(
        'Location Error',
        'Unable to get current location. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Perform biometric authentication first
    if (_isBiometricEnabled && _isBiometricAvailable) {
      final isAuthenticated = await authenticateWithBiometric();
      if (!isAuthenticated) {
        return; // Stop if biometric authentication fails
      }
    }

    _isLoading = true;
    update();
    Loader().lottieLoader();

    try {
      final baseUrl = _myServices.sharedPreferences.getString('baseUrl') ?? '';
      final checkInUrl = '$baseUrl/api/attendance/checkin';
      final token = _loginModel?.token ?? '';

      final requestBody = {
        'token': token,
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
        'datetime': _formatDateTime(DateTime.now()),
      };

      final response = await _crud.postRequest(checkInUrl, requestBody);
      Get.back(); // Close loader

      if (response['success'] == true) {
        final checkInResponse = BxUserCheckInResponse.fromJson(response);

        _isCheckedIn = true;
        await _myServices.sharedPreferences.setBool(
          AttendanceConfig.isCheckedInKey,
          true,
        );
        await _myServices.sharedPreferences.setString(
          AttendanceConfig.currentLocationIdKey,
          _nearestLocation?.id.toString() ?? '',
        );

        Get.snackbar(
          'Success',
          checkInResponse.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['error'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Close loader
      Get.snackbar(
        'Error',
        'Failed to check in: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading = false;
      update();
    }
  }

  @override
  Future<void> checkOut() async {
    if (_currentPosition == null) {
      Get.snackbar(
        'Location Error',
        'Unable to get current location. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Perform biometric authentication first
    if (_isBiometricEnabled && _isBiometricAvailable) {
      final isAuthenticated = await authenticateWithBiometric();
      if (!isAuthenticated) {
        return; // Stop if biometric authentication fails
      }
    }

    _isLoading = true;
    update();
    Loader().lottieLoader();

    try {
      final baseUrl = _myServices.sharedPreferences.getString('baseUrl') ?? '';
      final checkOutUrl = '$baseUrl/api/attendance/checkout';
      final token = _loginModel?.token ?? '';

      final requestBody = {
        'token': token,
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
        'datetime': _formatDateTime(DateTime.now()),
      };

      final response = await _crud.postRequest(checkOutUrl, requestBody);
      Get.back(); // Close loader

      if (response['success'] == true) {
        final checkOutResponse = BxUserCheckOutResponse.fromJson(response);

        _isCheckedIn = false;
        await _myServices.sharedPreferences.setBool(
          AttendanceConfig.isCheckedInKey,
          false,
        );
        

        Get.snackbar(
          'Success',
          checkOutResponse.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['error'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Close loader
      Get.snackbar(
        'Error',
        'Failed to check out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading = false;
      _safeUpdate();
    }
  }

  /// Format DateTime to API format: "2026-02-14 09:00:00"
  String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }
}
