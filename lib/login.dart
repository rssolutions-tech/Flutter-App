import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'session.dart';
import 'student/student_dashboard.dart';
import 'admin/admin_dashboard.dart';
import 'instructor/instructor_dashboard.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  void showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      showError("Please fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      // 🔍 Find user by email
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email.text.trim())
          .get();

      if (query.docs.isEmpty) {
        showError("User not found");
        setState(() => isLoading = false);
        return;
      }

      final doc = query.docs.first;
      final data = doc.data();

      // 🔐 Check password
      if (data['password'] != password.text.trim()) {
        showError("Incorrect password");
        setState(() => isLoading = false);
        return;
      }

      // ✅ STORE SESSION
      Session.userId = doc.id;
      Session.email = data['email'];
      Session.name = data['username'] ?? "User";
      Session.role = data['role'];

      // 🚀 NAVIGATE BASED ON ROLE
      if (Session.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else if (Session.role == 'instructor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => InstructorDashboard(
              email: Session.email!,
              name: Session.name!,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentDashboard()),
        );
      }
    } catch (e) {
      showError("Login failed: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.grey.shade900]
                : [const Color(0xFF5B86E5), const Color(0xFF36D1DC)],
          ),
        ),
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Login",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),

                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text("Login"),
                      ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text("Don't have account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}