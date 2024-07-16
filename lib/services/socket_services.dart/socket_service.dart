import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/stringify.dart';
import 'package:viet_qr_plugin/main.dart';
import 'package:viet_qr_plugin/models/notify_trans_dto.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  SocketService._privateConstructor();

  static final SocketService _instance = SocketService._privateConstructor();

  static SocketService get instance => _instance;

  static late WebSocketChannel _channelTransaction;

  WebSocketChannel get channelTransaction => _channelTransaction;

  String get userId => UserHelper.instance.getUserId();

  BuildContext get context => NavigationService.navigatorKey.currentContext!;

  static int _port = 8443;

  Socket? _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Socket? get socket => _socket;

  void init() {
    if (userId.isEmpty) return;
    Uri wsUrl = Uri.parse('wss://api.vietqr.org/vqr/socket?userId=$userId');

    _channelTransaction = WebSocketChannel.connect(wsUrl);

    if (_channelTransaction.closeCode == null) {
      _channelTransaction.stream.listen((event) async {
        var data = jsonDecode(event);

        if (_isConnected) {
          _isConnected = false;
          Navigator.pop(context);
        }

        if (data['notificationType'] != null &&
            data['notificationType'] ==
                Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
          final result = NotifyTransDTO.fromJson(data);
          if (result.transType == 'C') {}
        }
      });
    }
  }

  void updateConnect(bool value) {
    _isConnected = value;
  }

  void closeListenTransaction() {
    _channelTransaction.sink.close();
  }
}
