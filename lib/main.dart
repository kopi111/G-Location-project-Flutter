import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'config/app_theme.dart';
import 'config/app_config.dart';
import 'services/api/api_client.dart';
import 'services/api/auth_service.dart';
import 'services/api/location_api_service.dart';
import 'services/api/time_entry_service.dart';
import 'services/gps/location_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/time_entry/time_entry_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // try {
  //   await Firebase.initializeApp();
  // } catch (e) {
  //   debugPrint('Firebase initialization error: $e');
  // }

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize API Client
  final apiClient = ApiClient(prefs);

  // Initialize Services
  final authService = AuthService(apiClient, prefs);
  final locationService = LocationService();
  final locationApiService = LocationApiService(apiClient);
  final timeEntryService = TimeEntryService(apiClient);

  runApp(
    SummerSplashApp(
      authService: authService,
      apiClient: apiClient,
      locationService: locationService,
      locationApiService: locationApiService,
      timeEntryService: timeEntryService,
    ),
  );
}

class SummerSplashApp extends StatelessWidget {
  final AuthService authService;
  final ApiClient apiClient;
  final LocationService locationService;
  final LocationApiService locationApiService;
  final TimeEntryService timeEntryService;

  const SummerSplashApp({
    super.key,
    required this.authService,
    required this.apiClient,
    required this.locationService,
    required this.locationApiService,
    required this.timeEntryService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: apiClient),
        RepositoryProvider.value(value: locationService),
        RepositoryProvider.value(value: locationApiService),
        RepositoryProvider.value(value: timeEntryService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authService)
              ..add(const AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => TimeEntryBloc(timeEntryService: timeEntryService),
          ),
        ],
        child: MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

/// Splash Screen - Shows loading while checking auth status
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigate to appropriate dashboard based on role
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DashboardRouter(user: state.user),
            ),
          );
        } else if (state is AuthUnauthenticated || state is AuthLogoutSuccess) {
          // Navigate to login screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.oceanGradient,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pool,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 24),
                Text(
                  AppConfig.appName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 48),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

