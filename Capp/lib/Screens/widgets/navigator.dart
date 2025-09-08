import 'package:flutter/material.dart';
import 'package:ironingboy/main.dart';


class SafeNavigator {
  static bool _isNavigating = false;

  static Future<T?> push<T extends Object?>(Route<T> route) async {
    if (_isNavigating) return null;
    final nav = navigatorKey.currentState;
    if (nav == null || !nav.mounted) return null;

    _isNavigating = true;
    try {
      final result = await nav.push(route);
      return result;
    } finally {
      _isNavigating = false;
    }
  }
  static void pop<T extends Object?>([T? result]) {
    final nav = navigatorKey.currentState;
    if (nav?.canPop() ?? false) {
      nav?.pop(result);
    }
  }
}
