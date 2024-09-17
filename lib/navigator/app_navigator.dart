import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/route.dart';
import 'package:viet_qr_plugin/features/home/views/home_view.dart';
import 'package:viet_qr_plugin/features/setting_account/setting_account_view.dart';
import 'package:viet_qr_plugin/main.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? onIniRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.APP:
        return _buildRoute(settings, const VietQRPlugin());
      case Routes.DASHBOARD:
        return _buildRoute(settings, const HomeView());
      case Routes.SETTING:
        return _buildRoute(settings, const SettingAccountView());
      default:
        return null;
    }
  }

  static _buildRoute(
    RouteSettings routeSettings,
    Widget builder,
  ) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: (context) => builder,
        settings: routeSettings,
      );
    }
    return MaterialPageRoute(
      builder: (context) => builder,
      settings: routeSettings,
    );
  }

  static Future push<T>(
    String route, {
    Object? arguments,
  }) {
    return state.pushNamed(route, arguments: arguments);
  }

  static Future pushAndRemoveUntil<T>(
    String route, {
    Object? arguments,
  }) {
    return state.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future replaceWith<T>(
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    return state.pushReplacementNamed(route, arguments: arguments);
  }

  static void popUntil<T>(String route) {
    state.popUntil(ModalRoute.withName(route));
  }

  static Future popAndPush<T>(
    String route, {
    Object? arguments,
  }) {
    return state.popAndPushNamed(route, arguments: arguments);
  }

  static void pop([Object? arguments]) {
    if (canPop) {
      state.pop(arguments);
    }
  }

  static bool get canPop => state.canPop();

  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState get state => navigatorKey.currentState!;
}
