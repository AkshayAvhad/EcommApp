enum EnvironmentType { dev, prod }

class AppConfig {
  final EnvironmentType environment;
  final String apiBaseUrl;
  final String appTitle;
  final bool enableDioLogging;

  static late AppConfig _instance;

  AppConfig._internal({
    required this.environment,
    required this.apiBaseUrl,
    required this.appTitle,
    required this.enableDioLogging,
  });

  static void initialize({
    required EnvironmentType environment,
    required String apiBaseUrl,
    required String appTitle,
    required bool enableDioLogging,
  }) {
    _instance = AppConfig._internal(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      appTitle: appTitle,
      enableDioLogging: enableDioLogging,
    );
  }

  static AppConfig get instance => _instance;
}
