import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/services/shared_preferences/account_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';

class ImageUtils {
  const ImageUtils._privateConsrtructor();

  static const ImageUtils _instance = ImageUtils._privateConsrtructor();

  static ImageUtils get instance => _instance;

  //
  NetworkImage getImageNetWork(String imageId) {
    return NetworkImage(
      '${EnvConfig.getBaseUrl()}images/$imageId',
      headers: {"Authorization": 'Bearer ${AccountHelper.instance.getToken()}'},
      scale: 1.0,
    );
  }

  CachedNetworkImageProvider getImageNetworkCache(String imageId) {
    return CachedNetworkImageProvider(
      '${EnvConfig.getBaseUrl()}images/$imageId',
      headers: {"Authorization": 'Bearer ${AccountHelper.instance.getToken()}'},
      cacheKey: const Uuid().v4(),
    );
  }
}
