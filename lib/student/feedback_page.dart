import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackPage extends StatefulWidget {
  final String instructorId;
  final String instructorName;
  final User user; // 🔥 IMPORTANT

  const FeedbackPage({
    super.key,
    required this.instructorId,
    required this.instructorName,
    required this.user,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int rating = 0;
  final TextEditingController controller = TextEditingController();
  bool loading = false;

  void submitFeedback() async {

    if (rating == 0 || controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'userId': widget.user.uid,
        'userEmail': widget.user.email ?? "No Email",
        'instructorId': widget.instructorId,
        'instructorName': widget.instructorName,
        'rating': rating,
        'comment': controller.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      controller.clear();
      setState(() => rating = 0);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted ✅")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= rating ? Icons.star : Icons.star_border,
        color: Colors.orange,
      ),
      onPressed: () => setState(() => rating = index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Text(
              "Feedback for ${widget.instructorName}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => buildStar(i + 1)),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Write feedback...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submitFeedback,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}