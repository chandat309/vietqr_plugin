import 'dart:convert';

import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/enums/authentication_type.dart';
import 'package:viet_qr_plugin/models/confirm_otp_bank_dto.dart';
import 'package:viet_qr_plugin/models/response_message_dto.dart';
import 'package:viet_qr_plugin/utils/base_api.dart';
import 'package:viet_qr_plugin/utils/log.dart';
import 'package:http/http.dart';

class LinkedRepository {
  Future<ResponseMessageDTO> requestOTP(dynamic param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${EnvConfig.getUrl()}bank/api/account-bank/linked/request_otp';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> confirmOTP(dynamic dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      Response? response;
      final String url =
          '${EnvConfig.getUrl()}bank/api/account-bank/linked/confirm_otp';
      if (dto is ConfirmOTPBidvDTO) {
        response = await BaseAPIClient.postAPI(
          url: url,
          body: dto.toJson(),
          type: AuthenticationType.SYSTEM,
        );
      }
      if (dto is ConfirmOTPBankDTO) {
        response = await BaseAPIClient.postAPI(
          url: url,
          body: dto.toJson(),
          type: AuthenticationType.SYSTEM,
        );
      }
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 400)) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
