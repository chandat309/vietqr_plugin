import 'dart:convert';
// import 'dart:js' as js;
import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/enums/authentication_type.dart';
import 'package:viet_qr_plugin/models/bank_notify_dto.dart';
import 'package:viet_qr_plugin/models/bank_type_enable_dto.dart';
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

  Future<List<BankEnableType>> getListBankNotify() async {
    List<BankEnableType> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}bank-notification/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        // js.context.callMethod('setListBankNotify', [response.body]);
        var data = jsonDecode(response.body);
        list = data
            .map<BankEnableType>((json) => BankEnableType.fromJson(json))
            .toList();
      } else {
        // js.context.callMethod('setListBankNotify', ['']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return list;
  }

  Future<bool> setListBankNotify(String bankId, List<String> types) async {
    try {
      Map<String, dynamic> data = {};
      data['userId'] = userId;
      data['bankId'] = bankId;
      data['notificationTypes'] = types;

      String url = '${EnvConfig.getBaseUrl()}bank-notification/update';
      final response = await BaseAPIClient.postAPI(
        body: data,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
      } else {}
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool> setNotificationBDSD(int value) async {
    try {
      Map<String, dynamic> body = {};
      body['value'] = value;
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/user/$userId/update-noti';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool> setBankNotiBDSD(String bankId, int value) async {
    try {
      Map<String, dynamic> body = {};
      body['value'] = value;
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/update-noti/$bankId';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool> enableVoiceSetting(Map<String, dynamic> param) async {
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/sound-noti/enable';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
      return false;
    }
  }
}
