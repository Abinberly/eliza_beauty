import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/dialog_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/network/connectivity_provider.dart';

class NetworkErrorDialog extends ConsumerStatefulWidget {

  const NetworkErrorDialog({
    super.key,
    this.onRetry,
    this.onDismiss,
    this.customMessage,
    this.errorType,
  });
  final Future<void> Function()? onRetry;
  final VoidCallback? onDismiss;
  final String? customMessage;
  final ErrorType? errorType;

  static Future<void> show(
    BuildContext context, {
    Future<void> Function()? onRetry,
    VoidCallback? onDismiss,
    String? customMessage,
    ErrorType? errorType,
  }) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return Future.value();
    
    return DialogService.show(
      context: context,
      barrierDismissible: false,
      builder: (context) => NetworkErrorDialog(
        onRetry: onRetry,
        onDismiss: onDismiss,
        customMessage: customMessage,
        errorType: errorType,
      ),
    );
  }

  @override
  ConsumerState<NetworkErrorDialog> createState() => _NetworkErrorDialogState();
}

class _NetworkErrorDialogState extends ConsumerState<NetworkErrorDialog> {
  bool _isRetrying = false;
  int _currentRetryAttempt = 0;
  String? _retryMessage;
  bool _isOfflineMode = false;

  @override
  void initState() {
    super.initState();
    _checkOfflineStatus();
  }

  void _checkOfflineStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final isConnected = ref.read(connectivityNotifierProvider);
        setState(() {
          _isOfflineMode = !isConnected;
        });
      }
    });
  }

  Future<void> _handleRetry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
      _currentRetryAttempt++;
      _retryMessage = null;
    });

    try {
      final result = await ErrorHandler.executeWithRetry(
        () async {
          if (widget.onRetry != null) {
            await widget.onRetry!();
          } else {
            await ref.read(connectivityNotifierProvider.notifier).refresh();
          }
          return true;
        },
        config: const RetryConfig(
          maxAttempts: 3,
          initialDelay: Duration(seconds: 1),
          backoffMultiplier: 2.0,
        ),
        context: {
          'retryAttempt': _currentRetryAttempt,
          'dialogContext': 'NetworkErrorDialog',
        },
      );

      result.fold(
      (_) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(ref.context.l10n.errorCacheCleared),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      (error) {
        if (mounted) {
          setState(() {
            _isRetrying = false;
            _retryMessage = ErrorHandler.getUserFriendlyMessage(error);
            _isOfflineMode = error.type == ErrorType.network;
          });
        }
      },
    );
    } catch (error) {
      if (mounted) {
        setState(() {
          _isRetrying = false;
          _retryMessage = ErrorHandler.getUserFriendlyMessage(
            AppError.unknown(message: error.toString()),
          );
        });
      }
    }
  }

  String _getErrorMessage() {
    if (widget.customMessage != null) {
      return widget.customMessage!;
    }

    final l10n = AppLocalizations.of(context);
    
    switch (widget.errorType) {
      case ErrorType.network:
        if (_isOfflineMode) {
          return l10n!.errorOfflineMode;
        }
        return l10n!.errorNetworkGeneral;
      case ErrorType.server:
        return l10n!.errorServerUnavailable;
      case ErrorType.authentication:
        return l10n!.errorAuthFailed;
      case ErrorType.validation:
        return l10n!.errorValidation;
      default:
        return l10n!.errorUnknown;
    }
  }

  String _getRetryMessage() {
    if (_retryMessage != null) {
      return _retryMessage!;
    }
    
    if (_currentRetryAttempt > 0) {
      final l10n = AppLocalizations.of(context);
      return l10n!.errorRetryAttempt(_currentRetryAttempt, 3);
    }
    
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return PopScope(
      canPop: widget.onDismiss != null,
      child: AlertDialog(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isOfflineMode ? Icons.wifi_off : Icons.error_outline,
              color: _isOfflineMode ? Colors.orange : theme.colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _isOfflineMode 
                  ? l10n!.networkErrorTitle
                  : l10n!.somethingWentWrong,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getErrorMessage(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (_getRetryMessage().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _getRetryMessage(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            if (_isRetrying) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.errorRecoveringConnection,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          if (widget.onDismiss != null && !_isRetrying)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDismiss?.call();
              },
              child: Text(l10n.networkErrorDismiss),
            ),
          if (widget.onRetry != null && !_isRetrying)
            ElevatedButton.icon(
              onPressed: _handleRetry,
              icon: const Icon(Icons.refresh),
              label: Text(
                _currentRetryAttempt > 0 
                    ? '${l10n.networkErrorRetry} ($_currentRetryAttempt/3)'
                    : l10n.networkErrorRetry,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
