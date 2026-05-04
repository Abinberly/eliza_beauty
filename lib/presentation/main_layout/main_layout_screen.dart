import '../../core/network/connectivity_provider.dart';
import '../../core/utils/alert_service.dart';
import '../components/navigation/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainLayoutScreen extends ConsumerStatefulWidget {

  const MainLayoutScreen({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends ConsumerState<MainLayoutScreen> {
  bool _wasOnline = true;

  @override
  void initState() {
    super.initState();

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
