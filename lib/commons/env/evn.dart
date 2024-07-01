//env version 1.0
//env will upgrade to 2.0 version that is using flavor to manage multiple environments.

abstract class Env {
  String getBaseUrl();
  String getBankUrl();
  String getUrl();
  String getImagePrefixUrl();
}
