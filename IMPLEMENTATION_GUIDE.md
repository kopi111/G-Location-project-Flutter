# Implementation Guide for Developers

This guide helps developers understand the architecture and how to implement remaining features.

## Architecture Overview

### Technology Stack
- **Framework**: Flutter 3.9.2+
- **State Management**: BLoC (Business Logic Component) pattern
- **Local Database**: Hive (NoSQL)
- **HTTP Client**: Dio
- **Backend API**: .NET 8 Web API

### Design Patterns
1. **BLoC Pattern**: Separation of business logic from UI
2. **Repository Pattern**: Data access abstraction
3. **Service Layer**: API communication
4. **Model Layer**: Data structures

## Project Structure Explained

\`\`\`
lib/
├── blocs/              # State management (BLoC)
│   ├── auth/          # Authentication logic
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   └── [other blocs to create]
│
├── config/            # App-wide configuration
│   ├── app_config.dart    # API endpoints, constants
│   └── app_theme.dart     # Theme, colors, styles
│
├── models/            # Data models
│   ├── user_model.dart
│   ├── location_model.dart
│   ├── time_entry_model.dart
│   ├── checklist_model.dart
│   └── safety_audit_model.dart
│
├── screens/           # UI screens (TO BE IMPLEMENTED)
│   ├── auth/
│   ├── dashboard/
│   ├── checklist/
│   └── profile/
│
├── services/          # Business logic & API
│   ├── api/
│   │   ├── api_client.dart      # HTTP client
│   │   └── auth_service.dart     # Auth API calls
│   ├── gps/
│   │   └── location_service.dart # GPS logic
│   └── local_storage/
│       └── [to implement]
│
├── widgets/           # Reusable UI components (TO BE IMPLEMENTED)
└── main.dart          # App entry point
\`\`\`

## How to Implement a New Screen

### Example: Login Screen

#### Step 1: Create the Screen File

Create \`lib/screens/auth/login_screen.dart\`:

\`\`\`dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to dashboard
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => DashboardScreen(user: state.user),
              ),
            );
          } else if (state is AuthError) {
            // Show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.oceanGradient,
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          const Icon(
                            Icons.pool,
                            size: 80,
                            color: AppTheme.primaryBlue,
                          ),
                          const SizedBox(height: 16),
                          
                          // Title
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Login Button
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleLogin,
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Login'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Forgot Password Link
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password
                            },
                            child: const Text('Forgot Password?'),
                          ),
                          
                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an account? '),
                              TextButton(
                                onPressed: () {
                                  // Navigate to register
                                },
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
\`\`\`

#### Step 2: Update main.dart

Replace the placeholder LoginScreen with your new one.

#### Step 3: Test

\`\`\`bash
flutter run
\`\`\`

## How to Create a New BLoC

### Example: Location BLoC

#### Step 1: Define States

Create \`lib/blocs/location/location_state.dart\`:

\`\`\`dart
import 'package:equatable/equatable.dart';
import '../../models/location_model.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final List<Location> locations;
  
  const LocationLoaded(this.locations);
  
  @override
  List<Object?> get props => [locations];
}

class LocationError extends LocationState {
  final String message;
  
  const LocationError(this.message);
  
  @override
  List<Object?> get props => [message];
}
\`\`\`

#### Step 2: Define Events

Create \`lib/blocs/location/location_event.dart\`:

\`\`\`dart
import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
  
  @override
  List<Object?> get props => [];
}

class LocationLoadRequested extends LocationEvent {
  const LocationLoadRequested();
}

class LocationNearbyRequested extends LocationEvent {
  final double latitude;
  final double longitude;
  final double maxDistance;
  
  const LocationNearbyRequested({
    required this.latitude,
    required this.longitude,
    this.maxDistance = 1000,
  });
  
  @override
  List<Object?> get props => [latitude, longitude, maxDistance];
}
\`\`\`

#### Step 3: Implement BLoC

Create \`lib/blocs/location/location_bloc.dart\`:

\`\`\`dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api/location_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService;
  
  LocationBloc(this._locationService) : super(const LocationInitial()) {
    on<LocationLoadRequested>(_onLocationLoadRequested);
    on<LocationNearbyRequested>(_onLocationNearbyRequested);
  }
  
  Future<void> _onLocationLoadRequested(
    LocationLoadRequested event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());
    
    try {
      final locations = await _locationService.getLocations();
      emit(LocationLoaded(locations));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
  
  Future<void> _onLocationNearbyRequested(
    LocationNearbyRequested event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());
    
    try {
      final locations = await _locationService.getNearbyLocations(
        event.latitude,
        event.longitude,
        event.maxDistance,
      );
      emit(LocationLoaded(locations));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
\`\`\`

## Working with Offline Storage (Hive)

### Step 1: Create Hive Service

Create \`lib/services/local_storage/hive_service.dart\`:

\`\`\`dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../config/app_config.dart';
import '../../models/checklist_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters (after generating with build_runner)
    // Hive.registerAdapter(ServiceChecklistAdapter());
    
    // Open boxes
    await Hive.openBox(AppConfig.checklistBoxName);
  }
  
  Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }
  
  Future<void> saveChecklist(ServiceChecklist checklist) async {
    final box = Hive.box(AppConfig.checklistBoxName);
    await box.put(checklist.id, checklist.toJson());
  }
  
  ServiceChecklist? getChecklist(String id) {
    final box = Hive.box(AppConfig.checklistBoxName);
    final data = box.get(id);
    if (data == null) return null;
    return ServiceChecklist.fromJson(data as Map<String, dynamic>);
  }
  
  List<ServiceChecklist> getAllChecklists() {
    final box = Hive.box(AppConfig.checklistBoxName);
    return box.values
        .map((e) => ServiceChecklist.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
\`\`\`

## API Integration Pattern

All API services follow this pattern:

\`\`\`dart
import '../api/api_client.dart';
import '../../models/your_model.dart';

class YourService {
  final ApiClient _apiClient;
  
  YourService(this._apiClient);
  
  Future<YourModel> getSomething() async {
    final response = await _apiClient.get('/your-endpoint');
    
    if (response.data['success'] == true) {
      return YourModel.fromJson(response.data['data']);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Operation failed',
        statusCode: response.statusCode ?? 400,
      );
    }
  }
}
\`\`\`

## Testing Guidelines

### Unit Test Example

Create \`test/models/user_model_test.dart\`:

\`\`\`dart
import 'package:flutter_test/flutter_test.dart';
import 'package:summersplash_field_app/models/user_model.dart';

void main() {
  group('User Model', () {
    test('fromJson creates valid user', () {
      final json = {
        'userId': 1,
        'email': 'test@example.com',
        'firstName': 'John',
        'lastName': 'Doe',
        'roleName': 'Lifeguard',
        'token': 'abc123',
        'refreshToken': 'def456',
        'tokenExpiry': '2025-12-31T23:59:59Z',
        'emailVerified': true,
      };
      
      final user = User.fromJson(json);
      
      expect(user.userId, 1);
      expect(user.email, 'test@example.com');
      expect(user.fullName, 'John Doe');
      expect(user.role, UserRole.lifeguard);
    });
  });
}
\`\`\`

## Common Pitfalls to Avoid

1. **Don't mix UI and business logic** - Use BLoCs
2. **Don't make API calls directly from widgets** - Use services
3. **Don't forget to dispose controllers** - Memory leaks
4. **Don't hardcode strings** - Use constants
5. **Always validate user input** - Security
6. **Handle errors gracefully** - User experience
7. **Test offline scenarios** - Reliability

## Best Practices

1. **Use const constructors** where possible (performance)
2. **Follow Dart naming conventions**
   - Classes: PascalCase
   - Variables: camelCase
   - Files: snake_case.dart
3. **Add comments for complex logic**
4. **Keep widgets small** - Extract to separate widgets
5. **Use async/await** properly
6. **Handle loading states** in UI
7. **Provide feedback** for user actions

## Next Steps

1. Start with login screen implementation
2. Create location BLoC
3. Implement service tech dashboard
4. Build checklist screens
5. Add offline storage
6. Implement sync service

## Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [BLoC Library](https://bloclibrary.dev)
- [Hive Documentation](https://docs.hivedb.dev)
- [Dio Package](https://pub.dev/packages/dio)

---

Happy Coding! 🚀
