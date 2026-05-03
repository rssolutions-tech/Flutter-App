import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageContentPage extends StatelessWidget {
  final String courseId;

  const ManageContentPage({super.key, required this.courseId});

  Future<void> deleteContent(BuildContext context, String docId) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Content"),
        content: const Text("Are you sure you want to delete this content?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('course_content')
                  .doc(docId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  IconData getIcon(String type) {
    if (type == "video") return Icons.play_circle_fill;
    if (type == "pdf") return Icons.picture_as_pdf;
    return Icons.insert_drive_file;
  }

  Color getColor(String type) {
    if (type == "video") return Colors.blue;
    if (type == "pdf") return Colors.red;
    return Colors.grey;
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
                  "Manage Content",
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

          // 📄 CONTENT LIST
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('course_content')
                    .where('courseId', isEqualTo: courseId)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final contents = snapshot.data!.docs;

                  if (contents.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.folder_open, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No content added yet",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: contents.length,
                    itemBuilder: (context, index) {
                      final doc = contents[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final type = data['type'] ?? "file";

                      return Container(
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

                            // 📌 ICON
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: getColor(type).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                getIcon(type),
                                color: getColor(type),
                              ),
                            ),

                            const SizedBox(width: 15),

                            // 📄 TITLE + TYPE
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
                                    type.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🗑 DELETE
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  deleteContent(context, doc.id),
                            ),
                          ],
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