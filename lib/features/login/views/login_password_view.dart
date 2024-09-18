import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/login/widgets/password_input_widget.dart';
import 'package:viet_qr_plugin/models/info_user_dto.dart';
import 'package:viet_qr_plugin/utils/string_utils.dart';
import 'package:viet_qr_plugin/widgets/header_widget.dart';

class LoginPasswordView extends StatelessWidget {
  final InfoUserDTO infoUser;
  // final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  // final double height = Numeral.DEFAULT_SCREEN_HEIGHT;

  const LoginPasswordView({
    super.key,
    required this.infoUser,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.WHITE,
      body: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // physics: const NeverScrollableScrollPhysics(),
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const HeaderWidget(
              colorType: 0,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            // Center(
            //   child:
            Text(
              'Xin chào, ${infoUser.fullName.trim()}!',
              style: const TextStyle(fontSize: 15),
            ),
            // ),
            const Padding(padding: EdgeInsets.only(top: 2)),
            // Center(
            //   child:
            Text(
              StringUtils.instance.formatPhoneNumberVN(infoUser.phoneNo ?? ''),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            // ),
            const Padding(padding: EdgeInsets.only(top: 70)),
            const Text(
              'Vui lòng nhập mật khẩu\nđăng nhập',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.25,
              ),
            ),

            PaswordInputWidget(
              width: width,
              height: 350,
              phoneNo: infoUser.phoneNo ?? '',
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
          ],
        ),
      ),
    );
  }
}
