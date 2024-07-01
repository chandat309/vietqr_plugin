import 'dart:convert';

import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/enums/authentication_type.dart';
import 'package:viet_qr_plugin/models/bank_name_information_dto.dart';
import 'package:viet_qr_plugin/models/bank_name_search_dto.dart';
import 'package:viet_qr_plugin/utils/base_api.dart';
import 'package:viet_qr_plugin/utils/log.dart';

class BankNameRepository {
  const BankNameRepository();

  Future<BankNameInformationDTO> searchBankName(BankNameSearchDTO dto) async {
    BankNameInformationDTO result = const BankNameInformationDTO(
      accountName: '',
      customerName: '',
      customerShortName: '',
    );
    try {
      final String url =
          '${EnvConfig.getUrl()}bank/api/account/info/${dto.bankCode}/${dto.accountNumber}/${dto.accountType}/${dto.transferType}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BankNameInformationDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
