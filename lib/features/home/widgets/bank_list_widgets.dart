import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/add_bank/views/add_bank_s1_view.dart';
import 'package:viet_qr_plugin/features/home/repositories/bank_list_repository.dart';
import 'package:viet_qr_plugin/features/linked_bank/linked_bank_view.dart';
import 'package:viet_qr_plugin/features/qr/views/qr_bank_view.dart';
import 'package:viet_qr_plugin/models/bank_account_dto.dart';
import 'package:viet_qr_plugin/models/vietqr_widget_dto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';
import 'dart:js' as js;
import 'package:palette_generator/palette_generator.dart';

class BankListWidget extends StatefulWidget {
  final double width;
  final double height;
  BankListRepository bankListRepository = const BankListRepository();

  BankListWidget({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<StatefulWidget> createState() => _BankListWidget();
}

class _BankListWidget extends State<BankListWidget> {
  List<BankAccountDTO> _banks = [];

  @override
  void initState() {
    super.initState();
    getBanks();
  }

  Future<void> getBanks() async {
    String userId = UserHelper.instance.getUserId();
    _banks = await widget.bankListRepository.getListBankAccount(userId);
    final listBankEnableVoice = _banks.where(
      (element) =>
          element.isOwner && element.isAuthenticated && element.enableVoice,
    );
    Set<String> bankIdSet = <String>{};
    if (listBankEnableVoice.isNotEmpty) {
      for (BankAccountDTO dto in listBankEnableVoice) {
        bankIdSet.add(dto.bankId);
      }
    }
    js.context.callMethod(
        'setListBankEnableVoiceId', [jsonEncode(bankIdSet.toList())]);
    await getColors();
  }

  Future<void> getColors() async {
    PaletteGenerator? paletteGenerator;
    for (BankAccountDTO dto in _banks) {
      NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
      paletteGenerator = await PaletteGenerator.fromImageProvider(image);
      if (paletteGenerator.dominantColor != null) {
        dto.setColor(paletteGenerator.dominantColor!.color);
      } else {
        if (!mounted) return;
        dto.setColor(Theme.of(context).cardColor);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_banks.isEmpty) ...[
            const Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              width: widget.width,
              height: 100,
              padding: const EdgeInsets.only(left: 20, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    AppColor.ORANGE_BLUR_01,
                    AppColor.ORANGE_BLUR_02,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddBankS1View(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thêm tài khoản\nngân hàng',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text(
                            'Lưu trữ tài khoản và tạo mã VietQR.',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/ic-add-bank.png',
                      width: 70,
                      height: 70,
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_banks.isNotEmpty) ...[
            const Text(
              'Danh sách tài khoản ngân hàng',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Container(
              width: widget.width,
              height: 40,
              padding: const EdgeInsets.only(left: 20, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    AppColor.ORANGE_BLUR_01,
                    AppColor.ORANGE_BLUR_02,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddBankS1View(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Thêm tài khoản ngân hàng',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/ic-add-bank.png',
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => getBanks(),
                child: ListView.builder(
                  itemCount: _banks.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: _banks[index].bankId,
                      flightShuttleBuilder: (flightContext, animation,
                          flightDirection, fromHeroContext, toHeroContext) {
                        // Tạo và trả về một widget mới để tham gia vào hiệu ứng chuyển động
                        const Curve curve = Curves.easeInOut;
                        var opacityAnimation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          ),
                        );
                        return Material(
                          child: Opacity(
                            opacity: opacityAnimation.value,
                            child: toHeroContext.widget,
                          ),
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          VietQRWidgetDTO dto = VietQRWidgetDTO(
                            qrCode: _banks[index].qrCode,
                            bankAccount: _banks[index].bankAccount,
                            userBankName: _banks[index].userBankName,
                            bankName: _banks[index].bankName,
                            bankShortName: _banks[index].bankShortName,
                            imgId: _banks[index].imgId,
                            amount: '',
                            content: '',
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QRBankView(
                                widgetKey: _banks[index].bankId,
                                dto: dto,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: widget.width,
                          // height: 60,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.WHITE,
                            border: Border.all(
                              color:
                                  _banks[index].bankColor ?? AppColor.GREY_VIEW,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: widget.width,
                                height: 30,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: _banks[index].bankColor ??
                                              AppColor.GREY_VIEW,
                                        ),
                                        // shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: ImageUtils.instance
                                              .getImageNetWork(
                                                  _banks[index].imgId),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _banks[index].bankShortName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _banks[index].bankName,
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
                              ),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              _buildDescriptionWidget(
                                width: widget.width,
                                title: 'Tài khoản',
                                description: _banks[index].bankAccount,
                              ),
                              _buildDescriptionWidget(
                                width: widget.width,
                                title: 'Tên TK',
                                description:
                                    _banks[index].userBankName.toUpperCase(),
                              ),
                              (_banks[index].bankTypeStatus == 1)
                                  ? _buildDescriptionWidget(
                                      width: widget.width,
                                      title: 'Trạng thái',
                                      description:
                                          (_banks[index].isAuthenticated)
                                              ? 'Đã liên kết'
                                              : 'Chưa liên kết',
                                      color: (_banks[index].isAuthenticated)
                                          ? AppColor.BLUE_TEXT
                                          : AppColor.BLACK,
                                    )
                                  : const SizedBox(),
                              if (_banks[index].bankTypeStatus == 1 &&
                                  !_banks[index].isAuthenticated) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => LinkedBankView(
                                              dto: _banks[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Liên kết ngay',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.ORANGE_DARK,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColor.ORANGE_DARK,
                                          height: 1.5,
                                        ),
                                      )),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionWidget({
    required double width,
    required String title,
    required String description,
    Color? color,
  }) {
    return SizedBox(
      width: width,
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.GREY_TEXT,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: (color != null) ? color : AppColor.BLACK,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
