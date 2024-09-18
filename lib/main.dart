import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viet_qr_plugin/features/home/views/home_view.dart';
import 'package:viet_qr_plugin/features/login/views/login_view.dart';
import 'package:viet_qr_plugin/navigator/app_navigator.dart';
import 'package:viet_qr_plugin/services/shared_preferences/account_helper.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/services/socket_services.dart/socket_service.dart';
import 'package:window_manager/window_manager.dart';
// import 'dart:js' as js;

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPrefs = await SharedPreferences.getInstance();
  await _initialServiceHelper();
  //

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1024, 768),
    fullScreen: false,
    minimumSize: Size(800, 600),
    maximumSize: Size(1024, 768),
    center: true,
    windowButtonVisibility: true,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setTitle('VietQR VN');
  });
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

  SocketService.instance.init();

  if (notificationController.isClosed) {
    notificationController = BehaviorSubject<bool>();
  }
}

var notificationController = BehaviorSubject<bool>();

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
      // js.context.callMethod('setUserId', [UserHelper.instance.getUserId()]);
      // js.context.callMethod('setToken', [AccountHelper.instance.getToken()]);
      // List<String> listBankId = await UserHelper.instance.retrieveList();
      // js.context.callMethod(
      //     'setListBankEnableVoiceId', [jsonEncode(listBankId)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi'),
      ],
      initialRoute: '/',
      onGenerateRoute: NavigationService.onIniRoute,
      home: _mainScreen,
    );
  }
}
