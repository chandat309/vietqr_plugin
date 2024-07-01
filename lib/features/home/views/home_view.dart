import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/home/widgets/bank_list_widgets.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';
import 'package:viet_qr_plugin/widgets/dialog_widget.dart';

class HomeView extends StatelessWidget {
  final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  final double height = Numeral.DEFAULT_SCREEN_HEIGHT;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final String imgId = UserHelper.instance.getAccountInformation().imgId;
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
            SizedBox(
              width: width,
              height: 50,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo-vietqr.png',
                    height: 50,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      DialogWidget.instance.openSettingDialog();
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (imgId.isNotEmpty)
                                ? ImageUtils.instance.getImageNetWork(imgId)
                                : Image.asset('assets/images/ic-avatar.png')
                                    .image),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: BankListWidget(
                width: width,
                height: 450,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
