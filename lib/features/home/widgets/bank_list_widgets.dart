import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/home/repositories/bank_list_repository.dart';
import 'package:viet_qr_plugin/features/qr/views/qr_bank_view.dart';
import 'package:viet_qr_plugin/models/bank_account_dto.dart';
import 'package:viet_qr_plugin/models/vietqr_widget_dto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';

import 'package:palette_generator/palette_generator.dart';

class BankListWidget extends StatefulWidget {
  final double width;
  final double height;
  BankListRepository bankListRepository = const BankListRepository();

  BankListWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

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
      child: (_banks.isEmpty)
          ? Container()
          : ListView.builder(
              itemCount: _banks.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                BankAccountDTO bank = _banks[index];
                return Hero(
                  tag: bank.id,
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
                        qrCode: bank.qrCode,
                        bankAccount: bank.bankAccount,
                        userBankName: bank.userBankName,
                        bankName: bank.bankName,
                        bankShortName: bank.bankShortName,
                        imgId: bank.imgId,
                        amount: '',
                        content: '',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QRBankView(
                            widgetKey: bank.id,
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
                          color: bank.bankColor ?? AppColor.GREY_VIEW,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColor.WHITE,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: bank.bankColor ??
                                        AppColor.GREY_VIEW,
                                  ),
                                  // shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: ImageUtils.instance
                                        .getImageNetWork(bank.imgId),
                                  ),
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(left: 10)),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bank.bankShortName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      bank.bankName,
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
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildDescriptionWidget(
                            width: widget.width,
                            title: 'Tài khoản',
                            description: bank.bankAccount,
                          ),
                          _buildDescriptionWidget(
                            width: widget.width,
                            title: 'Tên TK',
                            description:
                                bank.userBankName.toUpperCase(),
                          ),
                          (bank.bankTypeStatus == 1)
                              ? _buildDescriptionWidget(
                                  width: widget.width,
                                  title: 'Trạng thái',
                                  description: (bank.isAuthenticated)
                                      ? 'Đã liên kết'
                                      : 'Chưa liên kết',
                                  color: (bank.isAuthenticated)
                                      ? AppColor.BLUE_TEXT
                                      : AppColor.BLACK,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
