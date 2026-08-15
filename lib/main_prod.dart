import 'package:ecomm/core/config/app_config.dart';
import 'package:ecomm/main.dart';

void main() {
  AppConfig.initialize(
    environment: EnvironmentType.prod,
    apiBaseUrl: 'https://dummyjson.com',
    appTitle: 'Ecomm',
    enableDioLogging: false,
  );

  mainCommon();
}
