import 'package:flutter/material.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const HomePage({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🌈 HERO SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.black, Colors.grey.shade900]
                      : [const Color(0xFF5B86E5), const Color(0xFF36D1DC)],
                ),
              ),
              child: Column(
                children: [

                  // 🔷 HEADER NAV
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "EduNexus",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("About", style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("How it Works", style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Contact", style: TextStyle(color: Colors.white)),
                          ),

                          IconButton(
                            onPressed: onToggleTheme,
                            icon: Icon(
                              isDark ? Icons.light_mode : Icons.dark_mode,
                              color: Colors.white,
                            ),
                          ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text("Login"),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // HERO CONTENT
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Future-Ready Learning\nStarts Here",
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Master in-demand skills with interactive courses, quizzes, and progress tracking.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.asset("assets/images/edu.png", height: 260),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // 🧊 FEATURES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  GlassCard(Icons.auto_graph, "Skill-Based Learning"),
                  GlassCard(Icons.psychology, "AI Quizzes"),
                  GlassCard(Icons.workspace_premium, "Certifications"),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 📖 ABOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "About EduNexus",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "EduNexus is a modern e-learning platform where students can learn, practice, and track their progress using courses and quizzes.",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // ⚙️ HOW IT WORKS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "How It Works",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      StepCard("1", "Register", Icons.person_add),
                      StepCard("2", "Enroll", Icons.school),
                      StepCard("3", "Learn", Icons.menu_book),
                      StepCard("4", "Track", Icons.show_chart),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 📚 COURSES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  CourseCard("Web Development", "assets/images/web.png"),
                  CourseCard("Machine Learning", "assets/images/ml.png"),
                  CourseCard("Cloud Computing", "assets/images/cloud.png"),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 📞 CONTACT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: const [
                  Text(
                    "Contact Us",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Email: support@edunexus.com"),
                  Text("Phone: +91 9876543210"),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 🔻 FOOTER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              color: Colors.black,
              child: const Text(
                "© 2026 EduNexus | All Rights Reserved",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🧊 FEATURE CARD
class GlassCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const GlassCard(this.icon, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 12),
          Text(title),
        ],
      ),
    );
  }
}

// ⚙️ STEP CARD
class StepCard extends StatelessWidget {
  final String step;
  final String title;
  final IconData icon;

  const StepCard(this.step, this.title, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        children: [
          CircleAvatar(child: Text(step)),
          const SizedBox(height: 10),
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }
}

// 🎓 COURSE CARD
class CourseCard extends StatelessWidget {
  final String title;
  final String image;

  const CourseCard(this.title, this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(child: Image.asset(image, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}