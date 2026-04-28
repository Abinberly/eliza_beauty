import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eliza_beauty/core/network/connectivity_provider.dart';
import 'package:eliza_beauty/presentation/widgets/network_error_dialog.dart';

class NetworkConnectivityMonitor extends ConsumerStatefulWidget {
  final Widget child;

  const NetworkConnectivityMonitor({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<NetworkConnectivityMonitor> createState() =>
      _NetworkConnectivityMonitorState();
}

class _NetworkConnectivityMonitorState
    extends ConsumerState<NetworkConnectivityMonitor> {
  bool _wasConnected = true;
  bool _isDialogShowing = false;
  bool _hasShownRestorationToast = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(connectivityNotifierProvider, (previous, next) {
      // Network went offline
      if (_wasConnected && !next && !_isDialogShowing) {
        _isDialogShowing = true;
        _hasShownRestorationToast = false;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          
          NetworkErrorDialog.show(
            context,
            onRetry: () async {
              await ref.read(connectivityNotifierProvider.notifier).refresh();
              if (!mounted) return;
              
              final isNowConnected = ref.read(connectivityNotifierProvider);
              if (isNowConnected) {
                _isDialogShowing = false;
                _wasConnected = true;
                _showNetworkRestoredMessage();
              } else {
                _isDialogShowing = false;
                _retryConnectionCheck();
              }
            },
            onDismiss: () {
              _isDialogShowing = false;
              _wasConnected = false;
            },
          );
        });
      } 
      // Network came back online
      else if (!_wasConnected && next) {
        _wasConnected = true;
        _isDialogShowing = false;
        _showNetworkRestoredMessage();
      }
    });

    return widget.child;
  }

  void _retryConnectionCheck() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted || !ref.context.mounted || ref.read(connectivityNotifierProvider)) {
        return;
      }
      
      NetworkErrorDialog.show(
        ref.context,
        onRetry: () async {
          await ref.read(connectivityNotifierProvider.notifier).refresh();
          if (!ref.context.mounted) return;
          
          final isNowConnected = ref.read(connectivityNotifierProvider);
          if (isNowConnected) {
            _isDialogShowing = false;
            _wasConnected = true;
            _showNetworkRestoredMessage();
          } else {
            _isDialogShowing = false;
            _retryConnectionCheck();
          }
        },
      );
    });
  }

  void _showNetworkRestoredMessage() {
    if (_hasShownRestorationToast) return;
    _hasShownRestorationToast = true;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !ref.context.mounted) return;
      
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi, color: Colors.white),
              const SizedBox(width: 8),
              Text('Internet connection restored'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
