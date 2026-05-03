import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'create_course.dart';
import 'instructor_courses.dart';
import '../logout.dart';

class InstructorDashboard extends StatelessWidget {
  final String email;
  final String name;

  const InstructorDashboard({
    super.key,
    required this.email,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      body: Column(
        children: [

          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // LEFT SIDE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Welcome, $name 👋",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                // RIGHT SIDE
                Row(
                  children: [

                    // 👤 PROFILE BUTTON
                    IconButton(
                      icon: const Icon(Icons.person, color: Colors.white),
                      onPressed: () {
                        showProfile(context);
                      },
                    ),

                    // 🔴 LOGOUT BUTTON
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LogoutPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 📊 BODY
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 📊 STATS
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('courses')
                        .where('instructorEmail', isEqualTo: email)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final courses = snapshot.data!.docs;
                      final total = courses.length;
                      final published = courses
                          .where((c) => c['isPublished'] == true)
                          .length;
                      final drafts = total - published;

                      return Row(
                        children: [
                          statCard("Total", total, Icons.book),
                          const SizedBox(width: 12),
                          statCard("Published", published, Icons.check),
                          const SizedBox(width: 12),
                          statCard("Drafts", drafts, Icons.edit),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 35),

                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      actionCard(
                        context,
                        "Create Course",
                        Icons.add,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CreateCoursePage(instructorEmail: email),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 15),
                      actionCard(
                        context,
                        "My Courses",
                        Icons.menu_book,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  InstructorCoursesPage(instructorEmail: email),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 📊 STAT CARD
  Widget statCard(String title, int value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ⚡ ACTION CARD
  Widget actionCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 👤 PROFILE POPUP
  void showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Instructor Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Name: $name"),
            const SizedBox(height: 10),
            Text("Email: $email"),
          ],
        ),
      ),
    );
  }
}