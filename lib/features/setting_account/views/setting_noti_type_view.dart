import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';

class SettingNotiTypeView extends StatefulWidget {
  const SettingNotiTypeView({super.key});

  @override
  State<SettingNotiTypeView> createState() => _SettingNotiTypeViewState();
}

class _SettingNotiTypeViewState extends State<SettingNotiTypeView> {
  @override
  Widget build(BuildContext context) {
        const double width = Numeral.DEFAULT_SCREEN_WIDTH;
    const double height = Numeral.DEFAULT_SCREEN_HEIGHT;
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: AppBar(
        title: const Text(
          'Cấu hình thông báo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.4,
          ),
        ),
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
        width: width,
        height: height,
        child: Column(),
      ),
    );
  }
}
