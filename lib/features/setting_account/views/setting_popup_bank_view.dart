import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/commons/widgets/my_separator_widget.dart';
import 'package:viet_qr_plugin/features/home/repositories/bank_list_repository.dart';
import 'package:viet_qr_plugin/features/setting_account/repositories/setting_repository.dart';
import 'package:viet_qr_plugin/models/bank_account_dto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';

class SettingPopupBankView extends StatefulWidget {
  const SettingPopupBankView({super.key});

  @override
  State<SettingPopupBankView> createState() => _SettingPopupBankViewState();
}

class _SettingPopupBankViewState extends State<SettingPopupBankView> {
  final SettingRepository _settingRepository = SettingRepository();
  List<BankSelection> _listBankAuthen = [];

  @override
  void initState() {
    super.initState();
    getBanks();
  }

  Future<void> getBanks() async {
    BankListRepository bankListRepository = const BankListRepository();

    String userId = UserHelper.instance.getUserId();

    final result = await bankListRepository.getListBankAccount(userId);
    final filterListAuten = result
        .where(
          (element) => element.isOwner && element.isAuthenticated,
        )
        .toList();

    setState(() {
      _listBankAuthen = List.generate(
        filterListAuten.length,
        (index) => BankSelection(bank: result[index]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const double width = Numeral.DEFAULT_SCREEN_WIDTH;
    const double height = Numeral.DEFAULT_SCREEN_HEIGHT;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.WHITE,
      appBar: AppBar(
        title: const Text(
          'Cài đặt thông báo',
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
              Navigator.of(context).pop();
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Cài đặt hiển thị thông báo BĐSD',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thông báo tất cả tài khoản',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
                getSwitch(
                  _listBankAuthen.every((element) => element.value),
                  (value) async {
                    await _settingRepository
                        .setNotificationBDSD(value ? 1 : 0)
                        .then(
                      (isSuccess) {
                        if (isSuccess) {
                          setState(() {
                            _listBankAuthen = List.generate(
                              _listBankAuthen.length,
                              (index) => BankSelection(
                                  bank: _listBankAuthen[index].bank,
                                  value: value),
                            );
                          });
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
            )
          ],
        ),
      ),
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
              const SizedBox(width: 6),
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
              await _settingRepository
                  .setBankNotiBDSD(dto.bank.bankId, value ? 1 : 0)
                  .then(
                (isSuccess) {
                  if (isSuccess) {
                    setState(() {
                      _listBankAuthen[index] =
                          BankSelection(bank: dto.bank, value: value);
                    });
                  }
                },
              );
            },
          ),
        ],
      ),
    );
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

class BankSelection {
  final BankAccountDTO bank;
  final bool value;
  BankSelection({required this.bank, this.value = false});
}
