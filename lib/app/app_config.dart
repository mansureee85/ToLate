/// Application environment and configuration settings.
class AppConfig {
  final String appVersion;
  final String buildNumber;
  final String apiBaseUrl;
  final bool enableVoiceToText;
  final bool enableVideoUploads;
  final bool isProduction;

  const AppConfig({
    this.appVersion = '1.0.0',
    this.buildNumber = '1',
    this.apiBaseUrl = 'https://api.tolate.bd',
    this.enableVoiceToText = true,
    this.enableVideoUploads = true,
    this.isProduction = false,
  });

  static AppConfig? _instance;
  static AppConfig get instance => _instance ?? const AppConfig();

  static void initialize(AppConfig config) {
    _instance = config;
  }
}
