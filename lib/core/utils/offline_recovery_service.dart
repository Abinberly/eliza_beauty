import 'dart:async';
import 'dart:convert';
import '../../core/utils/error_handler.dart';
import '../../data/local/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Offline operation queue item
class OfflineOperation {

  factory OfflineOperation.fromMap(Map<String, dynamic> map) {
    return OfflineOperation(
      id: map['id'],
      operationType: map['operationType'],
      data: jsonDecode(map['data']),
      createdAt: DateTime.parse(map['createdAt']),
      retryCount: map['retryCount'] ?? 0,
      lastRetryAt: map['lastRetryAt'] != null ? DateTime.parse(map['lastRetryAt']) : null,
    );
  }

  const OfflineOperation({
    required this.id,
    required this.operationType,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.lastRetryAt,
  });
  final String id;
  final String operationType;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;
  final DateTime? lastRetryAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operationType': operationType,
      'data': jsonEncode(data),
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'lastRetryAt': lastRetryAt?.toIso8601String(),
    };
  }
}

/// Offline recovery service for handling operations when offline
class OfflineRecoveryService {
  static final List<OfflineOperation> _pendingOperations = [];
  static Timer? _syncTimer;
  static bool _isInitialized = false;
  static const Duration _syncInterval = Duration(minutes: 30);
  static const int _maxRetryCount = 5;

