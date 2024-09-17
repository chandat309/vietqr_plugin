import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';

class SettingPopupBankView extends StatefulWidget {
  const SettingPopupBankView({super.key});

  @override
  State<SettingPopupBankView> createState() => _SettingPopupBankViewState();
}

class _SettingPopupBankViewState extends State<SettingPopupBankView> {
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
    );
  }
}
