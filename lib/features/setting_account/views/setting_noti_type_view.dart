import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/home/repositories/bank_list_repository.dart';
import 'package:viet_qr_plugin/features/setting_account/repositories/setting_repository.dart';
import 'package:viet_qr_plugin/models/bank_account_dto.dart';
import 'package:viet_qr_plugin/models/bank_type_enable_dto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';

class SettingNotiTypeView extends StatefulWidget {
  const SettingNotiTypeView({super.key});

  @override
  State<SettingNotiTypeView> createState() => _SettingNotiTypeViewState();
}

class _SettingNotiTypeViewState extends State<SettingNotiTypeView> {
  SettingRepository _settingRepository = SettingRepository();
  List<BankAccountDTO> listBank = [];

  @override
  void initState() {
    super.initState();
    getBanks();
  }

  Future<void> getBanks() async {
    final result = await _settingRepository.getListBankNotify();
    setState(() {
      listBank = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double width = Numeral.DEFAULT_SCREEN_WIDTH;
    const double height = Numeral.DEFAULT_SCREEN_HEIGHT;
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'Cấu hình thông báo',
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
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Tùy chỉnh cấu hình nhận BĐSD cho từng tài khoản ngân hàng',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return _itemBank(
                    listBank[index],
                    index,
                  );
                },
                itemCount: listBank.length,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _itemBank(BankAccountDTO dto, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.WHITE,
        border: Border.all(
          color: AppColor.GREY_DADADA,
        ),
      ),
      child: Column(
        children: [
          Row(
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
                        image: ImageUtils.instance.getImageNetWork(dto.imgId),
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
                        Text(dto.bankAccount,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(dto.userBankName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDescriptionWidget(
            title: 'GD đến (+) có đối soát',
            color: AppColor.GREEN,
            isEnable: dto.notificationTypes.contains('RECON'),
            onChange: (value) {
              Set<String> types = dto.notificationTypes.split(',').toSet();
              if (value) {
                types.add('RECON');
              } else {
                types.remove('RECON');
              }

              _settingRepository
                  .setListBankNotify(dto.bankId, types.toList())
                  .then(
                (value) async {
                  final listRes = await _settingRepository.getListBankNotify();
                  setState(() {
                    listBank = listRes;
                  });
                },
              );
            },
          ),
          _buildDescriptionWidget(
            title: 'GD đến (+) không đối soát',
            color: AppColor.BLUE_TEXT,
            isEnable: dto.notificationTypes.contains('CREDIT'),
            onChange: (value) {
              Set<String> types = dto.notificationTypes.split(',').toSet();
              if (value) {
                types.add('CREDIT');
              } else {
                types.remove('CREDIT');
              }
              _settingRepository
                  .setListBankNotify(dto.bankId, types.toList())
                  .then(
                (value) async {
                  final listRes = await _settingRepository.getListBankNotify();
                  setState(() {
                    listBank = listRes;
                  });
                },
              );
            },
          ),
          _buildDescriptionWidget(
            title: 'GD đi (-)',
            color: AppColor.RED_TEXT,
            isEnable: dto.notificationTypes.contains('DEBIT'),
            onChange: (value) {
              Set<String> types = dto.notificationTypes.split(',').toSet();
              if (value) {
                types.add('DEBIT');
              } else {
                types.remove('DEBIT');
              }
              _settingRepository
                  .setListBankNotify(dto.bankId, types.toList())
                  .then(
                (value) async {
                  final listRes = await _settingRepository.getListBankNotify();
                  setState(() {
                    listBank = listRes;
                  });
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildDescriptionWidget({
    required String title,
    required Function(bool) onChange,
    required bool isEnable,
    Color? color,
  }) {
    return Container(
      // height: 20,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                color: color,
                size: 15,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppColor.BLACK,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Checkbox(
            activeColor: AppColor.BLUE_TEXT,
            focusColor: AppColor.BLUE_BGR,
            value: isEnable,
            onChanged: (value) {
              if (value != null) {
                onChange(value);
              }
            },
          )
        ],
      ),
    );
  }
}
