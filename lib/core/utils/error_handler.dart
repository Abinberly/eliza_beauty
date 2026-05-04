import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

/// Error types for categorization
enum ErrorType {
  network,
  server,
  authentication,
  validation,
  unknown,
}

/// Error severity levels
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

/// Custom error class with enhanced metadata
class AppError {

  factory AppError.authentication({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      message: message,
      type: ErrorType.authentication,
      severity: ErrorSeverity.high,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      context: context,
    );
  }

  const AppError({
    required this.message,
    required this.type,
    required this.severity,
    this.code,
    this.originalError,
    this.stackTrace,
    required this.timestamp,
    this.context,
  });

  factory AppError.network({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      message: message,
      type: ErrorType.network,
      severity: _determineNetworkSeverity(originalError),
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      context: context,
    );
  }

  factory AppError.server({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      message: message,
      type: ErrorType.server,
      severity: _determineServerSeverity(originalError),
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      context: context,
    );
  }

  factory AppError.unknown({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      message: message,
      type: ErrorType.unknown,
      severity: ErrorSeverity.medium,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      context: context,
    );
  }

  factory AppError.validation({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      message: message,
      type: ErrorType.validation,
      severity: ErrorSeverity.low,
      code: code,
      originalError: originalError,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      context: context,
    );
  }
  final String message;
  final ErrorType type;
  final ErrorSeverity severity;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final Map<String, dynamic>? context;

  static ErrorSeverity _determineNetworkSeverity(dynamic error) {
    if (error is SocketException) {
      return ErrorSeverity.high;
    } else if (error is HttpException) {
      return ErrorSeverity.medium;
    } else if (error is TimeoutException) {
      return ErrorSeverity.medium;
    }
    return ErrorSeverity.low;
  }

  static ErrorSeverity _determineServerSeverity(dynamic error) {
    if (error is HttpException) {
      return ErrorSeverity.medium;
    }
    return ErrorSeverity.high;
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'type': type.name,
      'severity': severity.name,
      'code': code,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
      'originalError': originalError?.toString(),
    };
  }
}

/// Retry configuration with exponential backoff
class RetryConfig {

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.timeout = const Duration(seconds: 30),
  });
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;
  final Duration timeout;

  Duration getDelay(int attempt) {
    final delay = initialDelay * math.pow(backoffMultiplier, attempt - 1);
    return delay > maxDelay ? maxDelay : delay;
  }
}

/// Result wrapper for operations that might fail
class Result<T> {

  const Result._({this.data, this.error, required this.isSuccess});

  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  factory Result.failure(AppError error) {
    return Result._(error: error, isSuccess: false);
  }
  final T? data;
  final AppError? error;
  final bool isSuccess;

  R fold<R>(R Function(T data) onSuccess, R Function(AppError error) onFailure) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    } else if (!isSuccess && error != null) {
      return onFailure(error!);
    } else {
      throw StateError('Invalid Result state');
    }
  }

  Result<U> map<U>(U Function(T data) mapper) {
    if (isSuccess && data != null) {
      return Result.success(mapper(data as T));
    } else {
      return Result.failure(error!);
    }
  }
}

/// Error analytics service
class ErrorAnalytics {
  static final List<AppError> _errors = [];
  static const int _maxStoredErrors = 1000;

  static void reportError(AppError error) {
    _errors.add(error);
    if (_errors.length > _maxStoredErrors) {
      _errors.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint('Error reported: ${error.toMap()}');
    }
  }

  static List<AppError> getRecentErrors({Duration? since}) {
    final cutoff = since != null ? DateTime.now().subtract(since) : null;
    return _errors.where((error) => 
        cutoff == null || error.timestamp.isAfter(cutoff)
    ).toList();
  }

  static Map<ErrorType, int> getErrorCounts() {
    final counts = <ErrorType, int>{};
    for (final error in _errors) {
      counts[error.type] = (counts[error.type] ?? 0) + 1;
    }
    return counts;
  }

  static void clearErrors() {
    _errors.clear();
  }
}

/// Main error handler service
class ErrorHandler {
  static const RetryConfig _defaultConfig = RetryConfig();

