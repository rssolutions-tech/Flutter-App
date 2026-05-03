import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'manage_quiz_page.dart';
import 'upload_content.dart';
import 'manage_content.dart';

class InstructorCoursesPage extends StatelessWidget {
  final String instructorEmail;

  const InstructorCoursesPage({
    super.key,
    required this.instructorEmail,
  });

  Future<void> togglePublish(String docId, bool currentStatus) async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(docId)
        .update({
      'isPublished': !currentStatus,
    });
  }

  Future<void> deleteCourse(BuildContext context, String courseId) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Course"),
        content: const Text("Are you sure you want to delete this course?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('courses')
                  .doc(courseId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void showEditDialog(
      BuildContext context, String courseId, Map<String, dynamic> data) {

    final title = TextEditingController(text: data['title']);
    final desc = TextEditingController(text: data['description']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Course"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: title),
            const SizedBox(height: 10),
            TextField(controller: desc),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('courses')
                  .doc(courseId)
                  .update({
                'title': title.text,
                'description': desc.text,
              });
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void showOptions(
      BuildContext context, String courseId, Map<String, dynamic> data) {

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit Course"),
                onTap: () {
                  Navigator.pop(context);
                  showEditDialog(context, courseId, data);
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete Course"),
                onTap: () {
                  Navigator.pop(context);
                  deleteCourse(context, courseId);
                },
              ),

              ListTile(
                leading: const Icon(Icons.upload),
                title: const Text("Add Content"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UploadContentPage(courseId: courseId),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.list),
                title: const Text("Manage Content"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ManageContentPage(courseId: courseId),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.quiz),
                title: const Text("Manage Quiz"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ManageQuizPage(courseId: courseId),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color getStatusColor(bool isPublished) {
    return isPublished ? Colors.green : Colors.orange;
  }

  String getStatusText(bool isPublished) {
    return isPublished ? "Published" : "Draft";
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
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Courses",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 📄 COURSE LIST
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .where('instructorEmail', isEqualTo: instructorEmail)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final courses = snapshot.data!.docs;

                  if (courses.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.menu_book, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No courses created yet",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {

                      final doc = courses[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final isPublished = data['isPublished'] ?? false;

                      return GestureDetector(
                        onTap: () => showOptions(context, doc.id, data),

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),

                          child: Row(
                            children: [

                              // 📘 ICON
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.book,
                                    color: Colors.blue),
                              ),

                              const SizedBox(width: 15),

                              // 📄 TITLE + DESC
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['title'] ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      data['description'] ?? "",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              // 📊 STATUS
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(isPublished)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      getStatusText(isPublished),
                                      style: TextStyle(
                                        color: getStatusColor(isPublished),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  ElevatedButton(
                                    onPressed: () {
                                      togglePublish(doc.id, isPublished);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      backgroundColor: isPublished
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    child: Text(
                                      isPublished
                                          ? "Unpublish"
                                          : "Publish",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}