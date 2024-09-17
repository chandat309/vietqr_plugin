import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/commons/widgets/my_separator_widget.dart';
import 'package:viet_qr_plugin/features/setting_account/views/setting_popup_bank_view.dart';
import 'package:viet_qr_plugin/features/setting_account/views/setting_voice_bank_view.dart';

class SettingNotificationView extends StatelessWidget {
  const SettingNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cài đặt hiển thị',
          style: TextStyle(
              color: AppColor.BLACK, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 10),
        InkWell(
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingVoiceBankView(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/ic-voice-black.png',
                  height: 40,
                  color: AppColor.BLUE_TEXT,
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Nhận thông báo với giọng nói',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingPopupBankView(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/ic-popup-settings.png',
                  height: 40,
                  // color: AppColor.BLUE_TEXT,
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Hiển thị Pop-up thông báo BĐSD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
