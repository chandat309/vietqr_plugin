import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/enums/authentication_type.dart';
import 'package:viet_qr_plugin/services/shared_preferences/account_helper.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/base_api.dart';
import 'package:viet_qr_plugin/utils/log.dart';
// import 'dart:js' as js;

class LogoutRepository {
  const LogoutRepository();

  Future<bool> logout() async {
    bool result = false;
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/logout';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {'fcmToken': ''},
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        await _resetServices().then((value) => result = true);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<void> _resetServices() async {
    await UserHelper.instance.initialUserInformationHelper();
    await AccountHelper.instance.initialAccountHelper();
  }
}
