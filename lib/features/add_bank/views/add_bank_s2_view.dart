import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/features/add_bank/widgets/input_bank_account_widget.dart';
import 'package:viet_qr_plugin/models/bank_type_dto.dart';
import 'package:viet_qr_plugin/widgets/header_widget.dart';

class AddBankS2View extends StatelessWidget {
  final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  final double height = Numeral.DEFAULT_SCREEN_HEIGHT;
  final BankTypeDTO bankTypeDTO;

  const AddBankS2View({super.key, required this.bankTypeDTO});

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
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: AppColor.GREY_BORDER,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    EnvConfig.getImagePrefixUrl() + bankTypeDTO.imageId,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Tiếp theo, nhập số\ntài khoản ngân hàng của bạn',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              child: InputBankAccountWidget(
                width: width,
                height: 480,
                bankTypeDTO: bankTypeDTO,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 30)),
          ],
        ),
      ),
    );
  }
}
