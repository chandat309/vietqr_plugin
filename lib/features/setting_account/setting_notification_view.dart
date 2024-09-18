import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/commons/widgets/my_separator_widget.dart';
import 'package:viet_qr_plugin/features/setting_account/views/setting_popup_bank_view.dart';
import 'package:viet_qr_plugin/features/setting_account/views/setting_voice_bank_view.dart';

class SettingNotificationView extends StatefulWidget {
  const SettingNotificationView({super.key});

  @override
  State<SettingNotificationView> createState() =>
      _SettingNotificationViewState();
}

class _SettingNotificationViewState extends State<SettingNotificationView> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cài đặt hiển thị',
              style: TextStyle(
                  color: AppColor.BLACK,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    isExpand = !isExpand;
                  });
                },
                icon: Icon(
                  isExpand
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  size: 20,
                ))
          ],
        ),
        // const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          height: isExpand ? 0 : 115,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
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
            ),
          ),
        )
      ],
    );
  }
}
