import 'dart:convert';

import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/enums/authentication_type.dart';
import 'package:viet_qr_plugin/models/setting_account_sto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/base_api.dart';
import 'package:viet_qr_plugin/utils/log.dart';

class SettingRepository {
  String get userId => UserHelper.instance.getUserId();

  Future<SettingAccountDTO> getSettingAccount() async {
    SettingAccountDTO result = SettingAccountDTO();
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/setting/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = SettingAccountDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }
}
