import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/home/repositories/bank_list_repository.dart';
import 'package:viet_qr_plugin/features/setting_account/repositories/setting_repository.dart';
import 'package:viet_qr_plugin/features/setting_account/views/setting_popup_bank_view.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';
import 'package:viet_qr_plugin/widgets/separator_widget.dart';
import 'dart:js' as js;

class SettingVoiceBankView extends StatefulWidget {
  const SettingVoiceBankView({super.key});

  @override
  State<SettingVoiceBankView> createState() => _SettingVoiceBankViewState();
}

class _SettingVoiceBankViewState extends State<SettingVoiceBankView> {
  String userId = UserHelper.instance.getUserId();
  final SettingRepository _settingRepository = SettingRepository();
  List<BankSelection> _listBankAuthen = [];
  List<String> _listBankId = [];

  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;

  @override
  void initState() async {
    super.initState();
    getBanks();
  }

  Future<void> getBanks() async {
    BankListRepository bankListRepository = const BankListRepository();

    final result = await bankListRepository.getListBankAccount(userId);
    final filterListAuten = result
        .where(
          (element) => element.isOwner && element.isAuthenticated,
        )
        .toList();

    setState(() {
      _listBankAuthen = List.generate(
        filterListAuten.length,
        (index) => BankSelection(
            bank: filterListAuten[index],
            value: filterListAuten[index].enableVoice),
      );
    });
    _updateListId(_listBankAuthen);
  }

