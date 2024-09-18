import 'dart:convert';

import 'package:viet_qr_plugin/main.dart';
import 'package:viet_qr_plugin/models/account_information_dto.dart';

class UserHelper {
  const UserHelper._privateConstructor();

  static const UserHelper _instance = UserHelper._privateConstructor();

  static UserHelper get instance => _instance;

  static String user_key = 'USER_ID';
  static String phone_key = 'USER_ID';
  static String wallet_key = 'WALLET_ID';
  static String account_setting_key = 'ACCOUNT_SETTING';
  static String account_info_key = 'ACCOUNT_INFORMATION';

  Future<void> initialUserInformationHelper() async {
    const AccountInformationDTO accountInformationDTO = AccountInformationDTO(
      userId: '',
      firstName: '',
      middleName: '',
      lastName: '',
      birthDate: '',
      gender: 0,
      address: '',
      email: '',
      imgId: '',
    );
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', accountInformationDTO.toSPJson().toString());
    await sharedPrefs.setString('USER_ID', '');
    await sharedPrefs.setString('PHONE_NO', '');
    await sharedPrefs.setString('WALLET_ID', '');
    await sharedPrefs.setString('WALLET_INFO', '');
    await sharedPrefs.setStringList('LOGIN_ACCOUNT', []);
  }

  reset() {
    initialUserInformationHelper();
  }

  Future<void> setUserId(String userId) async {
    if (!sharedPrefs.containsKey(user_key) ||
        sharedPrefs.getString('USER_ID') == null) {
      await sharedPrefs.setString('USER_ID', userId);
      return;
    }
    await sharedPrefs.setString('USER_ID', userId);
  }

  Future<void> setPhoneNo(String phoneNo) async {
    if (!sharedPrefs.containsKey('PHONE_NO') ||
        sharedPrefs.getString('PHONE_NO') == null) {
      await sharedPrefs.setString('PHONE_NO', phoneNo);
      return;
    }
    await sharedPrefs.setString('PHONE_NO', phoneNo);
  }

  String getPhoneNo() {
    return sharedPrefs.getString('PHONE_NO')!;
  }

  Future<void> setWalletId(String walletId) async {
    if (!sharedPrefs.containsKey('WALLET_ID') ||
        sharedPrefs.getString('WALLET_ID') == null) {
      await sharedPrefs.setString('WALLET_ID', walletId);
      return;
    }
    await sharedPrefs.setString('WALLET_ID', walletId);
  }

  String getWalletId() {
    return sharedPrefs.getString('WALLET_ID')!;
  }

  Future<void> setAccountInformation(AccountInformationDTO dto) async {
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', dto.toSPJson().toString());
  }

  Future<void> storeList(List<String> list) async {
    String jsonString = jsonEncode(list);
    // Get the instance of SharedPreferences
    if (!sharedPrefs.containsKey('LIST_BANK_ID_VOICE') ||
        sharedPrefs.getString('LIST_BANK_ID_VOICE') == null) {
      await sharedPrefs.setString('LIST_BANK_ID_VOICE', jsonString);
      print('isSetList');
      return;
    }
      print('isSetList2');
    await sharedPrefs.setString('LIST_BANK_ID_VOICE', jsonString);
  }

  Future<List<String>> retrieveList() async {
    List<String> list = [];
    String? jsonString = sharedPrefs.getString('LIST_BANK_ID_VOICE');
    if (jsonString == null) {
      return list;
    }
    List<dynamic> jsonDecoded = jsonDecode(jsonString);
    print(jsonDecoded);
    // Return the list as List<String>
    return List<String>.from(jsonDecoded);
  }

  // Future<void> setAccountSetting(SettingAccountDTO dto) async {
  //   await sharedPrefs.setString('ACCOUNT_SETTING', dto.toSPJson().toString());
  // }

  Future<void> setImageId(String imgId) async {
    AccountInformationDTO dto = AccountInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_INFORMATION')!));
    AccountInformationDTO newDto = AccountInformationDTO(
        address: dto.address,
        birthDate: dto.birthDate,
        email: dto.email,
        firstName: dto.firstName,
        gender: dto.gender,
        imgId: imgId,
        lastName: dto.lastName,
        middleName: dto.middleName,
        userId: dto.userId);
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', newDto.toSPJson().toString());
  }

  AccountInformationDTO getAccountInformation() {
    return AccountInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_INFORMATION')!));
  }

  // SettingAccountDTO getAccountSetting() {
  //   return SettingAccountDTO.fromJson(
  //       json.decode(sharedPrefs.getString('ACCOUNT_SETTING') ?? ''));
  // }

  Future<void> setWalletInfo(String info) async {
    await sharedPrefs.setString('WALLET_INFO', info);
  }

  // IntroduceDTO getWalletInfo() {
  //   return IntroduceDTO.fromJson(
  //       json.decode(sharedPrefs.getString('WALLET_INFO') ?? ''));
  // }

  String getUserId() {
    return sharedPrefs.getString('USER_ID') ?? '';
  }

  String getUserFullName() {
    return ('${getAccountInformation().lastName} ${getAccountInformation().middleName} ${getAccountInformation().firstName}')
        .trim();
  }

  Future<void> setLoginAccount(List<String> list) async {
    await sharedPrefs.setStringList('LOGIN_ACCOUNT', list);
  }

  // List<InfoUserDTO> getLoginAccount() {
  //   return ListLoginAccountDTO.fromJson(
  //           sharedPrefs.getStringList('LOGIN_ACCOUNT'))
  //       .list;
  // }
}
