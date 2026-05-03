import 'package:flutter/material.dart';
import '../session.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ❌ NO FirebaseAuth here
    if (Session.userId == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person,
                  size: 60, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              Session.name ?? "Student",
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),

            Text(
              Session.email ?? "No Email",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // 🔥 LOGOUT
                Session.userId = null;
                Session.email = null;
                Session.name = null;
                Session.role = null;

                Navigator.pop(context);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}