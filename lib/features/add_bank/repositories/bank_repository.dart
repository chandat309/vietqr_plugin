import 'dart:convert';

import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/enums/authentication_type.dart';
import 'package:viet_qr_plugin/models/bank_account_check_dto.dart';
import 'package:viet_qr_plugin/models/bank_account_insert_dto.dart';
import 'package:viet_qr_plugin/models/response_message_dto.dart';
import 'package:viet_qr_plugin/utils/base_api.dart';
import 'package:viet_qr_plugin/utils/log.dart';

class BankAccountRepository {
  const BankAccountRepository();

  Future<ResponseMessageDTO> checkExistedBank(BankAccountCheckDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: "", message: "");
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/check-existed?bankAccount=${dto.bankAccount}&bankTypeId=${dto.bankTypeId}&userId=${dto.userId}&type=${dto.type}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      result = ResponseMessageDTO.fromJson(data);
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: "FAILED", message: "E05");
    }
    return result;
  }

  Future<ResponseMessageDTO> insertUnauthenticatedBank(
      BankAccountInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: "", message: "");
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/unauthenticated';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: dto.toJson(),
      );
      var data = jsonDecode(response.body);
      result = ResponseMessageDTO.fromJson(data);
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: "FAILED", message: "E05");
    }
    return result;
  }
}
