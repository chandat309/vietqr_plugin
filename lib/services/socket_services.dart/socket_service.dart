import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:viet_qr_plugin/commons/configurations/stringify.dart';
import 'package:viet_qr_plugin/main.dart';
import 'package:viet_qr_plugin/models/notify_trans_dto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:viet_qr_plugin/utils/log.dart';
import 'package:viet_qr_plugin/widgets/dialog_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../navigator/app_navigator.dart';

class SocketService {
  SocketService._privateConstructor();

  static final SocketService _instance = SocketService._privateConstructor();

  static SocketService get instance => _instance;

  static WebSocketChannel? _channelTransaction;

  WebSocketChannel? get channelTransaction => _channelTransaction;

  String get userId => UserHelper.instance.getUserId();

  BuildContext get context => NavigationService.context!;

  static const int _port = 8443;
  Socket? _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Socket? get socket => _socket;

  void init() async {
    if (userId.isEmpty) return;
    if (_channelTransaction != null && _channelTransaction?.closeCode == null) {
      return;
    }
    try {
      Uri wsUrl = Uri.parse('wss://api.vietqr.org/vqr/socket?userId=$userId');

      _channelTransaction = WebSocketChannel.connect(wsUrl);

      if (_channelTransaction?.closeCode == null) {
        _channelTransaction?.stream.listen((event) async {
          var data = jsonDecode(event);

          if (_isConnected) {
            _isConnected = false;
            Navigator.pop(context);
          }

          if (data['notificationType'] != null &&
              data['notificationType'] ==
                  Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
            print('---------kaka $data');

            // DialogWidget.instance.showModelBottomSheet(
            //   isDismissible: true,
            //   margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            //   height: MediaQuery.of(context).size.height * 0.9,
            //   borderRadius: BorderRadius.circular(16),
            //   widget: NotifyTransWidget(
            //     dto: NotifyTransDTO.fromJson(data),
            //   ),
            // );

            // MediaHelper.instance.playAudio(data);
            final FlutterTts flutterTts = FlutterTts();
               await flutterTts.stop(); // Dừng phát âm thanh trước đó
              // if (voiceMobile && isValidAmount) {
              //   // Kiểm tra trạng thái trước khi đọc văn bản
              //   await flutterTts.setLanguage("vi-VN");
              //   await flutterTts.setPitch(1.0);
              //   await flutterTts.speak(text);
              // }
                 // Kiểm tra trạng thái trước khi đọc văn bản
                await flutterTts.setLanguage("vi-VN");
                await flutterTts.setPitch(1.0);
                final  text = '${NotifyTransDTO.fromJson(data).amount.replaceAll(',', '')} đồng';
                await flutterTts.speak(text);
          }
          notificationController.sink.add(true);
        }).onError(
          (error) async {
            debugPrint('ws error $error');
          },
        );
      }
    } catch (e) {
      LOG.error('WS: $e');
    }
  }

  void updateConnect(bool value) {
    _isConnected = value;
  }

  void closeListenTransaction() async {
    _channelTransaction?.sink.close();
    _channelTransaction = null;
  }
}
