// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/login/views/login_view.dart';
import 'package:viet_qr_plugin/features/logout/repositories/logout_repository.dart';
import 'package:viet_qr_plugin/main.dart';
import 'package:viet_qr_plugin/navigator/app_navigator.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/image_utils.dart';
import 'package:viet_qr_plugin/utils/string_utils.dart';
import 'package:viet_qr_plugin/widgets/button_widget.dart';
// import 'dart:js' as js;

class DialogWidget {
  //
  const DialogWidget._privateConstructor();

  static const DialogWidget _instance = DialogWidget._privateConstructor();

  static DialogWidget get instance => _instance;

  static bool isPopLoading = false;

  static const LogoutRepository _logoutRepository = LogoutRepository();

  void openLoadingDialog({String msg = ''}) async {
    if (!isPopLoading) {
      isPopLoading = true;
      return await showDialog(
          barrierDismissible: false,
          context: NavigationService.navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return Material(
              color: AppColor.TRANSPARENT,
              child: Center(
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColor.BLUE_TEXT,
                      ),
                      if (msg.isNotEmpty) ...[
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        Text(
                          msg,
                          textAlign: TextAlign.center,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            );
          }).then((value) => isPopLoading = false);
    }
  }

  void openSettingDialog() async {
    final String imgId = UserHelper.instance.getAccountInformation().imgId;
    final String fullName = UserHelper.instance.getUserFullName().trim();
    final String phoneNo = StringUtils.instance
        .formatPhoneNumberVN(UserHelper.instance.getPhoneNo().trim());
    return await showDialog(
        barrierDismissible: true,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: 250,
                height: 350,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColor.GREY_TEXT,
                          size: 15,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (imgId.isNotEmpty)
                                ? ImageUtils.instance.getImageNetWork(imgId)
                                : Image.asset('assets/images/ic-avatar.png')
                                    .image),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Xin chào, $fullName!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 3)),
                    Text(
                      phoneNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.GREY_TEXT,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        color: AppColor.GREY_VIEW,
                      ),
                    ),
                    const Spacer(),
                    ButtonWidget(
                      text: 'Đăng xuất',
                      height: 40,
                      fontSize: 13,
                      textColor: AppColor.RED_TEXT,
                      bgColor: AppColor.TRANSPARENT,
                      function: () async {
                        await _logoutRepository.logout().then(
                          (value) {
                            // js.context.callMethod('logoutUser');
                            Navigator.pop(context);
                            if (value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void openRegisterDialog() async {
    return await showDialog(
        barrierDismissible: true,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: 250,
                height: 350,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Image.asset(
                      'assets/images/logo-register-user.png',
                      width: 200,
                    ),
                    const Text(
                      'Xin chào!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    const Text(
                      'Bạn chưa đăng ký tài khoản VietQR VN. Hãy đăng ký tài khoản để trải nghiệm các tính năng mà chúng tôi mang lại.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    ButtonWidget(
                      text: 'Đăng ký tài khoản',
                      height: 40,
                      width: 200,
                      borderRadius: 5,
                      fontSize: 13,
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.BLUE_TEXT,
                      function: () async {
                        String url =
                            'https://vietqr.vn/register'; // Đường liên kết bạn muốn mở
                        // window.open(url, '_blank');
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                    ButtonWidget(
                      text: 'Đóng',
                      height: 40,
                      width: 200,
                      borderRadius: 5,
                      fontSize: 13,
                      textColor: AppColor.BLACK,
                      bgColor: AppColor.GREY_VIEW,
                      function: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void openMsgDialog({required String title, required String message}) async {
    return await showDialog(
        barrierDismissible: true,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: 250,
                height: 320,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Image.asset(
                      'assets/images/ic-notice.png',
                      width: 80,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    ButtonWidget(
                      text: 'Trang chủ',
                      height: 40,
                      width: 200,
                      borderRadius: 5,
                      fontSize: 13,
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.BLUE_TEXT,
                      function: () async {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                    ButtonWidget(
                      text: 'Đóng',
                      height: 40,
                      width: 200,
                      borderRadius: 5,
                      fontSize: 13,
                      textColor: AppColor.BLACK,
                      bgColor: AppColor.GREY_VIEW,
                      function: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
