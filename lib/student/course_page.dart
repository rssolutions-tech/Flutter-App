import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feedback_page.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  Future<void> openCourse(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid URL")),
      );
      return;
    }

    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('course_content')
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Courses Available"));
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final title = data['title'] ?? "No Title";
              final type = data['type'] ?? "";
              final url = data['fileUrl'] ?? "";

              final instructorId = data['instructorId'] ?? "default_id";
              final instructorName = data['instructorName'] ?? "Instructor";

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,

                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: Colors.blue),
                  title: Text(title),
                  subtitle: Text("Type: $type"),

                  onTap: () => openCourse(context, url),

                  trailing: IconButton(
                    icon: const Icon(Icons.feedback),
                    onPressed: () {

                      final user = FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not logged in ❌")),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedbackPage(
                            instructorId: instructorId,
                            instructorName: instructorName,
                            user: user, // 🔥 PASS USER
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}