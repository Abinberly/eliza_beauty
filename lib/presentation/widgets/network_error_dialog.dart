import 'package:flutter/material.dart';
import 'package:eliza_beauty/core/l10n/app_localizations.dart';

class NetworkErrorDialog extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const NetworkErrorDialog({
    super.key,
    this.onRetry,
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NetworkErrorDialog(
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            color: Theme.of(context).colorScheme.error,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(l10n?.networkErrorTitle ?? '', textAlign: .center,),
        ],
      ),
      content: Text(l10n?.networkErrorMessage ?? '', textAlign: .center,),
      actions: [
        if (onDismiss != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(l10n?.networkErrorDismiss ?? ""),
          ),
        if (onRetry != null)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry?.call();
            },
            child: Text(l10n?.networkErrorRetry ?? ""),
          ),
      ],
    );
  }
}
