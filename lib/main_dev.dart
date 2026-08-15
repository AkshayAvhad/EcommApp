import 'package:ecomm/core/config/app_config.dart';
import 'package:ecomm/main.dart';

void main() {
  AppConfig.initialize(
    environment: EnvironmentType.dev,
    apiBaseUrl: 'https://dummyjson.com',
    appTitle: 'EComm (DEV)',
    enableDioLogging: true,
  );

  mainCommon();
}
