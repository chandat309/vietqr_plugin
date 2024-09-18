import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/numeral.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';

class GuildingChangeLanguage extends StatelessWidget {
  const GuildingChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    // const double width = Numeral.DEFAULT_SCREEN_WIDTH;
    // const double height = Numeral.DEFAULT_SCREEN_HEIGHT;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.WHITE,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'Windows',
                  height: 30,
                ),
                Tab(
                  text: 'MacOs',
                  height: 30,
                ),
                Tab(
                  text: 'Linux',
                  height: 30,
                ),
              ],
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
            title: const Center(
              child: Text(
                'Hướng dẫn cài đặt\n tiếng Việt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
            ),
            actions: [
              Image.asset(
                'assets/images/logo-vietqr.png',
                height: 50,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _buildWindowsContent(height, width),
            _buildMacOSContent(height, width),
            _buildLinuxContent(height, width),
          ],
        ),
      ),
    );
  }

  Widget _buildMacOSContent(double height, double width) {
    return SizedBox(
      width: width,
      height: height,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SelectionArea(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 11, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Bước 1: Mở System Preferences\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Nhấn vào biểu tượng Apple ở góc trái trên cùng và chọn ',
                        ),
                        TextSpan(
                          text: 'System Preferences',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: '.\n\n'),
                        TextSpan(
                          text: 'Bước 2: Đi đến Language & Region\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: 'Trong cửa sổ System Preferences, chọn ',
                        ),
                        TextSpan(
                          text: 'Language & Region',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: '.\n\n'),
                        TextSpan(
                          text: 'Bước 3: Thêm Tiếng Việt\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Nhấp vào dấu "+" ở góc dưới bên trái, tìm và chọn "Tiếng Việt", sau đó nhấn Add.\n\n',
                        ),
                        TextSpan(
                          text:
                              'Bước 4: Thiết lập Tiếng Việt làm ngôn ngữ chính (tuỳ chọn)\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Bạn sẽ được hỏi có muốn đặt Tiếng Việt làm ngôn ngữ chính hay không. '
                              'Nhấn vào "Use Vietnamese" để thay đổi hoặc "Use English" để giữ nguyên.\n\n',
                        ),
                        TextSpan(
                          text: 'Bước 5: Khởi động lại ứng dụng\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Một số ứng dụng có thể yêu cầu khởi động lại để áp dụng ngôn ngữ mới.\n\n',
                        ),
                        TextSpan(
                          text: 'Bước 6: Hoàn thành\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Sau khi hoàn tất các bước trên, giao diện MacOS sẽ hiển thị bằng Tiếng Việt.\n',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLinuxContent(double height, double width) {
    return SizedBox(
      width: width,
      height: height,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SelectionArea(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 11, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              'Bước 1: Mở Cài Đặt Hệ Thống (System Settings)\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        TextSpan(
                          text:
                              'Mở Cài đặt hoặc Tùy chọn hệ thống từ menu hệ thống hoặc tìm kiếm "Settings" trong launcher.\n\n',
                        ),
                        TextSpan(
                          text: 'Bước 2: Chọn "Region & Language"\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        TextSpan(
                          text:
                              'Trong cửa sổ cài đặt, tìm và chọn "Region & Language" hoặc "Language Support".\n\n',
                        ),
                        TextSpan(
                          text: 'Bước 3: Thêm Ngôn Ngữ Tiếng Việt\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        TextSpan(
                          text:
                              'Nhấn dấu "+" và tìm kiếm Tiếng Việt trong danh sách, rồi nhấn "Add" hoặc "Install".\n\n',
                        ),
                        TextSpan(
                          text:
                              'Bước 4: Đặt Tiếng Việt làm Ngôn Ngữ Mặc Định (Tuỳ chọn)\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        TextSpan(
                          text:
                              'Sau khi thêm, bạn có thể đặt Tiếng Việt làm ngôn ngữ mặc định bằng cách chọn "Set as default".\n\n',
                        ),
                        TextSpan(
                          text: 'Bước 5: Cài Đặt Bàn Phím Tiếng Việt\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        TextSpan(
                          text:
                              'Đi đến phần "Keyboard Layout" hoặc "Input Sources", chọn "Vietnamese" như Telex, VNI.\n\n',
                        ),
                        TextSpan(
                          text: 'Bước 6: Khởi Động Lại\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        TextSpan(
                          text:
                              'Đăng xuất hoặc khởi động lại máy để áp dụng thay đổi.\n\n',
                        ),
                        TextSpan(
                          text: 'Bước 7: Hoàn thành\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        TextSpan(
                          text:
                              'Sau khi hoàn tất các bước trên, giao diện Linux sẽ hiển thị bằng Tiếng Việt.\n',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWindowsContent(
    double height,
    double width,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SelectionArea(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 11),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Bước 1: Mở Cài đặt (Settings)\n',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.BLACK,
                          ),
                        ),
                        TextSpan(
                          text:
                              '1. Nhấn tổ hợp phím Windows + I để mở Cài đặt.\n'
                              '2. Chọn Thời gian & Ngôn ngữ (Time & Language).\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Bước 2: Cài đặt ngôn ngữ Tiếng Việt\n',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.BLACK,
                          ),
                        ),
                        TextSpan(
                          text:
                              '1. Chọn mục Ngôn ngữ (Language) ở phía bên trái.\n'
                              '2. Ở phần Ngôn ngữ ưa thích (Preferred languages), nhấn vào nút Thêm ngôn ngữ (Add a language).\n'
                              '3. Tìm Tiếng Việt trong danh sách hoặc gõ “Vietnamese” vào ô tìm kiếm.\n'
                              '4. Chọn Tiếng Việt và nhấn Tiếp tục (Next).\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Bước 3: Cài đặt gói ngôn ngữ\n',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.BLACK,
                          ),
                        ),
                        TextSpan(
                          text:
                              '1. Tích chọn mục Cài đặt gói ngôn ngữ (Install language pack).\n'
                              '2. Bạn có thể chọn Đặt làm ngôn ngữ hiển thị của Windows (Set as my Windows display language) nếu muốn giao diện Windows chuyển sang Tiếng Việt.\n'
                              '3. Nhấn Cài đặt (Install).\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Bước 4: Đăng xuất và đăng nhập lại\n',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.BLACK,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Sau khi cài đặt hoàn tất, nếu bạn đã chọn Tiếng Việt làm ngôn ngữ hiển thị, Windows có thể yêu cầu bạn đăng xuất và đăng nhập lại để thay đổi có hiệu lực.\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Bước 6: Hoàn thành\n',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.BLACK,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Sau khi hoàn tất các bước trên, giao diện Windows sẽ hiển thị bằng Tiếng Việt.\n',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
