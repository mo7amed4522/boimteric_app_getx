// File: lib/core/constant/app_constant.dart
// Architecture: Core Layer - Constant
// Purpose: App constant data

class AppConstant {
  static const String appName = "Biometric App";
}

class AppImages {
  // ========================== base images ============================== //
  static const String base = "assets/images/";
  static const String logo = "${base}logo.png";
}

class AppJson {
  static const String base = "assets/json/";
  static const String load = "${base}lf30_editor_pdbikagl.json";
}

class ApiLink {
  static const String baseUrl = '';
  // ======================= AUTH URL =========================//
  static const String loginUrl = '$baseUrl/api/attendance/login';

  // ======================= ATTENDANCE URL =========================//
  static const String checkInUrl = '$baseUrl/api/attendance/checkin';
  static const String checkOutUrl = '$baseUrl/api/attendance/checkout';
  static const String attendanceStatusUrl = '$baseUrl/api/attendance/status';
}

// ======================= ATTENDANCE CONFIG =========================//
class AttendanceConfig {
  /// Distance filter for location updates (30cm = 0.3 meters)
  static const double distanceFilter = 0.3;

  /// Minimum accuracy required for valid location (meters)
  static const double minAccuracy = 50.0;

  /// Location update interval (milliseconds)
  static const int locationUpdateInterval = 1000;

  /// SharedPreferences key for check-in state
  static const String isCheckedInKey = 'is_checked_in';

  /// SharedPreferences key for last check-in time
  static const String lastCheckInTimeKey = 'last_check_in_time';

  /// SharedPreferences key for last check-out time
  static const String lastCheckOutTimeKey = 'last_check_out_time';

  /// SharedPreferences key for current location ID
  static const String currentLocationIdKey = 'current_location_id';
}

class AppRive {
  static const String base = "assets/rive/";
  static const String button = "${base}button.riv";
  static const String check = "${base}check.riv";
  static const String confetti = "${base}confetti.riv";
  static const String icons = "${base}icons.riv";
  static const String menuButton = "${base}menu_button.riv";
  static const String shapes = "${base}shapes.riv";
}
