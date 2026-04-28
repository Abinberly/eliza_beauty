import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eliza_beauty/core/network/network_info.dart';

part 'connectivity_provider.g.dart';

@Riverpod(keepAlive: true)
class ConnectivityNotifier extends _$ConnectivityNotifier {
  late final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _periodicCheckTimer;

  @override
  bool build() {
    _connectivity = Connectivity();

    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      final hasBasicConnectivity = _hasBasicConnectivity(results);
      
      if (hasBasicConnectivity) {
        final hasInternetAccess = await _checkInternetAccess();
        if (state != hasInternetAccess) {
          state = hasInternetAccess;
        }
      } else {
        if (state != false) {
          state = false;
        }
      }
    });

    _checkInitialConnectivity();
    
    _startPeriodicCheck();

    ref.onDispose(() {
      _subscription?.cancel();
      _periodicCheckTimer?.cancel();
    });

    return true;
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasBasicConnectivity = _hasBasicConnectivity(results);
      
      if (hasBasicConnectivity) {
        state = await _checkInternetAccess();
      } else {
        state = false;
      }
    } catch (e) {
      state = false;
    }
  }

  bool _hasBasicConnectivity(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet);
  }

  Future<bool> _checkInternetAccess() async {
    try {
      return await NetworkInfo.isConnected();
    } catch (e) {
      return false;
    }
  }

  Future<void> refresh() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasBasicConnectivity = _hasBasicConnectivity(results);
      
      if (hasBasicConnectivity) {
        state = await _checkInternetAccess();
      } else {
        state = false;
      }
    } catch (e) {
      state = false;
    }
  }

  void _startPeriodicCheck() {
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!state) {
        final hasInternetAccess = await _checkInternetAccess();
        if (hasInternetAccess && state != hasInternetAccess) {
          state = hasInternetAccess;
        }
      }
    });
  }
}
