import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/stringify.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/commons/widgets/text_field_custom.dart';
import 'package:viet_qr_plugin/commons/widgets/vietqr_button.dart';
import 'package:viet_qr_plugin/enums/textfield_type.dart';
import 'package:viet_qr_plugin/features/linked_bank/repositories/linked_repository.dart';
import 'package:viet_qr_plugin/models/bank_account_dto.dart';
import 'package:viet_qr_plugin/models/confirm_otp_bank_dto.dart';
import 'package:viet_qr_plugin/models/register_authentication_dto.dart';
import 'package:viet_qr_plugin/models/response_message_dto.dart';
import 'package:viet_qr_plugin/utils/error_utils.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';
import 'package:viet_qr_plugin/utils/string_utils.dart';
import 'package:viet_qr_plugin/widgets/dialog_widget.dart';
import 'package:viet_qr_plugin/widgets/pin_code_input.dart';

class LinkedBankView extends StatefulWidget {
  final BankAccountDTO dto;
  const LinkedBankView({super.key, required this.dto});

  @override
  State<LinkedBankView> createState() => _LinkedBankViewState();
}

class _LinkedBankViewState extends State<LinkedBankView> {
  final LinkedRepository _repository = LinkedRepository();
  final TextEditingController phone = TextEditingController();
  final TextEditingController cmt = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final PageController pageController = PageController();

  ValueNotifier<bool> disableNotifier = ValueNotifier<bool>(true);

  ValueNotifier<bool> isEnableVerify = ValueNotifier<bool>(false);

  int currentPage = 0;

  final ValueNotifier<int> _timerNotifier = ValueNotifier<int>(120);

  Timer? _timer;