  /// Execute operation with retry logic and exponential backoff
  static Future<Result<T>> executeWithRetry<T>(
    Future<T> Function() operation, {
    RetryConfig? config,
    String? operationName,
    Map<String, dynamic>? context,
  }) async {
    final retryConfig = config ?? _defaultConfig;
    AppError? lastError;

    for (int attempt = 1; attempt <= retryConfig.maxAttempts; attempt++) {
      try {
        final result = await operation().timeout(retryConfig.timeout);
        return Result.success(result);
      } catch (error, stackTrace) {
        lastError = _convertToAppError(error, stackTrace, context);
        
        ErrorAnalytics.reportError(lastError);

        // Don't retry on certain error types
        if (_shouldNotRetry(lastError.type)) {
          return Result.failure(lastError);
        }

        // If this is the last attempt, return failure
        if (attempt == retryConfig.maxAttempts) {
          return Result.failure(lastError);
        }

        // Wait before retrying with exponential backoff
        final delay = retryConfig.getDelay(attempt);
        await Future.delayed(delay);
      }
    }

    return Result.failure(lastError!);
  }

  /// Execute operation with offline-first approach
  static Future<Result<T>> executeOfflineFirst<T>(
    Future<T> Function() onlineOperation,
    T Function() offlineOperation, {
    RetryConfig? config,
    String? operationName,
    Map<String, dynamic>? context,
  }) async {
    // Try online operation first
    final onlineResult = await executeWithRetry(
      onlineOperation,
      config: config,
      operationName: operationName,
      context: context,
    );

    return onlineResult.fold(
      (data) => Result.success(data),
      (error) {
        // If network error, try offline operation
        if (error.type == ErrorType.network) {
          try {
            final offlineData = offlineOperation();
            return Result.success(offlineData);
          } catch (offlineError, offlineStack) {
            final appError = AppError.unknown(
              message: 'Offline operation failed',
              originalError: offlineError,
              stackTrace: offlineStack,
              context: context,
            );
            ErrorAnalytics.reportError(appError);
            return Result.failure(appError);
          }
        }
        return Result.failure(error);
      },
    );
  }

  /// Convert various error types to AppError
  static AppError _convertToAppError(
    dynamic error,
    StackTrace stackTrace,
    Map<String, dynamic>? context,
  ) {
    if (error is SocketException) {
      return AppError.network(
        message: 'No internet connection',
        code: 'NETWORK_ERROR',
        originalError: error,
        stackTrace: stackTrace,
        context: context,
      );
    } else if (error is HttpException) {
      return AppError.network(
        message: 'HTTP error: ${error.message}',
        code: 'HTTP_ERROR',
        originalError: error,
        stackTrace: stackTrace,
        context: context,
      );
    } else if (error is TimeoutException) {
      return AppError.network(
        message: 'Request timed out',
        code: 'TIMEOUT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
        context: context,
      );
    } else if (error is FormatException) {
      return AppError.validation(
        message: 'Data format error',
        code: 'FORMAT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
        context: context,
      );
    } else {
      return AppError.unknown(
        message: error.toString(),
        originalError: error,
        stackTrace: stackTrace,
        context: context,
      );
    }
  }

  /// Determine if error type should not be retried
  static bool _shouldNotRetry(ErrorType type) {
    return type == ErrorType.validation || type == ErrorType.authentication;
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        if (error.originalError is SocketException) {
          return 'errorNetworkNoConnection';
        } else if (error.originalError is TimeoutException) {
          return 'errorNetworkTimeout';
        } else {
          return 'errorNetworkGeneral';
        }
      case ErrorType.server:
        return 'errorServerUnavailable';
      case ErrorType.authentication:
        return 'errorAuthFailed';
      case ErrorType.validation:
        return 'errorValidation';
      case ErrorType.unknown:
        return 'errorUnknown';
    }
  }

  /// Check if error is recoverable
  static bool isRecoverable(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return true;
      case ErrorType.server:
        return error.severity != ErrorSeverity.critical;
      case ErrorType.authentication:
        return false;
      case ErrorType.validation:
        return true;
      case ErrorType.unknown:
        return error.severity != ErrorSeverity.critical;
    }
  }
}
