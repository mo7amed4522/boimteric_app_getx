# Attendance Feature Implementation Plan

## Overview
Build an attendance system within `home_tab_view_screen.dart` that:
- Tracks real-time location with 30cm precision updates
- Validates location authenticity using `location_service.dart` mock detection
- Displays check-in/check-out button based on user's safe zones from `login_model.dart`
- Persists check-in state in SharedPreferences via `serves.dart`

## Architecture Flow

```
home_tab_view_screen.dart
    |
    v
home_tab_view_screen_controller.dart
    |---> LocationService (getSecurePosition with mock detection)
    |---> MyServices (SharedPreferences for isCheckedIn state)
    |---> LoginModel (safe zones: latitude, longitude, radius)
```

## Implementation Steps

### Step 1: Update LoginModel (lib/model/login_model.dart)
Add helper methods for safe zone validation:
- `isWithinSafeZone(currentLat, currentLng)` - Check if user is within any location radius
- `getNearestLocation(currentLat, currentLng)` - Get closest safe zone

### Step 2: Enhance HomeTabViewScreenController (lib/controller/home_tab_view_screen_controller/home_tab_view_screen_controller.dart)
Add state management and business logic:

**State Variables:**
- `Position? currentPosition` - Current GPS coordinates
- `bool isWithinSafeZone` - Whether user is in a valid check-in zone
- `bool isCheckedIn` - Current attendance status (from SharedPreferences, fallback to LoginModel)
- `Locations? nearestLocation` - Closest safe zone location
- `double distanceToNearest` - Distance in meters to nearest zone
- `StreamSubscription<Position>? locationStream` - Real-time location subscription
- `bool isLoading` - Loading state for check-in/out operations

**Methods:**
- `onInit()` - Initialize location stream, load check-in state from SharedPreferences
- `startLocationTracking()` - Subscribe to location updates with 30cm (0.3m) distance filter
- `validateLocation()` - Use `location_service.getSecurePosition()` for mock detection
- `updateLocation(Position position)` - Update coordinates, check safe zone proximity
- `checkIn()` - API call to check-in, update SharedPreferences
- `checkOut()` - API call to check-out, update SharedPreferences
- `loadCheckInState()` - Load from SharedPreferences first, fallback to LoginModel.isCheckedIn
- `dispose()` - Cancel location stream

### Step 3: Build HomeTabViewScreen UI (lib/view/screen/home_tab_view_screen/home_tab_view_screen.dart)

**UI Components:**
- **Location Status Card**: Shows current coordinates, accuracy, mock detection status
- **Safe Zone Info**: Displays nearest location name, distance, radius
- **Check-in Button**: Large prominent button with dynamic text ("Check In" / "Check Out")
- **Status Indicator**: Visual indicator for in-zone/out-of-zone status
- **Validation Feedback**: Shows mock location warnings if detected

**Button States:**
- Disabled when: Out of safe zone, mock location detected, loading
- Enabled when: In safe zone, location authentic

### Step 4: API Integration (lib/core/constants/curd.dart or new attendance_api.dart)
Add attendance endpoints:
- `POST /api/attendance/checkin` - Body: {location_id, latitude, longitude, timestamp}
- `POST /api/api/attendance/checkout` - Body: {location_id, latitude, longitude, timestamp}

### Step 5: Update Constants (lib/core/constants/app_constatn.dart)
Add attendance-related constants:
- `distanceFilter` = 0.3 (30cm in meters)
- `ApiLink.checkInUrl`
- `ApiLink.checkOutUrl`

## Key Technical Details

### Location Tracking Configuration
```dart
LocationSettings(
  accuracy: LocationAccuracy.best,
  distanceFilter: 0, // Use 0 and filter manually for 30cm precision
)
```
Note: Most GPS chips provide ~3-5m accuracy. 30cm updates will trigger frequently but actual precision depends on device hardware.

### Check-in State Priority
1. First: Check SharedPreferences (`isCheckedIn` key)
2. Fallback: Use `LoginModel.isCheckedIn`
3. Update: Always save to SharedPreferences on change

### Mock Location Handling
- Use `location_service.getSecurePosition()` before check-in/out
- Display warning banner if mock location detected
- Block check-in/out operations when mock detected

### Safe Zone Validation
```dart
// Using LocationService.calculateDistance
distance = calculateDistance(
  startLat: currentLat,
  startLng: currentLng,
  endLat: location.latitude!,
  endLng: location.longitude!,
);
isWithinZone = distance <= location.radius!;
```

## Files to Modify

1. `lib/model/login_model.dart` - Add safe zone helper methods
2. `lib/controller/home_tab_view_screen_controller/home_tab_view_screen_controller.dart` - Full controller implementation
3. `lib/view/screen/home_tab_view_screen/home_tab_view_screen.dart` - Complete UI
4. `lib/core/constants/app_constatn.dart` - Add API endpoints
5. `lib/core/server/serves.dart` - No changes needed (already has SharedPreferences)
6. `lib/core/server/location_service.dart` - No changes needed (already has mock detection)

## Files to Create (Optional)

1. `lib/model/attendance_model.dart` - Check-in/out response model
2. `lib/core/api/attendance_api.dart` - Dedicated attendance API class

## Testing Considerations

- Test mock location detection with fake GPS apps
- Verify 30cm update frequency doesn't drain battery
- Test check-in state persistence across app restarts
- Validate safe zone boundary calculations
- Test offline scenarios and error handling