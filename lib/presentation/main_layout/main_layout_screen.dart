import 'package:eliza_beauty/core/network/connectivity_provider.dart';
import 'package:eliza_beauty/core/utils/alert_service.dart';
import 'package:eliza_beauty/presentation/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainLayoutScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayoutScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends ConsumerState<MainLayoutScreen> {
  bool _wasOnline = true;

  @override
  void initState() {
    super.initState();
    // Check initial connectivity after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isOnline = ref.read(connectivityNotifierProvider);
      if (!isOnline) {
        AlertService.showNoInternetDialog(context);
      }
      _wasOnline = isOnline;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(connectivityNotifierProvider, (previous, isOnline) {
      // Show popup only when transitioning from online to offline
      if (_wasOnline && !isOnline) {
        AlertService.showNoInternetDialog(context);
      }
      _wasOnline = isOnline;
    });

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: CustomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
      ),
      extendBody: true,
    );
  }
}
