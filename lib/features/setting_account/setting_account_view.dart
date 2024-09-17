import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/models/setting_account_sto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/account_helper.dart';
import 'package:viet_qr_plugin/widgets/separator_widget.dart';

class SettingAccountView extends StatefulWidget {
  const SettingAccountView({super.key});

  @override
  State<SettingAccountView> createState() => _SettingAccountViewState();
}

class _SettingAccountViewState extends State<SettingAccountView> {
  SettingAccountDTO settingAccount = SettingAccountDTO();
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cài đặt giọng nói',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
            const SizedBox(height: 15),
            const Text(
              'Cấu hình thông báo loại giao dịch',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildCheckboxRow('Giao dịch có đối soát', isChecked1, (value) {
                  setState(() {
                    isChecked1 = value ?? true;
                  });
                }),
                // InkWell(
                //   onTap: () {
                //     // DialogWidget.instance.showModelBottomSheet(
                //     //   borderRadius: BorderRadius.circular(16),
                //     //   widget: const PopUpConfirm(),
                //     //   // height: MediaQuery.of(context).size.height * 0.6,
                //     // );
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.all(4),
                //     height: 30,
                //     width: 30,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(100),
                //         gradient: const LinearGradient(
                //             colors: [
                //               Color(0xFFE1EFFF),
                //               Color(0xFFE5F9FF),
                //             ],
                //             begin: Alignment.centerLeft,
                //             end: Alignment.centerRight)),
                //     child:
                //         const XImage(imagePath: 'assets/images/ic-i-black.png'),
                //   ),
                // ),
              ],
            ),
            const MySeparator(color: AppColor.GREY_DADADA),
            buildCheckboxRow('Giao dịch nhận tiền đến (+)', isChecked2,
                (value) {
              setState(() {
                isChecked2 = value ?? true;
              });
            }),
            const MySeparator(color: AppColor.GREY_DADADA),
            buildCheckboxRow('Giao dịch chuyển tiền đi (−)', isChecked3,
                (value) {
              setState(() {
                isChecked3 = value ?? true;
              });
            }),
            const SizedBox(height: 20),
            const Text(
              'Cấu hình thông báo thông tin giao dịch',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 10),
            buildCheckboxRow('Số tiền', isChecked4, (value) {
              setState(() {
                isChecked4 = value ?? true;
              });
            }),
            const MySeparator(color: AppColor.GREY_DADADA),
            buildCheckboxRow('Nội dung thanh toán', isChecked5, (value) {
              setState(() {
                isChecked5 = value ?? true;
              });
            }),
            const MySeparator(color: AppColor.GREY_DADADA),
            buildCheckboxRow('Mã giao dịch', isChecked6, (value) {
              setState(() {
                isChecked6 = value ?? true;
              });
            }),
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

  Widget buildCheckboxRow(
      String text, bool isChecked, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppColor.GREY_DADADA,
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            checkColor: AppColor.WHITE,
            activeColor: AppColor.BLUE_TEXT,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
