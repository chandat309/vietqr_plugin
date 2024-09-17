import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/models/setting_account_sto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/account_helper.dart';

class SettingAccountView extends StatefulWidget {
  const SettingAccountView({super.key});

  @override
  State<SettingAccountView> createState() => _SettingAccountViewState();
}

class _SettingAccountViewState extends State<SettingAccountView> {
  SettingAccountDTO settingAccount = SettingAccountDTO();

  @override
  void initState() async {
    super.initState();
  }

  void getSetting() async {
    final result = await AccountHelper.instance.getAccountSetting();
    if (result != null) {
      setState(() {
        settingAccount = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: AppBar(
        backgroundColor: AppColor.WHITE,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColor.BLACK,
            )),
        actions: [
          Image.asset(
            'assets/images/logo-vietqr.png',
            height: 50,
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cài đặt giọng nói',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildBgItem(
              customPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Giọng nói được kích hoạt khi nhận thông báo Biến động số dư trong ứng dụng VietQR cho tất cả tài khoản',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    settingAccount.voiceMobile ? 'Bật' : 'Tắt',
                    style: const TextStyle(
                        fontSize: 12, color: AppColor.GREY_TEXT),
                  ),
                  Switch(
                    value: settingAccount.voiceMobile,
                    activeColor: AppColor.BLUE_TEXT,
                    onChanged: (bool value) {
                      // provider.updateOpenVoice(value);
                      // Map<String, dynamic> paramEnable = {};
                      // paramEnable['bankIds'] = provider.getListId();
                      // paramEnable['userId'] =
                      //     SharePrefUtils.getProfile().userId;
                      // // for (var e in provider.listVoiceBank) {
                      // //   e.enableVoice = value;
                      // // }
                      // _enableVoiceSetting(paramEnable, provider);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgItem({required Widget child, EdgeInsets? customPadding}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: customPadding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: child,
    );
  }
}
