import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseMonitoring extends StatefulWidget {
  const CourseMonitoring({super.key});

  @override
  State<CourseMonitoring> createState() => _CourseMonitoringState();
}

class _CourseMonitoringState extends State<CourseMonitoring> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Course Monitoring",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('course_content')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No course content available",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final contents = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: contents.length,

            itemBuilder: (context, index) {
              final data = contents[index];

              final title = data['title'] ?? '';
              final instructor = data['instructorName'] ?? '';
              final type = data['type'] ?? '';
              final fileUrl = data['fileUrl'] ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    // ICON
                    Container(
                      height: 72,
                      width: 72,

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5B7FFF), Color(0xFF39D2C0)],
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),

                      child: Icon(
                        type.toLowerCase() == 'pdf'
                            ? Icons.picture_as_pdf
                            : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),

                    const SizedBox(width: 18),

                    // DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Instructor : $instructor",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Type : $type",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // VIEW BUTTON
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B7FFF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      onPressed: () {
                        _showContentViewer(context, title, type, fileUrl);
                      },

                      icon: const Icon(Icons.visibility, color: Colors.white),

                      label: const Text(
                        "View",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= CONTENT VIEWER =================

  void _showContentViewer(
    BuildContext context,
    String title,
    String type,
    String fileUrl,
  ) {
    YoutubePlayerController? youtubeController;

    if (type.toLowerCase() == "video") {
      final videoId = YoutubePlayer.convertUrlToId(fileUrl);

      youtubeController = YoutubePlayerController(
        initialVideoId: videoId ?? "",
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }

    showDialog(
      context: context,
      barrierDismissible: true,

      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),

          child: Container(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.88,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),

            child: Column(
              children: [
                // HEADER
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),

                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5B7FFF), Color(0xFF39D2C0)],
                    ),

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Icon(
                          type.toLowerCase() == "pdf"
                              ? Icons.picture_as_pdf
                              : Icons.play_circle_fill,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                // CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: Container(
                        color: Colors.black12,

                        child: type.toLowerCase() == "pdf"
                            // PDF VIEWER
                            ? SfPdfViewer.network(fileUrl)
                            // VIDEO PLAYER
                            : YoutubePlayer(
                                controller: youtubeController!,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: const Color(0xFF5B7FFF),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
