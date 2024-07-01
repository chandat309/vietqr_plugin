import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/add_bank/repositories/bank_name_repository.dart';
import 'package:viet_qr_plugin/features/add_bank/repositories/bank_type_repository.dart';
import 'package:viet_qr_plugin/features/add_bank/views/add_bank_s3_view.dart';
import 'package:viet_qr_plugin/features/add_bank/views/add_bank_s4_view.dart';
import 'package:viet_qr_plugin/models/bank_name_information_dto.dart';
import 'package:viet_qr_plugin/models/bank_name_search_dto.dart';
import 'package:viet_qr_plugin/models/bank_type_dto.dart';
import 'package:viet_qr_plugin/utils/log.dart';
import 'package:viet_qr_plugin/widgets/button_widget.dart';
import 'package:viet_qr_plugin/widgets/dialog_widget.dart';

class InputBankAccountWidget extends StatefulWidget {
  final double width;
  final double height;
  final BankTypeDTO bankTypeDTO;
  final TextEditingController bankAccountController = TextEditingController();
  final BankNameRepository bankNameRepository = const BankNameRepository();

  InputBankAccountWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.bankTypeDTO,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputBankAccountWidget();
}

class _InputBankAccountWidget extends State<InputBankAccountWidget> {
  bool _isEnableButton = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.bankAccountController,
            autofocus: true,
            decoration:
                const InputDecoration(hintText: 'Nhập số tài khoản ở đây'),
            onFieldSubmitted: (text) async {
              await _findBankUser();
            },
            onChanged: (text) {
              if (widget.bankAccountController.text.length >= 4 &&
                  widget.bankAccountController.text.length <= 20) {
                setState(() {
                  _isEnableButton = true;
                });
              } else {
                setState(() {
                  _isEnableButton = false;
                });
              }
            },
          ),
          const Spacer(),
          const Center(
            child: Text(
              'Thêm tài khoản ngân hàng',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          ButtonWidget(
            width: widget.width,
            height: 40,
            borderRadius: 5,
            text: 'Tiếp tục',
            textColor: (_isEnableButton) ? AppColor.WHITE : AppColor.BLACK,
            bgColor:
                (_isEnableButton) ? AppColor.BLUE_TEXT : AppColor.GREY_BUTTON,
            function: () async {
              await _findBankUser();
            },
          )
        ],
      ),
    );
  }

  Future<void> _findBankUser() async {
    try {
      if (_isEnableButton) {
        DialogWidget.instance.openLoadingDialog();
        String accountType = 'ACCOUNT';
        String transferType = 'NAPAS';
        if (widget.bankTypeDTO.bankCode == 'MB') {
          transferType = 'INHOUSE';
        }
        BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
          accountNumber: widget.bankAccountController.text,
          accountType: accountType,
          transferType: transferType,
          bankCode: widget.bankTypeDTO.caiValue,
        );
        BankNameInformationDTO bankNameInformationDTO =
            await widget.bankNameRepository.searchBankName(bankNameSearchDTO);
        Navigator.pop(context);
        print('---name: ${bankNameInformationDTO.customerName}');
        if (bankNameInformationDTO.customerName.isNotEmpty) {
          //  navigate s4
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddBankS4View(
                bankTypeDTO: widget.bankTypeDTO,
                bankAccount: widget.bankAccountController.text,
                userBankName: bankNameInformationDTO.customerName,
              ),
            ),
          );
        } else {
          // navigate s3
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddBankS3View(
                bankTypeDTO: widget.bankTypeDTO,
                bankAccount: widget.bankAccountController.text,
              ),
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
