// File: lib/core/server/biometric_auth_service.dart
// Architecture: Core Layer - Service
// Purpose: Biometric authentication service for fingerprint and face ID

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

/// Exception for biometric authentication errors
class BiometricAuthException implements Exception {
  final String message;
  final BiometricAuthErrorType type;

  BiometricAuthException(this.message, this.type);

  @override
  String toString() => 'BiometricAuthException: $message';
}

/// Enum for biometric authentication error types
enum BiometricAuthErrorType {
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
  cancelled,
  failed,
  unknown,
}

/// Service for handling biometric authentication
class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// Check if biometrics are available on the device
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Check if fingerprint is available
  Future<bool> isFingerprintAvailable() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.strong);
  }

  /// Check if face ID is available
  Future<bool> isFaceIdAvailable() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.face) ||
        availableBiometrics.contains(BiometricType.iris);
  }

  /// Get the primary biometric type name for display
  Future<String> getPrimaryBiometricName() async {
    final availableBiometrics = await getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return 'Iris Scan';
    } else if (availableBiometrics.contains(BiometricType.strong)) {
      return Platform.isIOS ? 'Face ID' : 'Fingerprint';
    } else if (availableBiometrics.contains(BiometricType.weak)) {
      return 'Biometric';
    }

    return 'Biometric';
  }

  /// Authenticate with biometrics
  /// Returns true if authentication is successful
  /// Throws BiometricAuthException if authentication fails
  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to proceed',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    bool sensitiveTransaction = true,
  }) async {
    try {
      // Check if biometrics are available
      final isAvailable = await canCheckBiometrics();
      if (!isAvailable) {
        throw BiometricAuthException(
          'Biometric authentication is not available on this device',
          BiometricAuthErrorType.notAvailable,
        );
      }

      final availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        throw BiometricAuthException(
          'No biometric methods are enrolled on this device',
          BiometricAuthErrorType.notEnrolled,
        );
      }

      // Configure authentication options based on platform
      final authOptions = AuthenticationOptions(
        useErrorDialogs: useErrorDialogs,
        stickyAuth: stickyAuth,
        sensitiveTransaction: sensitiveTransaction,
        biometricOnly: true,
      );

      // Perform authentication
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        authMessages: _getAuthMessages(),
        options: authOptions,
      );

      if (!isAuthenticated) {
        throw BiometricAuthException(
          'Biometric authentication failed',
          BiometricAuthErrorType.failed,
        );
      }

      return true;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    } catch (e) {
      if (e is BiometricAuthException) rethrow;
      throw BiometricAuthException(
        'Unexpected error during authentication: ${e.toString()}',
        BiometricAuthErrorType.unknown,
      );
    }
  }

  /// Authenticate with retry logic
  /// Keeps trying until authentication succeeds or user cancels
  Future<bool> authenticateWithRetry({
    String localizedReason = 'Please authenticate to proceed',
    String retryMessage = 'Authentication failed. Please try again.',
    int? maxAttempts,
  }) async {
    int attempts = 0;

    while (maxAttempts == null || attempts < maxAttempts) {
      attempts++;

      try {
        final result = await authenticate(
          localizedReason: attempts > 1
              ? '$retryMessage (Attempt $attempts)'
              : localizedReason,
          useErrorDialogs: true,
          stickyAuth: true,
        );

        if (result) {
          return true;
        }
      } on BiometricAuthException catch (e) {
        // Don't retry on certain errors
        if (e.type == BiometricAuthErrorType.cancelled ||
            e.type == BiometricAuthErrorType.permanentlyLockedOut ||
            e.type == BiometricAuthErrorType.notAvailable ||
            e.type == BiometricAuthErrorType.notEnrolled) {
          rethrow;
        }

        // If max attempts reached, throw error
        if (maxAttempts != null && attempts >= maxAttempts) {
          throw BiometricAuthException(
            'Maximum authentication attempts reached',
            BiometricAuthErrorType.failed,
          );
        }

        // Continue to next attempt
        continue;
      }
    }

    return false;
  }

  /// Stop authentication
  Future<bool> stopAuthentication() async {
    try {
      return await _localAuth.stopAuthentication();
    } catch (e) {
      return false;
    }
  }

  /// Get authentication messages for different platforms
  List<AuthMessages> _getAuthMessages() {
    return const [
      AndroidAuthMessages(
        signInTitle: 'Biometric Authentication',
        cancelButton: 'Cancel',
        biometricHint: 'Verify your identity',
        biometricNotRecognized: 'Not recognized, try again',
        biometricRequiredTitle: 'Biometric authentication required',
        biometricSuccess: 'Authentication successful',
        deviceCredentialsRequiredTitle: 'Device credentials required',
        deviceCredentialsSetupDescription:
            'Please set up device credentials to use biometric authentication',
        goToSettingsButton: 'Go to Settings',
        goToSettingsDescription:
            'Please set up biometric authentication in Settings',
      ),
      IOSAuthMessages(
        cancelButton: 'Cancel',
        goToSettingsButton: 'Go to Settings',
        goToSettingsDescription:
            'Please set up biometric authentication in Settings',
        lockOut: 'Please re-enable biometric authentication',
      ),
    ];
  }

  /// Handle platform exceptions and convert to BiometricAuthException
  BiometricAuthException _handlePlatformException(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
        return BiometricAuthException(
          'Biometric authentication is not available',
          BiometricAuthErrorType.notAvailable,
        );
      case 'NotEnrolled':
        return BiometricAuthException(
          'No biometric credentials are enrolled',
          BiometricAuthErrorType.notEnrolled,
        );
      case 'PasscodeNotSet':
        return BiometricAuthException(
          'Passcode is not set on the device',
          BiometricAuthErrorType.notAvailable,
        );
      case 'LockedOut':
        return BiometricAuthException(
          'Too many failed attempts. Please try again later.',
          BiometricAuthErrorType.lockedOut,
        );
      case 'PermanentlyLockedOut':
        return BiometricAuthException(
          'Biometric authentication is permanently locked. Please use device credentials.',
          BiometricAuthErrorType.permanentlyLockedOut,
        );
      case 'UserCancel':
      case 'SystemCancel':
        return BiometricAuthException(
          'Authentication was cancelled',
          BiometricAuthErrorType.cancelled,
        );
      default:
        return BiometricAuthException(
          'Authentication error: ${e.message}',
          BiometricAuthErrorType.unknown,
        );
    }
  }
}
