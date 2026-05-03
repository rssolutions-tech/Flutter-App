import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadContentPage extends StatefulWidget {
  final String courseId;

  const UploadContentPage({super.key, required this.courseId});

  @override
  State<UploadContentPage> createState() => _UploadContentPageState();
}

class _UploadContentPageState extends State<UploadContentPage> {
  final titleController = TextEditingController();
  final urlController = TextEditingController();

  String selectedType = "video";
  bool isLoading = false;

  Future<void> saveContent() async {
    if (titleController.text.isEmpty || urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('course_content').add({
        'courseId': widget.courseId,
        'title': titleController.text.trim(),
        'fileUrl': urlController.text.trim(),
        'type': selectedType,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Content added successfully")),
      );

      titleController.clear();
      urlController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isLoading = false);
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
                  "Upload Content",
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
                      "Add Video / PDF",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // TITLE
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Content Title",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // URL
                    TextField(
                      controller: urlController,
                      decoration: InputDecoration(
                        labelText: "Enter URL (YouTube / Drive / PDF)",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // TYPE SELECTOR (Better than dropdown)
                    Row(
                      children: [
                        typeCard("video", Icons.play_circle),
                        const SizedBox(width: 10),
                        typeCard("pdf", Icons.picture_as_pdf),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // BUTTON
                    isLoading
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: saveContent,
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
                                  "Save Content",
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

  // 🔥 TYPE CARD (better UX than dropdown)
  Widget typeCard(String type, IconData icon) {
    final isSelected = selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedType = type);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? const Color(0xFF5B86E5).withOpacity(0.1)
                : Colors.grey.shade100,
            border: Border.all(
              color: isSelected ? const Color(0xFF5B86E5) : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color:
                      isSelected ? const Color(0xFF5B86E5) : Colors.grey),
              const SizedBox(height: 5),
              Text(type.toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }
}