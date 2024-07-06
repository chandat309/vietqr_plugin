import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/login/widgets/phone_input_widget.dart';

class LoginView extends StatelessWidget {
  final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  final double height = Numeral.DEFAULT_SCREEN_HEIGHT;

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.WHITE,
      body: SizedBox(
        width: width,
        height: height,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            UnconstrainedBox(
              child: Image.asset(
                'assets/images/logo-vietqr.png',
                width: 150,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            const Text(
              'Vui lòng nhập số điện thoại\nđăng nhập',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.25,
              ),
            ),
            PhoneInputWidget(
              width: width,
              height: 320,
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
