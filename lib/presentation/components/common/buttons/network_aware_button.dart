import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../overlays/network_error_dialog.dart';

class NetworkAwareButton extends ConsumerWidget {

  const NetworkAwareButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
    this.shouldCheckNetwork,
  });
  final Widget child;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool Function()? shouldCheckNetwork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityNotifierProvider);

    return ElevatedButton(
      style: style,
      onPressed: () {
        final checkNetwork = shouldCheckNetwork?.call() ?? true;
        
        if (checkNetwork && !isConnected) {
          NetworkErrorDialog.show(
            context,
            onRetry: () async {
              await ref.read(connectivityNotifierProvider.notifier).refresh();
              if (ref.read(connectivityNotifierProvider)) {
                onPressed();
              }
            },
          );
        } else {
          onPressed();
        }
      },
      child: child,
    );
  }
}
