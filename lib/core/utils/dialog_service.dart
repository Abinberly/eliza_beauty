import 'package:flutter/material.dart';

class DialogService {
  static void show({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
  }) {
    // Use the root navigator to ensure proper overlay
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }
}
