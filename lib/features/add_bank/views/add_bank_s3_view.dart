import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/features/add_bank/widgets/input_bank_name_widget.dart';
import 'package:viet_qr_plugin/models/bank_type_dto.dart';
import 'package:viet_qr_plugin/widgets/header_widget.dart';

class AddBankS3View extends StatelessWidget {
  final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  final double height = Numeral.DEFAULT_SCREEN_HEIGHT;
  final BankTypeDTO bankTypeDTO;
  final String bankAccount;

  const AddBankS3View({
    super.key,
    required this.bankTypeDTO,
    required this.bankAccount,
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
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width: width,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Số tài khoản:',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        bankAccount,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Tiếp theo, nhập tên\nchủ tài khoản ngân hàng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              child: InputBankNameWidget(
                width: width,
                height: 480,
                bankTypeDTO: bankTypeDTO,
                bankAccount: bankAccount,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 30)),
          ],
        ),
      ),
    );
  }
}
