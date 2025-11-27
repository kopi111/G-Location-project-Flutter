import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../auth/login_screen.dart';
import 'lifeguard_dashboard.dart';
import 'service_tech_dashboard.dart';
import 'manager_dashboard.dart';

/// Dashboard Router - Routes users to appropriate dashboard based on role
class DashboardRouter extends StatelessWidget {
  final User user;

  const DashboardRouter({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated || state is AuthLogoutSuccess) {
          // Navigate to login screen and clear the navigation stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: _buildDashboard(),
    );
  }

  Widget _buildDashboard() {
    // Route to appropriate dashboard based on user role
    if (user.isManager) {
      return ManagerDashboard(user: user);
    } else if (user.isServiceTech) {
      return ServiceTechDashboard(user: user);
    } else if (user.isLifeguard) {
      return LifeguardDashboard(user: user);
    } else {
      // Default to lifeguard dashboard for unknown roles
      return LifeguardDashboard(user: user);
    }
  }
}
