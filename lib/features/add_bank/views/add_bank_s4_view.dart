import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/features/add_bank/repositories/bank_repository.dart';
import 'package:viet_qr_plugin/features/home/views/home_view.dart';
import 'package:viet_qr_plugin/models/bank_account_check_dto.dart';
import 'package:viet_qr_plugin/models/bank_account_insert_dto.dart';
import 'package:viet_qr_plugin/models/bank_type_dto.dart';
import 'package:viet_qr_plugin/models/response_message_dto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/log.dart';
import 'package:viet_qr_plugin/widgets/button_widget.dart';
import 'package:viet_qr_plugin/widgets/dialog_widget.dart';
import 'package:viet_qr_plugin/widgets/header_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBankS4View extends StatelessWidget {
  // final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  // final double height = Numeral.DEFAULT_SCREEN_HEIGHT;
  final BankTypeDTO bankTypeDTO;
  final String bankAccount;
  final String userBankName;
  final BankAccountRepository bankAccountRepository =
      const BankAccountRepository();

  const AddBankS4View({
    super.key,
    required this.bankTypeDTO,
    required this.bankAccount,
    required this.userBankName,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const HeaderWidget(
              colorType: 0,
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Thông tin tài khoản ngâng hàng của bạn đã chính xác chứ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
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
            Text(
              bankTypeDTO.bankName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: AppColor.GREY_BORDER,
              ),
            ),
            const Text(
              'Số tài khoản:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            Text(
              bankAccount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: AppColor.GREY_BORDER,
              ),
            ),
            const Text(
              'Chủ tài khoản:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            Text(
              userBankName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Spacer(),
            ButtonWidget(
              width: width,
              height: 40,
              borderRadius: 5,
              text: 'Thêm tài khoản',
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              function: () async {
                await _addBank(context);
              },
            ),
            const Padding(padding: EdgeInsets.only(bottom: 30)),
          ],
        ),
      ),
    );
  }

  Future<void> _addBank(BuildContext context) async {
    try {
      DialogWidget.instance.openLoadingDialog();
      //check existed
      BankAccountCheckDTO bankAccountCheckDTO = BankAccountCheckDTO(
        bankAccount: bankAccount,
        bankTypeId: bankTypeDTO.id,
        userId: UserHelper.instance.getUserId(),
        type: 'ADD',
      );
      ResponseMessageDTO responseMessageDTO =
          await bankAccountRepository.checkExistedBank(bankAccountCheckDTO);
      if (responseMessageDTO.status == "SUCCESS") {
        //add
        BankAccountInsertDTO bankAccountInsertDTO = BankAccountInsertDTO(
          bankTypeId: bankTypeDTO.id,
          bankAccount: bankAccount,
          userBankName: userBankName,
          userId: UserHelper.instance.getUserId(),
          nationalId: '',
          phoneAuthenticated: '',
        );
        ResponseMessageDTO result = await bankAccountRepository
            .insertUnauthenticatedBank(bankAccountInsertDTO);
        Navigator.pop(context);
        if (result.status == 'SUCCESS') {
          Fluttertoast.showToast(
            msg: 'Thêm tài khoản ngân hàng thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
            webBgColor: 'rgba(255, 255, 255)',
            webPosition: 'center',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeView(),
            ),
          );
          // Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể thêm tài khoản',
            message: 'Hệ thống đang xảy ra lỗi!\nVui lòng thử lại sau.',
          );
        }
      } else if (responseMessageDTO.status == "FAILED") {
        Navigator.pop(context);
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể thêm tài khoản',
          message: 'Hệ thống đang xảy ra lỗi!\nVui lòng thử lại sau.',
        );
      } else if (responseMessageDTO.status == 'CHECK') {
        Navigator.pop(context);
        if (responseMessageDTO.message == "C06") {
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể thêm tài khoản',
            message:
                'Bạn đã thêm tài khoản này trước đó!\nVui lòng kiểm tra lại thông tin.',
          );
        } else {
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể thêm tài khoản',
            message: 'Hệ thống đang xảy ra lỗi!\nVui lòng thử lại sau.',
          );
        }
      } else {
        Navigator.pop(context);
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể thêm tài khoản',
          message: 'Hệ thống đang xảy ra lỗi!\nVui lòng thử lại sau.',
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
