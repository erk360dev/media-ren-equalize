class AppConfig {
  static const String appName = 'Hello World';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  
  // App Settings
  static const bool enableLogging = true;
  static const int timeoutDuration = 30; // seconds
  
  // File Processing Settings
  static const List<String> supportedAudioFormats = [
    '.mp3',
    '.wav',
    '.flac',
    '.aac',
    '.ogg'
  ];
  
  static const List<String> supportedVideoFormats = [
    '.mp4',
    '.avi',
    '.mkv',
    '.mov',
    '.wmv'
  ];
}