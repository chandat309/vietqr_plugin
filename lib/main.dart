import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viet_qr_plugin/features/home/views/home_view.dart';
import 'package:viet_qr_plugin/features/login/views/login_view.dart';
import 'package:viet_qr_plugin/navigator/app_navigator.dart';
import 'package:viet_qr_plugin/services/shared_preferences/account_helper.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/services/socket_services.dart/socket_service.dart';
import 'dart:js' as js;

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await _initialServiceHelper();
  //
  runApp(const VietQRPlugin());
}

Future<void> _initialServiceHelper() async {
  if (!sharedPrefs.containsKey('TOKEN') ||
      sharedPrefs.getString('TOKEN') == null) {
    await AccountHelper.instance.initialAccountHelper();
  }
  if (!sharedPrefs.containsKey('USER_ID') ||
      sharedPrefs.getString('USER_ID') == null) {
    await UserHelper.instance.initialUserInformationHelper();
  }
}

class VietQRPlugin extends StatefulWidget {
  const VietQRPlugin({super.key});

  @override
  State<StatefulWidget> createState() => _VietQRPlugin();
}

class _VietQRPlugin extends State<VietQRPlugin> {
  static Widget _mainScreen = const LoginView();

  String get userId => UserHelper.instance.getUserId().trim();
  String token = AccountHelper.instance.getToken() ?? '';

  @override
  void initState() {
    super.initState();
    // SocketService.instance.init();
    _mainScreen = (userId.isNotEmpty) ? const HomeView() : const LoginView();

    if (userId.isNotEmpty && token.isNotEmpty) {
      js.context.callMethod('setUserId', [UserHelper.instance.getUserId()]);
      js.context.callMethod('setToken', [AccountHelper.instance.getToken()]);
      js.context.callMethod('setListBankEnableVoiceId',
          [jsonEncode(UserHelper.instance.retrieveList())]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: NavigationService.onIniRoute,
      home: _mainScreen,
    );
  }
}
