import 'package:flutter/material.dart';
import '../../models/user_model.dart';
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
