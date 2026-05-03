import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateCoursePage extends StatefulWidget {
  final String instructorEmail;

  const CreateCoursePage({super.key, required this.instructorEmail});

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final title = TextEditingController();
  final description = TextEditingController();

  bool isLoading = false;

  Future<void> createCourse() async {
    if (title.text.isEmpty || description.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    await FirebaseFirestore.instance.collection('courses').add({
      'title': title.text.trim(),
      'description': description.text.trim(),
      'instructorEmail': widget.instructorEmail,
      'isPublished': false,
      'createdAt': Timestamp.now(),
    });

    setState(() => isLoading = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      body: Column(
        children: [

          // 🌈 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
              ),
            ),
            child: const Text(
              "Create Course",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // 📄 FORM
          Expanded(
            child: Center(
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "Add New Course",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 25),

                    // TITLE FIELD
                    TextField(
                      controller: title,
                      decoration: InputDecoration(
                        labelText: "Course Title",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // DESCRIPTION FIELD
                    TextField(
                      controller: description,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // BUTTON
                    isLoading
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: createCourse,
                            borderRadius: BorderRadius.circular(12),
                            child: Ink(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF5B86E5),
                                    Color(0xFF36D1DC)
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "Create Course",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}