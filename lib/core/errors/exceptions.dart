// 文件：lib/core/errors/exceptions.dart
// 架构：核心错误 - 异常
// 用途：针对不同错误场景的自定义异常

class AppException implements Exception {
  final String message;
  final int? code;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.code, this.stackTrace});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

// Network exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.stackTrace});
}

class TimeoutException extends NetworkException {
  const TimeoutException(super.message, {super.stackTrace}) : super(code: 408);
}

class ConnectionException extends NetworkException {
  const ConnectionException(super.message, {super.stackTrace}) : super(code: 0);
}

// API exceptions
class ApiException extends AppException {
  const ApiException(super.message, {super.code, super.stackTrace});
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message, {super.stackTrace})
    : super(code: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(super.message, {super.stackTrace})
    : super(code: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message, {super.stackTrace}) : super(code: 404);
}

class BadRequestException extends ApiException {
  const BadRequestException(super.message, {super.stackTrace})
    : super(code: 400);
}

class ServerException extends ApiException {
  const ServerException(super.message, {super.stackTrace}) : super(code: 500);
}

// Data exceptions
class DataException extends AppException {
  const DataException(super.message, {super.code, super.stackTrace});
}

class ParsingException extends DataException {
  const ParsingException(super.message, {super.stackTrace}) : super(code: 422);
}

class SerializationException extends DataException {
  const SerializationException(super.message, {super.stackTrace})
    : super(code: 422);
}

class CacheException extends DataException {
  const CacheException(super.message, {super.stackTrace}) : super(code: 500);
}

// Authentication exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.stackTrace});
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException(super.message, {super.stackTrace})
    : super(code: 401);
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException(super.message, {super.stackTrace})
    : super(code: 401);
}

class AccountLockedException extends AuthException {
  const AccountLockedException(super.message, {super.stackTrace})
    : super(code: 423);
}

// Validation exceptions
class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException(super.message, this.errors, {super.stackTrace})
    : super(code: 422);

  @override
  String toString() => 'ValidationException: $message\nErrors: $errors';
}

// Permission exceptions
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code, super.stackTrace});
}

class LocationPermissionException extends PermissionException {
  const LocationPermissionException(super.message, {super.stackTrace})
    : super(code: 403);
}

class MockLocationException extends PermissionException {
  final MockLocationDetectionMethod detectionMethod;
  final Map<String, dynamic>? details;

  const MockLocationException(
    super.message, {
    required this.detectionMethod,
    this.details,
    super.stackTrace,
  }) : super(code: 403);

  @override
  String toString() =>
      'MockLocationException: $message (Method: ${detectionMethod.name})';
}

enum MockLocationDetectionMethod {
  isMockFlag,
  accuracyAnomaly,
  temporalInconsistency,
  multipleSampleDeviation,
  platformChannel,
  appSignature,
  speedAnomaly,
  altitudeAnomaly,
}

class CameraPermissionException extends PermissionException {
  const CameraPermissionException(super.message, {super.stackTrace})
    : super(code: 403);
}

class StoragePermissionException extends PermissionException {
  const StoragePermissionException(super.message, {super.stackTrace})
    : super(code: 403);
}

// Platform exceptions
class PlatformException extends AppException {
  const PlatformException(super.message, {super.code, super.stackTrace});
}

// Business logic exceptions
class BusinessException extends AppException {
  const BusinessException(super.message, {super.code, super.stackTrace});
}

class InsufficientFundsException extends BusinessException {
  const InsufficientFundsException(super.message, {super.stackTrace})
    : super(code: 402);
}

class ResourceNotFoundException extends BusinessException {
  const ResourceNotFoundException(super.message, {super.stackTrace})
    : super(code: 404);
}

// Helper function to convert any exception to AppException
AppException toAppException(dynamic error, StackTrace stackTrace) {
  if (error is AppException) {
    return error;
  } else if (error is FormatException) {
    return ParsingException(error.message, stackTrace: stackTrace);
  } else if (error is ArgumentError) {
    return ValidationException(error.message, {}, stackTrace: stackTrace);
  } else if (error is TypeError) {
    return SerializationException(error.toString(), stackTrace: stackTrace);
  } else {
    return AppException(error.toString(), stackTrace: stackTrace);
  }
}