  DataObject? sendOtpData;
  String requestId = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startTimer() async {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_timerNotifier.value > 0) {
          _timerNotifier.value--;
        } else {
          timer.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // const double width = Numeral.DEFAULT_SCREEN_WIDTH;
    // const double height = Numeral.DEFAULT_SCREEN_HEIGHT;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'Liên kết tài khoản',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.4,
          ),
        ),
        backgroundColor: AppColor.WHITE,
        leading: IconButton(
            onPressed: () {
              if (currentPage == 0) {
                Navigator.of(context).pop();
              } else {
                isEnableVerify.value = false;
                _timerNotifier.value = 120;
                pageController.previousPage(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut);
              }
            },
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColor.BLACK,
            )),
        actions: [
          Image.asset(
            'assets/images/logo-vietqr.png',
            height: 50,
          ),
        ],
      ),
      bottomNavigationBar: currentPage == 0
          ? ValueListenableBuilder<bool>(
              valueListenable: disableNotifier,
              builder: (context, value, child) {
                return VietQRButton.gradient(
                    height: 40,
                    padding: EdgeInsets.zero,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    onPressed: () async {
                      onSendOTP();
                    },
                    isDisabled: value,
                    child: Center(
                      child: Text(
                        'Liên kết',
                        style: TextStyle(
                            fontSize: 13,
                            color: value ? AppColor.BLACK : AppColor.WHITE),
                      ),
                    ));
              },
            )
          : ValueListenableBuilder<bool>(
              valueListenable: isEnableVerify,
              builder: (context, isEnable, child) {
                return VietQRButton.gradient(
                    height: 40,
                    padding: EdgeInsets.zero,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    onPressed: () async {
                      if (widget.dto.bankCode.contains('BIDV') &&
                          sendOtpData != null) {
                        ConfirmOTPBidvDTO otpBidvDTO = ConfirmOTPBidvDTO(
                            bankCode: widget.dto.bankCode,
                            bankAccount: widget.dto.bankAccount,
                            merchantId: sendOtpData!.merchantId,
                            merchantName: sendOtpData!.merchantName,
                            confirmId: sendOtpData!.confirmId,
                            otpNumber: otpController.text);
                        await _repository.confirmOTP(otpBidvDTO).then(
                          (responseMessageDTO) async {
                            if (responseMessageDTO.status ==
                                Stringify.RESPONSE_STATUS_SUCCESS) {
                              registerBank(responseMessageDTO);
                            } else {
                              DialogWidget.instance.openMsgDialog(
                                  title: 'Thông báo',
                                  message: ErrorUtils.instance.getErrorMessage(
                                      responseMessageDTO.message));
                            }
                          },
                        );
                        // await _repository.
                      } else {
                        ConfirmOTPBankDTO confirmDTO = ConfirmOTPBankDTO(
                          requestId: requestId,
                          otpValue: otpController.text,
                          applicationType: 'MOBILE',
                          bankAccount: widget.dto.bankAccount,
                          bankCode: widget.dto.bankCode,
                        );
                        await _repository.confirmOTP(confirmDTO).then(
                          (responseMessageDTO) {
                            if (responseMessageDTO.status ==
                                Stringify.RESPONSE_STATUS_SUCCESS) {
                              registerBank(responseMessageDTO);
                            } else {
                              DialogWidget.instance.openMsgDialog(
                                  title: 'Thông báo',
                                  message: ErrorUtils.instance.getErrorMessage(
                                      responseMessageDTO.message));
                            }
                          },
                        );
                      }
                    },
                    isDisabled: !isEnable,
                    child: Center(
                      child: Text(
                        'Xác thực',
                        style: TextStyle(
                            fontSize: 13,
                            color: !isEnable ? AppColor.BLACK : AppColor.WHITE),
                      ),
                    ));
              },
            ),
      body: Container(
        width: width,
        height: height,
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
          },
          children: [
            inputWidget(),
            otpWidget(),
          ],
        ),
      ),
    );
  }

  Widget otpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    'Nhập mã OTP từ ${widget.dto.bankCode} gửi về số điện thoại ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColor.BLACK,
                ),
              ),
              TextSpan(
                text: widget.dto.phoneAuthenticated,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: PinCodeInput(
            size: 30,
            obscureText: false,
            autoFocus: true,
            controller: otpController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (widget.dto.bankCode.contains('BIDV')) {
                  isEnableVerify.value = value.length == 6;
                } else {
                  isEnableVerify.value = value.length == 8;
                }
              } else {
                isEnableVerify.value = false;
              }
            },
            length: widget.dto.bankCode.contains('BIDV') ? 6 : 8,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.BLUE_TEXT,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const SizedBox(height: 12),
        ValueListenableBuilder<int>(
          valueListenable: _timerNotifier,
          builder: (_, value, child) {
            return (value != 0)
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 15,
                      ),
                      children: [
                        const TextSpan(text: 'Mã OTP có hiệu lực trong vòng '),
                        TextSpan(
                          text: value.toString(),
                          style: const TextStyle(color: AppColor.BLUE_TEXT),
                        ),
                        const TextSpan(text: 's.'),
                      ],
                    ),
                  )
                : RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 15,
                      ),
                      children: [
                        const TextSpan(text: 'Không nhận được mã OTP? '),
                        TextSpan(
                          text: 'Gửi lại',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColor.BLUE_TEXT,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              otpController.clear();
                              _timerNotifier.value = 120;
                              startTimer();
                              onSendOTP(isResend: true);
                            },
                        ),
                      ],
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget inputWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            widget.dto.bankName,
            style: const TextStyle(fontSize: 13, color: AppColor.BLACK),
          ),
          Row(
            children: [
              Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: widget.dto.bankColor ?? AppColor.GREY_VIEW,
                  ),
                  // shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image:
                        ImageUtils.instance.getImageNetWork(widget.dto.imgId),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dto.bankAccount,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      widget.dto.userBankName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            controller: phone,
            inputBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.GREY_DADADA)),
            textFieldType: TextfieldType.LABEL,
            title: 'Số điện thoại xác thực',
            unTitle:
                'Số điện thoại phải trùng khớp với thông tin đăng ký tài khoản ngân hàng',
            isRequired: true,
            hintText: 'Nhập số điện thoại xác thực',
            inputType: TextInputType.number,
            keyboardAction: TextInputAction.next,
            onChange: (value) {
              if (value.isEmpty) {
                disableNotifier.value = false;
              } else {
                disableNotifier.value = cmt.text.isEmpty;
              }
            },
          ),
          const SizedBox(height: 20),
          TextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            controller: cmt,
            textFieldType: TextfieldType.LABEL,
            inputBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.GREY_DADADA)),
            title: 'CCCD/MST',
            unTitle:
                'CCCD (Căn cước công dân)/MST (Mã số thuế) phải trùng khớp với thông tin đăng ký tài khoản ngân hàng',
            isRequired: true,
            hintText: 'Nhập chứng minh thư hoặc MST',
            inputType: TextInputType.number,
            keyboardAction: TextInputAction.next,
            inputFormatter: [
              LengthLimitingTextInputFormatter(12),
            ],
            onChange: (value) {
              disableNotifier.value = value.isEmpty;
              if (value.isEmpty) {
                disableNotifier.value = false;
              } else {
                disableNotifier.value = phone.text.isEmpty;
              }
            },
          ),
        ],
      ),
    );
  }

  void registerBank(ResponseMessageDTO res) async {
    final dto = RegisterAuthenticationDTO(
      bankId: widget.dto.bankId,
      bankCode: widget.dto.bankCode,
      merchantId: sendOtpData != null ? sendOtpData!.merchantId : '',
      merchantName: sendOtpData != null ? sendOtpData!.merchantName : '',
      vaNumber: res.message,
      nationalId: cmt.text,
      phoneAuthenticated: phone.text,
      bankAccountName: widget.dto.userBankName,
      bankAccount: widget.dto.bankAccount,
      ewalletToken: res.message,
    );
    await _repository.updateRegisterAuthenticationBank(dto).then(
      (res) {
        if (res.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          Navigator.of(context).pop(true);
        }
      },
    );
  }

  void onSendOTP({bool isResend = false}) async {
    String formattedName = StringUtils.instance.removeDiacritic(
        StringUtils.instance.capitalFirstCharacter(widget.dto.userBankName));
    Map<String, dynamic> data = {};
    data['nationalId'] = cmt.text;
    data['accountNumber'] = widget.dto.bankAccount;
    data['accountName'] = formattedName;
    data['applicationType'] = 'MOBILE';
    data['phoneNumber'] = phone.text;
    data['bankCode'] = widget.dto.bankCode;

    await _repository.requestOTP(data).then(
      (responseMessageDTO) {
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          setState(() {
            sendOtpData = responseMessageDTO.data;
            requestId = responseMessageDTO.message;
          });
          if (!isResend) {
            pageController.nextPage(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut);
            startTimer();
          }
        } else {
          if (responseMessageDTO.message == 'E05') {
            DialogWidget.instance.openMsgDialog(
              title: 'Không thể liên kết TK',
              message:
                  'Vui lòng kiểm tra thông tin đã khớp với thông tin khai báo với ngân hàng.',
            );
          } else {
            DialogWidget.instance.openMsgDialog(
                title: 'Không thể liên kết TK',
                message: ErrorUtils.instance
                    .getErrorMessage(responseMessageDTO.message));
          }
        }
      },
    );
  }
}
