import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:viet_qr_plugin/models/vietqr_widget_dto.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';
import 'package:viet_qr_plugin/utils/share_utils.dart';
import 'package:viet_qr_plugin/widgets/dashed_line.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VietQRWidget extends StatelessWidget {
  final VietQRWidgetDTO dto;

  const VietQRWidget({
    super.key,
    required this.dto,
  });

  @override
  Widget build(BuildContext context) {
    const double width = Numeral.VIETQR_WIDGET_WIDTH;
    const double height = width / Numeral.VIETQR_WIDGET_FRAME_RATIO;
    const double bankInfoHeight = width / Numeral.VIETQR_BANK_INFO_RATIO;
    const double padding = width / Numeral.VIETQR_PADDING_WIDGET_RATIO;
    const double paddingTopQR = width / Numeral.QR_PADDING_TOP_RATIO;
    const double qrLogoHeight = width / Numeral.QR_LOGO_HEIGHT_RATIO;
    const double qrLogoMidSize = width / Numeral.QR_LOGO_MIDDLE_SIZE_RATIO;
    const double qrBankWidth = width / Numeral.VIETQR_BANK_LOGO_WIDTH_RATIO;
    const double qrBankHeight = width / Numeral.VIETQR_BANK_LOGO_HEIGHT_RATIO;
    const double qrBankInnerWidth =
        width / Numeral.VIETQR_BANK_LOGO_INNER_WIDTH_RATIO;
    const double qrBankInnerHeight =
        width / Numeral.VIETQR_BANK_LOGO_INNER_HEIGHT_RATIO;
    const double qrWidth = width / Numeral.QR_RATIO;
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          Container(
            width: width,
            height: bankInfoHeight,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: qrBankWidth,
                  height: qrBankHeight,
                  child: UnconstrainedBox(
                    child: Container(
                      width: qrBankInnerWidth,
                      height: qrBankInnerHeight,
                      decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: ImageUtils.instance.getImageNetWork(dto.imgId),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: bankInfoHeight,
                  child: VerticalDashedLine(),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: SizedBox(
                    height: bankInfoHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dto.bankAccount,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dto.userBankName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: bankInfoHeight,
                  child: VerticalDashedLine(),
                ),
                SizedBox(
                  width: qrBankHeight,
                  height: qrBankHeight,
                  child: UnconstrainedBox(
                    child: InkWell(
                      onTap: () async {
                        await _copyQR(context, dto);
                      },
                      child: Image.asset(
                        'assets/images/ic-copy-blue.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: padding)),
          Container(
            width: width,
            height: width,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: paddingTopQR)),
                QrImageView(
                  size: qrWidth,
                  data: dto.qrCode,
                  version: QrVersions.auto,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(
                      qrLogoMidSize,
                      qrLogoMidSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: qrWidth,
                  height: qrLogoHeight,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 5)),
                      Image.asset(
                        'assets/images/logo-vietqr-small-hor.png',
                        height: qrLogoHeight,
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/images/ic-napas247.png',
                        height: qrLogoHeight,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyQR(BuildContext context, VietQRWidgetDTO dto) async {
    await FlutterClipboard.copy(ShareUtils.instance.getQRTextShare(dto)).then(
      (value) => Fluttertoast.showToast(
        msg: 'Đã sao chép',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      ),
    );
  }
}
