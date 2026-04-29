import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../../features/user_management/reset_password_screen.dart';

class DeepLinkService {
  DeepLinkService._internal();
  static final DeepLinkService instance = DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  late GlobalKey<NavigatorState> navigatorKey;

  // Store the pending URI if app isn't ready yet
  Uri? _pendingUri;

  void init(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Cold start
    final Uri? initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _pendingUri = initialUri;
    }

    // Foreground / warm start — fires when singleTask routes to existing app
    _sub = _appLinks.uriLinkStream.listen((uri) {
      debugPrint("STREAM LINK: $uri");
      _handleUri(uri);  // this already works correctly
    });
  }

  // Call this from your WelcomePage (or wherever your first route lands)
  void handlePendingLink() {
    if (_pendingUri != null) {
      final uri = _pendingUri!;
      _pendingUri = null;
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleUri(uri);
      });
    }
  }

  void _handleUri(Uri uri) {
    final mode = uri.queryParameters['mode'];
    final oobCode = uri.queryParameters['oobCode'];
    debugPrint("DEEP LINK HIT: $uri");
    debugPrint("MODE: $mode | OOB: $oobCode");

    if (mode == 'resetPassword' && oobCode != null && oobCode.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(oobCode: oobCode),
          ),
        );
      });
    }
  }

  void dispose() {
    _sub?.cancel();
  }

}