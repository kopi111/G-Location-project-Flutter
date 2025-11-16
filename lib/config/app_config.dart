/// Application configuration constants
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:5000/api';
  static const String apiVersion = 'v1';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh-token';
  static const String logoutEndpoint = '/auth/logout';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String sendVerificationCodeEndpoint = '/auth/send-verification-code';
  static const String verifyCodeEndpoint = '/auth/verify-code';

  static const String locationsEndpoint = '/locations';
  static const String nearbyLocationsEndpoint = '/locations/nearby';

  static const String timeEntriesEndpoint = '/time-entries';
  static const String clockInEndpoint = '/time-entries/clock-in';
  static const String clockOutEndpoint = '/time-entries/clock-out';
  static const String activeClockInEndpoint = '/time-entries/active';

  // App Settings
  static const String appName = 'SummerSplash Field';
  static const String appVersion = '1.0.0';

  // GPS Settings
  static const double defaultGPSRadius = 100.0; // meters
  static const double gpsAccuracyThreshold = 50.0; // meters

  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String lastSyncKey = 'last_sync';

  // Hive Box Names
  static const String userBoxName = 'user_box';
  static const String checklistBoxName = 'checklist_box';
  static const String safetyAuditBoxName = 'safety_audit_box';
  static const String timeEntryBoxName = 'time_entry_box';
  static const String locationBoxName = 'location_box';

  // Photo Settings
  static const int maxPhotoSizeMB = 5;
  static const int photoQuality = 85; // 0-100
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];

  // Offline Sync Settings
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxRetryAttempts = 3;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
