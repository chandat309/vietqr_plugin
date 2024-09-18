import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/qr/widgets/viet_qr_widget.dart';
import 'package:viet_qr_plugin/models/vietqr_widget_dto.dart';
import 'package:viet_qr_plugin/widgets/header_widget.dart';

class QRBankView extends StatelessWidget {
  // final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  // final double height = Numeral.DEFAULT_SCREEN_HEIGHT;

  final String widgetKey;
  final VietQRWidgetDTO dto;

  const QRBankView({
    super.key,
    required this.widgetKey,
    required this.dto,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      body: Hero(
        tag: widgetKey,
        flightShuttleBuilder: (flightContext, animation, flightDirection,
            fromHeroContext, toHeroContext) {
          // Tạo và trả về một widget mới để tham gia vào hiệu ứng chuyển động
          return Material(
            child: Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg-qr-vqr.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-qr-vqr.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              const HeaderWidget(
                colorType: 1,
                padding: 20,
              ),
              const Spacer(),
              VietQRWidget(
                dto: dto,
              ),
              const Spacer(),
              const Text(
                'BY VIETQR VN',
                style: TextStyle(
                  color: AppColor.WHITE,
                  fontSize: 12,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10))
            ],
          ),
        ),
      ),
    );
  }
}
