import 'package:viet_qr_plugin/commons/env/evn.dart';
import 'package:viet_qr_plugin/commons/env/prod_evn.dart';
import 'package:viet_qr_plugin/commons/env/stg_env.dart';
import 'package:viet_qr_plugin/enums/env_type.dart';

class EnvConfig {
  static final Env _env = (getEnv() == EnvType.STG) ? StgEnv() : ProdEnv();

  static String getBankUrl() {
    return _env.getBankUrl();
  }

  static String getBaseUrl() {
    return _env.getBaseUrl();
  }

  static String getUrl() {
    return _env.getUrl();
  }

  static String getImagePrefixUrl() {
    return _env.getImagePrefixUrl();
  }

  static EnvType getEnv() {
    // const EnvType env = EnvType.STG;
    const EnvType env = EnvType.PROD;
    return env;
  }
}
