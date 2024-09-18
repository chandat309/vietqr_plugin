import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';

class HeaderWidget extends StatelessWidget {
  final double width = Numeral.DEFAULT_SCREEN_WIDTH;
  final int colorType;
  final double? padding;

  const HeaderWidget({
    super.key,
    required this.colorType,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 80,
      padding: (padding == null)
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              horizontal: padding!,
            ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Image.asset(
                  (colorType == 0)
                      ? 'assets/images/ic-back.png'
                      : 'assets/images/ic-back-white.png',
                  height: 20,
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                Text(
                  'Trở về',
                  style: TextStyle(
                    color:
                        (colorType == 0) ? AppColor.BLUE_TEXT : AppColor.WHITE,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/logo-vietqr.png',
            height: 100,
          ),
        ],
      ),
    );
  }
}
