import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/add_bank/widgets/find_bank_type_widget.dart';
import 'package:viet_qr_plugin/widgets/header_widget.dart';

class AddBankS1View extends StatelessWidget {
  final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  final double height = Numeral.DEFAULT_SCREEN_HEIGHT;

  const AddBankS1View({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.WHITE,
      body: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const HeaderWidget(
              colorType: 0,
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            const Text(
              'Đầu tiên, chọn ngân hàng\nmà bạn muốn thêm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: FindBankTypeWidget(
                width: width,
                height: 480,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
