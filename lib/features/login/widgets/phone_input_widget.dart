import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/login/repositories/login_repository.dart';
import 'package:viet_qr_plugin/features/login/views/login_password_view.dart';
import 'package:viet_qr_plugin/models/info_user_dto.dart';
import 'package:viet_qr_plugin/models/response_message_dto.dart';
import 'package:viet_qr_plugin/utils/log.dart';
import 'package:viet_qr_plugin/widgets/button_widget.dart';
import 'package:viet_qr_plugin/widgets/dialog_widget.dart';

class PhoneInputWidget extends StatefulWidget {
  final double width;
  final double height;
  final TextEditingController phoneNoController = TextEditingController();
  LoginRepository loginRepository = const LoginRepository();

  PhoneInputWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneInputWidget();
}

class _PhoneInputWidget extends State<PhoneInputWidget> {
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
          const Padding(padding: EdgeInsets.only(top: 10)),
          TextFormField(
            controller: widget.phoneNoController,
            autofocus: true,
            decoration: const InputDecoration(hintText: '012 345 6789'),
            onFieldSubmitted: (text) async {
              await findUser();
            },
            onChanged: (text) {
              if (widget.phoneNoController.text.length >= 10 &&
                  widget.phoneNoController.text.length <= 13) {
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
          ButtonWidget(
            width: widget.width,
            height: 40,
            borderRadius: 5,
            text: 'Tiếp tục',
            textColor: (_isEnableButton) ? AppColor.WHITE : AppColor.BLACK,
            bgColor:
                (_isEnableButton) ? AppColor.BLUE_TEXT : AppColor.GREY_BUTTON,
            function: () async {
              await findUser();
            },
          )
          // NextLoginButtonWidget(
          //   width: widget.width,
          //   phoneNoController: widget.phoneNoController,
          // ),
        ],
      ),
    );
  }

  Future<void> findUser() async {
    try {
      if (_isEnableButton) {
        //open loading dialog
        DialogWidget.instance.openLoadingDialog();
        final data = await widget.loginRepository
            .checkExistedPhone(widget.phoneNoController.text);
        //pop loading dialog
        Navigator.pop(context);
        if (data is InfoUserDTO) {
          print('true');
          InfoUserDTO infoUser = data;
          print(infoUser.fullName);
          //navigate input password
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoginPasswordView(infoUser: infoUser),
            ),
          );
        } else if (data is ResponseMessageDTO) {
          print('err');
          //show pop-up
          DialogWidget.instance.openRegisterDialog();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