  @override
  Widget build(BuildContext context) {
    const double width = Numeral.DEFAULT_SCREEN_WIDTH;
    const double height = Numeral.DEFAULT_SCREEN_HEIGHT;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.WHITE,
      appBar: AppBar(
        backgroundColor: AppColor.WHITE,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColor.BLACK,
            )),
        title: const Text(
          'Cài đặt giọng nói',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.4,
          ),
        ),
        actions: [
          Image.asset(
            'assets/images/logo-vietqr.png',
            height: 50,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Giọng nói được kích hoạt khi nhận thông báo Biến động số dư trong ứng dụng VietQR cho tất cả tài khoản',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                getSwitch(
                  _listBankAuthen.every((element) => element.value),
                  (value) async {
                    _updateEnableVoiceItem(value);
                    _updateListId(_listBankAuthen);
                    Map<String, dynamic> paramEnable = {};
                    paramEnable['bankIds'] = _listBankId;
                    paramEnable['userId'] = UserHelper.instance.getUserId();
                    _settingRepository.enableVoiceSetting(paramEnable).then(
                      (isSuccess) {
                        if (isSuccess) {
                          // js.context.callMethod('setListBankEnableVoiceId',
                          //     [jsonEncode(_listBankId)]);
                          js.context.callMethod(
                              'getListBankNotificationTypes', [userId]);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const MySeparator(color: AppColor.GREY_DADADA),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return _itemBank(
                    _listBankAuthen[index],
                    index,
                  );
                },
                itemCount: _listBankAuthen.length,
              ),
            ),
            // const SizedBox(height: 15),
            // const Text(
            //   'Cấu hình thông báo loại giao dịch',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            // ),
            // const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     buildCheckboxRow('Giao dịch có đối soát', isChecked1, (value) {
            //       setState(() {
            //         isChecked1 = value ?? true;
            //       });
            //     }),
            // InkWell(
            //   onTap: () {
            //     // DialogWidget.instance.showModelBottomSheet(
            //     //   borderRadius: BorderRadius.circular(16),
            //     //   widget: const PopUpConfirm(),
            //     //   // height: MediaQuery.of(context).size.height * 0.6,
            //     // );
            //   },
            //   child: Container(
            //     padding: const EdgeInsets.all(4),
            //     height: 30,
            //     width: 30,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(100),
            //         gradient: const LinearGradient(
            //             colors: [
            //               Color(0xFFE1EFFF),
            //               Color(0xFFE5F9FF),
            //             ],
            //             begin: Alignment.centerLeft,
            //             end: Alignment.centerRight)),
            //     child:
            //         const XImage(imagePath: 'assets/images/ic-i-black.png'),
            //   ),
            // ),
            //   ],
            // ),
            // const MySeparator(color: AppColor.GREY_DADADA),
            // buildCheckboxRow('Giao dịch nhận tiền đến (+)', isChecked2,
            //     (value) {
            //   setState(() {
            //     isChecked2 = value ?? true;
            //   });
            // }),
            // const MySeparator(color: AppColor.GREY_DADADA),
            // buildCheckboxRow('Giao dịch chuyển tiền đi (−)', isChecked3,
            //     (value) {
            //   setState(() {
            //     isChecked3 = value ?? true;
            //   });
            // }),
            // const SizedBox(height: 20),
            // const Text(
            //   'Cấu hình thông báo thông tin giao dịch',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            // ),
            // const SizedBox(height: 10),
            // buildCheckboxRow('Số tiền', isChecked4, (value) {
            //   setState(() {
            //     isChecked4 = value ?? true;
            //   });
            // }),
            // const MySeparator(color: AppColor.GREY_DADADA),
            // buildCheckboxRow('Nội dung thanh toán', isChecked5, (value) {
            //   setState(() {
            //     isChecked5 = value ?? true;
            //   });
            // }),
            // const MySeparator(color: AppColor.GREY_DADADA),
            // buildCheckboxRow('Mã giao dịch', isChecked6, (value) {
            //   setState(() {
            //     isChecked6 = value ?? true;
            //   });
            // }),
          ],
        ),
      ),
    );
  }

  Widget buildCheckboxRow(
      String text, bool isChecked, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppColor.GREY_DADADA,
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            checkColor: AppColor.WHITE,
            activeColor: AppColor.BLUE_TEXT,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _itemBank(BankSelection dto, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.5, color: Colors.grey),
                  image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.bank.imgId),
                  ),
                ),
                // Placeholder for bank logo
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dto.bank.bankAccount,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600)),
                    Text(dto.bank.userBankName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          getSwitch(
            dto.value,
            (value) async {
              setState(() {
                _listBankAuthen[index] =
                    BankSelection(bank: dto.bank, value: value);
              });
              _updateListId(_listBankAuthen);
              Map<String, dynamic> paramEnable = {};
              paramEnable['bankIds'] = _listBankId;
              paramEnable['userId'] = UserHelper.instance.getUserId();
              _settingRepository.enableVoiceSetting(paramEnable).then(
                (isSuccess) {
                  if (isSuccess) {
                    // js.context.callMethod(
                    //     'setListBankEnableVoiceId', [jsonEncode(_listBankId)]);
                    js.context
                        .callMethod('getListBankNotificationTypes', [userId]);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _updateListId(List<BankSelection> listBankAuthen) {
    Set<String> bankIdSet = <String>{};
    if (listBankAuthen.isNotEmpty) {
      final list =
          listBankAuthen.where((element) => element.value == true).toList();
      for (BankSelection selection in list) {
        // ignore: unnecessary_null_comparison
        if (selection.bank != null) {
          bankIdSet.add(selection.bank.bankId);
        }
      }
      setState(() {
        _listBankId = bankIdSet.toList();
      });
      // js.context.callMethod(
      //     'setListBankEnableVoiceId', [jsonEncode(bankIdSet.toList())]);
      js.context.callMethod('getListBankNotificationTypes', [userId]);
    }
  }

  void _updateEnableVoiceItem(bool value) {
    setState(() {
      _listBankAuthen = List.generate(
        _listBankAuthen.length,
        (index) =>
            BankSelection(bank: _listBankAuthen[index].bank, value: value),
      ).toList();
    });
  }

  Switch getSwitch(bool value, Function(bool) onChange) {
    return Switch(
      value: value,
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColor.BLUE_TEXT.withOpacity(0.3);
        }
        return AppColor.GREY_DADADA.withOpacity(0.3);
      }),
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColor.BLUE_TEXT;
        }
        return AppColor.GREY_DADADA;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (final Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return null;
          }

          return AppColor.TRANSPARENT;
        },
      ),
      onChanged: onChange,
    );
  }
}
