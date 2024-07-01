import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/add_bank/views/add_bank_s4_view.dart';
import 'package:viet_qr_plugin/models/bank_type_dto.dart';
import 'package:viet_qr_plugin/utils/log.dart';
import 'package:viet_qr_plugin/utils/string_utils.dart';
import 'package:viet_qr_plugin/widgets/button_widget.dart';

class InputBankNameWidget extends StatefulWidget {
  final double width;
  final double height;
  final BankTypeDTO bankTypeDTO;
  final String bankAccount;
  final TextEditingController bankNameController = TextEditingController();

  InputBankNameWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.bankAccount,
    required this.bankTypeDTO,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputBankNameWidget();
}

class _InputBankNameWidget extends State<InputBankNameWidget> {
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
            controller: widget.bankNameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Nhập họ và tên ở đây'),
            onFieldSubmitted: (text) {
              _processName();
            },
            onChanged: (text) {
              if (widget.bankNameController.text.length >= 4 &&
                  widget.bankNameController.text.length <= 50) {
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
          const Padding(padding: EdgeInsets.only(top: 10)),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColor.BLACK,
                fontSize: 13,
              ),
              children: [
                TextSpan(
                    text: 'Lưu ý: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                  text:
                      'Tên chủ tài khoản không chứa dấu tiếng Việt, không chứa các ký tự đặc biệt.',
                ),
              ],
            ),
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
            function: () {
              _processName();
            },
          )
        ],
      ),
    );
  }

  void _processName() {
    try {
      if (_isEnableButton) {
        String userBankName = StringUtils.instance
            .removeDiacritic(widget.bankNameController.text);
        // navigate s3
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddBankS4View(
              bankTypeDTO: widget.bankTypeDTO,
              bankAccount: widget.bankAccount,
              userBankName: userBankName.toUpperCase(),
            ),
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
