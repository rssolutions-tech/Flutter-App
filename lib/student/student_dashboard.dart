import 'package:flutter/material.dart';
import 'course_page.dart';
import 'quiz_page.dart';
import 'profile_page.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  Widget buildTile(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 20, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              "Welcome 👋\nStudent Dashboard",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  // ✅ Only valid pages
                  _TileWrapper(title: "Courses", icon: Icons.menu_book, color: Colors.blue, page: CoursePage()),
                  _TileWrapper(title: "Quiz", icon: Icons.quiz, color: Colors.green, page: QuizPage()),
                  _TileWrapper(title: "Profile", icon: Icons.person, color: Colors.orange, page: ProfilePage()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 🔧 Helper widget to avoid const issues
class _TileWrapper extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget page;

  const _TileWrapper({
    required this.title,
    required this.icon,
    required this.color,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}