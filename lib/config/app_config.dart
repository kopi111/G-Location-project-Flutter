/// Application configuration constants
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:5000';
  static const String apiVersion = 'v1';

  // API Endpoints - Mobile API (matches backend MobileApiController)
  static const String loginEndpoint = '/api/mobile/login';
  static const String registerEndpoint = '/api/mobile/register';
  static const String refreshTokenEndpoint = '/api/mobile/refresh-token';
  static const String logoutEndpoint = '/api/mobile/logout';
  static const String forgotPasswordEndpoint = '/api/mobile/forgot-password';
  static const String resetPasswordEndpoint = '/api/mobile/reset-password';
  static const String sendVerificationCodeEndpoint = '/api/mobile/send-verification-code';
  static const String verifyCodeEndpoint = '/api/mobile/verify-code';

  // User endpoints
  static const String userProfileEndpoint = '/api/mobile/profile';
  static const String userStatusEndpoint = '/api/mobile/status';
  static const String userScheduleEndpoint = '/api/mobile/schedule';

  static const String locationsEndpoint = '/api/mobile/locations';
  static const String nearbyLocationsEndpoint = '/api/mobile/locations/nearby';

  static const String timeEntriesEndpoint = '/api/mobile/clock/records';
  static const String clockInEndpoint = '/api/mobile/clock/in';
  static const String clockOutEndpoint = '/api/mobile/clock/out';
  static const String activeClockInEndpoint = '/api/mobile/clock/status';

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
