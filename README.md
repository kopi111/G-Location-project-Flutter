# SummerSplash Field App

A comprehensive Flutter mobile application for managing pool maintenance and safety operations with role-based access, GPS features, and offline capability.

## Features

### Core Functionality
- **Role-Based Access Control**: Separate dashboards for Lifeguards, Service Technicians, Managers, and Supervisors
- **GPS-Based Clock In/Out**: Location verification for time tracking
- **Offline Capability**: Full functionality without internet connection with automatic sync
- **Service Technician Checklists**: Complete pool maintenance task management
- **Chemical Readings**: Track and record water chemistry
- **Photo Documentation**: Capture timestamped, geotagged photos
- **Safety Audits**: Manager/Supervisor safety inspection module
- **Push Notifications**: Real-time task assignments and updates

### User Roles & Dashboards

#### 1. Lifeguard/Pool Attendant
- View job location and schedule
- Clock in/out with GPS verification
- View hours worked
- Contact supervisor

#### 2. Service Technician
- GPS-verified clock in/out
- Dynamic maintenance checklist
- Chemical readings (Chlorine, pH, Hardness, Alkalinity, etc.)
- Supply ordering system
- Mandatory photo upload (5 geotagged photos)
- Pool gate lock verification
- Notes section

#### 3. Manager/Supervisor/Safety Audit
- Site evaluation and safety checklist
- Staff status monitoring
- Discussion confirmations (Scanning, Breaks, Cellphone Policy)
- Safety concerns reporting

## Project Structure

\`\`\`
lib/
├── blocs/                   # State management
│   ├── auth/               # Authentication BLoC
│   ├── location/           # Location management BLoC
│   ├── time_entry/         # Time tracking BLoC
│   └── checklist/          # Checklist management BLoC
├── config/                  # Configuration files
│   ├── app_config.dart     # API endpoints & constants
│   └── app_theme.dart      # Theme & styling
├── models/                  # Data models
│   ├── user_model.dart
│   ├── location_model.dart
│   ├── time_entry_model.dart
│   ├── checklist_model.dart
│   └── safety_audit_model.dart
├── screens/                 # UI screens
│   ├── auth/               # Login, Registration
│   ├── dashboard/          # Role-based dashboards
│   ├── checklist/          # Service technician checklists
│   └── profile/            # User profile
├── services/                # Business logic
│   ├── api/                # API services
│   ├── gps/                # GPS services
│   └── local_storage/      # Offline storage
├── widgets/                 # Reusable widgets
└── main.dart               # App entry point
\`\`\`

## Setup Instructions

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Android Studio / VS Code with Flutter extensions
- Firebase account (for push notifications)

### Installation Steps

1. **Install Dependencies**
   \`\`\`bash
   flutter pub get
   \`\`\`

2. **Configure API Endpoint**

   Edit \`lib/config/app_config.dart\`:
   \`\`\`dart
   static const String apiBaseUrl = 'https://your-api-url.com/api';
   \`\`\`

3. **Setup Firebase (for Push Notifications)**

   - Create a Firebase project
   - Add Android app (download \`google-services.json\` to \`android/app/\`)
   - Add iOS app (download \`GoogleService-Info.plist\` to \`ios/Runner/\`)
   - Enable Cloud Messaging

4. **Run the App**
   \`\`\`bash
   flutter run
   \`\`\`

## API Endpoints

The app connects to the GLocation API with the following endpoints:

- **Auth**: \`/api/auth/login\`, \`/api/auth/register\`, \`/api/auth/logout\`
- **Locations**: \`/api/locations\`, \`/api/locations/nearby\`
- **Time Entries**: \`/api/time-entries/clock-in\`, \`/api/time-entries/clock-out\`

## Key Features Implementation

### State Management (BLoC Pattern)
All state is managed using the BLoC pattern for predictable, testable code.

### Offline Storage (Hive)
Local database stores all data for offline access with automatic sync.

### GPS Verification
Geofencing ensures users are at the correct location before clocking in.

## Dependencies

- \`flutter_bloc: ^8.1.3\` - State management
- \`hive: ^2.2.3\` - Local database
- \`geolocator: ^10.1.0\` - GPS positioning
- \`dio: ^5.4.0\` - HTTP client
- \`image_picker: ^1.0.5\` - Photo capture
- \`firebase_messaging: ^14.7.9\` - Push notifications

## Next Steps

This project provides the foundation. To complete the app, implement:

1. **Authentication Screens** (Login, Register, Forgot Password)
2. **Role-Based Dashboards**
3. **Service Technician Checklist UI**
4. **Safety Audit UI**
5. **Photo Capture & Upload**
6. **Time Entry Management**
7. **Sync Service** for offline data

## License

Proprietary - SummerSplash Pool Management