  /// Initialize the offline recovery service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadPendingOperations();
      _startSyncTimer();
      _isInitialized = true;
    } catch (error) {
      ErrorAnalytics.reportError(
        AppError.unknown(
          message: 'Failed to initialize offline recovery service',
          originalError: error,
        ),
      );
    }
  }

  /// Queue an operation for offline execution
  static Future<void> queueOperation({
    required String operationType,
    required Map<String, dynamic> data,
  }) async {
    final operation = OfflineOperation(
      id: _generateOperationId(),
      operationType: operationType,
      data: data,
      createdAt: DateTime.now(),
    );

    _pendingOperations.add(operation);
    await _savePendingOperations();

    ErrorAnalytics.reportError(
      AppError.network(
        message: 'Operation queued for offline execution',
        code: 'OFFLINE_QUEUE',
        context: {
          'operationType': operationType,
          'operationId': operation.id,
        },
      ),
    );
  }

  /// Execute operation with offline-first approach
  static Future<Result<T>> executeOfflineFirst<T>(
    Future<T> Function() onlineOperation,
    T Function() offlineOperation, {
    String? operationType,
    Map<String, dynamic>? operationData,
    bool queueForLater = true,
  }) async {
    // Try online operation first
    final onlineResult = await ErrorHandler.executeWithRetry(
      onlineOperation,
      config: const RetryConfig(
        maxAttempts: 2,
        initialDelay: Duration(seconds: 1),
      ),
      context: {
        'operationType': operationType,
        'offlineFirst': true,
      },
    );

    return onlineResult.fold(
      (data) => Result.success(data),
      (error) async {
        // If network error, try offline operation
        if (error.type == ErrorType.network) {
          try {
            final offlineData = offlineOperation();
            
            // Queue operation for later sync if needed
            if (queueForLater && operationType != null && operationData != null) {
              await queueOperation(
                operationType: operationType,
                data: {
                  ...operationData,
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
            }
            
            return Result.success(offlineData);
          } catch (offlineError) {
            final appError = AppError.unknown(
              message: 'Offline operation failed',
              originalError: offlineError,
              context: {
                'operationType': operationType,
                'originalError': error.toMap(),
              },
            );
            ErrorAnalytics.reportError(appError);
            return Result.failure(appError);
          }
        }
        return Result.failure(error);
      },
    );
  }

  /// Sync pending operations when online
  static Future<void> syncPendingOperations() async {
    if (_pendingOperations.isEmpty) return;

    final operationsToSync = List<OfflineOperation>.from(_pendingOperations);
    final successfulOperations = <String>[];
    final failedOperations = <OfflineOperation>[];

    for (final operation in operationsToSync) {
      try {
        final success = await _executeOperation(operation);
        if (success) {
          successfulOperations.add(operation.id);
        } else {
          failedOperations.add(operation);
        }
      } catch (error) {
        failedOperations.add(operation.copyWith(
          retryCount: operation.retryCount + 1,
          lastRetryAt: DateTime.now(),
        ));
      }
    }

    // Update pending operations
    _pendingOperations.removeWhere((op) => successfulOperations.contains(op.id));
    _pendingOperations.addAll(failedOperations);

    // Remove operations that exceeded max retry count
    _pendingOperations.removeWhere((op) => op.retryCount >= _maxRetryCount);

    await _savePendingOperations();

    // Report sync results
    if (successfulOperations.isNotEmpty) {
      ErrorAnalytics.reportError(
        AppError.network(
          message: 'Successfully synced ${successfulOperations.length} operations',
          code: 'SYNC_SUCCESS',
          context: {
            'syncedCount': successfulOperations.length,
            'failedCount': failedOperations.length,
          },
        ),
      );
    }
  }

  /// Execute a single operation
  static Future<bool> _executeOperation(OfflineOperation operation) async {
    try {
      switch (operation.operationType) {
        case 'cart_add':
          return await _executeCartAdd(operation);
        case 'cart_remove':
          return await _executeCartRemove(operation);
        case 'cart_update':
          return await _executeCartUpdate(operation);
        case 'user_profile_update':
          return await _executeUserProfileUpdate(operation);
        default:
          return false;
      }
    } catch (error) {
      ErrorAnalytics.reportError(
        AppError.unknown(
          message: 'Failed to execute offline operation',
          originalError: error,
          context: {
            'operationId': operation.id,
            'operationType': operation.operationType,
          },
        ),
      );
      return false;
    }
  }

  static Future<bool> _executeCartAdd(OfflineOperation operation) async {
    // Implementation for cart add operation
    // This would integrate with the actual cart provider
    return true;
  }

  static Future<bool> _executeCartRemove(OfflineOperation operation) async {
    // Implementation for cart remove operation
    return true;
  }

  static Future<bool> _executeCartUpdate(OfflineOperation operation) async {
    // Implementation for cart update operation
    return true;
  }

  static Future<bool> _executeUserProfileUpdate(OfflineOperation operation) async {
    // Implementation for user profile update operation
    return true;
  }

  /// Get pending operations count
  static int get pendingOperationsCount => _pendingOperations.length;

  /// Get pending operations by type
  static List<OfflineOperation> getPendingOperationsByType(String operationType) {
    return _pendingOperations.where((op) => op.operationType == operationType).toList();
  }

  /// Clear all pending operations
  static Future<void> clearPendingOperations() async {
    _pendingOperations.clear();
    await _savePendingOperations();
  }

  /// Start periodic sync timer
  static void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(_syncInterval, (timer) {
      syncPendingOperations();
    });
  }

  /// Stop sync timer
  static void stopSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Load pending operations from storage
  static Future<void> _loadPendingOperations() async {
    try {
      final database = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await database.query('offline_operations');
      
      _pendingOperations.clear();
      for (final map in maps) {
        _pendingOperations.add(OfflineOperation.fromMap(map));
      }
    } catch (error) {
      ErrorAnalytics.reportError(
        AppError.unknown(
          message: 'Failed to load pending operations',
          originalError: error,
        ),
      );
    }
  }

  /// Save pending operations to storage
  static Future<void> _savePendingOperations() async {
    try {
      final database = await DatabaseHelper.instance.database;
      
      // Clear existing operations
      await database.delete('offline_operations');
      
      // Save current operations
      for (final operation in _pendingOperations) {
        await database.insert('offline_operations', operation.toMap());
      }
    } catch (error) {
      ErrorAnalytics.reportError(
        AppError.unknown(
          message: 'Failed to save pending operations',
          originalError: error,
        ),
      );
    }
  }

  /// Generate unique operation ID
  static String _generateOperationId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_pendingOperations.length}';
  }

  /// Dispose the service
  static void dispose() {
    stopSyncTimer();
    _isInitialized = false;
  }
}

/// Extension for OfflineOperation to create copy with modifications
extension OfflineOperationExtension on OfflineOperation {
  OfflineOperation copyWith({
    String? id,
    String? operationType,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    int? retryCount,
    DateTime? lastRetryAt,
  }) {
    return OfflineOperation(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastRetryAt: lastRetryAt ?? this.lastRetryAt,
    );
  }
}

/// Provider for offline recovery service
final offlineRecoveryServiceProvider = Provider<OfflineRecoveryService>((ref) {
  return OfflineRecoveryService();
});
