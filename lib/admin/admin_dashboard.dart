import 'package:flutter/material.dart';

import 'user_management.dart';
import 'admin_profile.dart';
import 'analytics_reports.dart';
import 'course_monitoring.dart';
import 'notification_page.dart';
import 'add_instructor.dart';
import '../logout.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 35,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5B7FFF), Color(0xFF39D2C0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LEFT TEXT
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Admin 👋",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Manage platform settings and reports",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),

                    // RIGHT ICONS
                    Row(
                      children: [
                        // PROFILE
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminProfile(),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // LOGOUT
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LogoutPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= FIRST ROW =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _dashboardCard(
                        context,
                        "User Management",
                        Icons.people,
                        const UserManagement(),
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: _dashboardCard(
                        context,
                        "Analytics",
                        Icons.bar_chart,
                        const AnalyticsReports(),
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: _dashboardCard(
                        context,
                        "Course Monitoring",
                        Icons.menu_book,
                        const CourseMonitoring(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ================= SECOND ROW =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const SizedBox(width: 20),

                    Expanded(
                      child: _dashboardCard(
                        context,
                        "Notifications",
                        Icons.notifications,
                        const NotificationPage(),
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: _dashboardCard(
                        context,
                        "Add Instructor",
                        Icons.person_add,
                        const AddInstructorPage(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DASHBOARD CARD =================

  Widget _dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),

      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },

      child: Container(
        height: 220,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5B7FFF), Color(0xFF39D2C0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),

          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
