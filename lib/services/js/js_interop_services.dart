@JS()
library js_interop;

import 'package:js/js.dart';

@JS()
external _setToken(String token);

@JS()
external _alertTransaction(List data);

class JsInteropService {
  setToken(String message) {
    _setToken(message);
  }

  alertTransaction(List data) {
    _alertTransaction(data);
  }
}
