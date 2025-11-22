# SummerSplash Field App

Professional mobile application for pool maintenance and safety management with GPS verification and offline capabilities.

## Features

### Core Functionality
- **GPS-Verified Clock In/Out**: Location-based time tracking
- **Offline Mode**: Full offline capability with automatic sync when online
- **Role-Based Access**: Lifeguards, Service Technicians, Managers, Supervisors
- **Photo Documentation**: Geotagged photos for service verification

### Service Technician Features
- Maintenance checklists
- Chemical readings tracking (chlorine, pH, alkalinity)
- Equipment inspection logs
- Work order management

### Lifeguard Features
- Safety audit checklists
- Incident reporting
- Pool condition monitoring

### Management Features
- Real-time notifications
- Employee tracking
- Service report review
- Performance analytics

## Technology Stack
- **Framework**: Flutter/Dart
- **State Management**: BLoC pattern
- **Local Database**: Hive (offline storage)
- **Geolocation**: Geolocator package
- **Push Notifications**: Firebase Cloud Messaging
- **HTTP Client**: Dio
- **Image Handling**: Image Picker with geotags
- **UI**: Material Design

## Architecture
Clean separation of concerns with BLoC pattern for scalable state management.

## License
MIT License
