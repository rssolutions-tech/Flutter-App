import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageQuizPage extends StatefulWidget {
  final String courseId;

  const ManageQuizPage({super.key, required this.courseId});

  @override
  State<ManageQuizPage> createState() => _ManageQuizPageState();
}

class _ManageQuizPageState extends State<ManageQuizPage> {
  final titleController = TextEditingController();
  String? selectedQuizId;

  final questionController = TextEditingController();
  final options = List.generate(4, (_) => TextEditingController());
  int correctIndex = 0;

  Future<void> createQuiz() async {
    if (titleController.text.isEmpty) return;

    final doc = await FirebaseFirestore.instance.collection('quizzes').add({
      'courseId': widget.courseId,
      'title': titleController.text.trim(),
      'createdAt': Timestamp.now(),
    });

    setState(() => selectedQuizId = doc.id);
  }

  Future<void> addQuestion() async {
    if (selectedQuizId == null) return;

    await FirebaseFirestore.instance.collection('questions').add({
      'quizId': selectedQuizId,
      'question': questionController.text,
      'options': options.map((e) => e.text).toList(),
      'correctAnswer': correctIndex,
    });

    questionController.clear();
    for (var o in options) o.clear();
  }

  Future<void> deleteQuestion(String id) async {
    await FirebaseFirestore.instance.collection('questions').doc(id).delete();
  }

  Future<void> deleteQuiz(String id) async {
    await FirebaseFirestore.instance.collection('quizzes').doc(id).delete();
    setState(() => selectedQuizId = null);
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
                  "Manage Quiz",
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

          Expanded(
            child: Row(
              children: [

                // 🧠 LEFT: QUIZ LIST
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      children: [

                        // CREATE QUIZ
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  hintText: "Quiz title",
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: createQuiz,
                              child: const Text("Create"),
                            )
                          ],
                        ),

                        const SizedBox(height: 15),

                        // QUIZ LIST
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('quizzes')
                                .where('courseId', isEqualTo: widget.courseId)
                                .snapshots(),
                            builder: (context, snapshot) {

                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              final quizzes = snapshot.data!.docs;

                              if (quizzes.isEmpty) {
                                return const Center(
                                    child: Text("No quizzes yet"));
                              }

                              return ListView.builder(
                                itemCount: quizzes.length,
                                itemBuilder: (context, index) {
                                  final quiz = quizzes[index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: selectedQuizId == quiz.id
                                          ? Colors.blue.withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      title: Text(quiz['title']),
                                      onTap: () {
                                        setState(() {
                                          selectedQuizId = quiz.id;
                                        });
                                      },
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteQuiz(quiz.id),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 📄 RIGHT: QUESTIONS
                Expanded(
                  flex: 2,
                  child: selectedQuizId == null
                      ? const Center(child: Text("Select a quiz"))
                      : Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Column(
                            children: [

                              // QUESTION INPUT
                              TextField(
                                controller: questionController,
                                decoration: const InputDecoration(
                                  hintText: "Enter question",
                                ),
                              ),

                              const SizedBox(height: 10),

                              ...List.generate(4, (i) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8),
                                  child: TextField(
                                    controller: options[i],
                                    decoration: InputDecoration(
                                      hintText: "Option ${i + 1}",
                                    ),
                                  ),
                                );
                              }),

                              DropdownButton<int>(
                                value: correctIndex,
                                items: const [
                                  DropdownMenuItem(value: 0, child: Text("Correct: 1")),
                                  DropdownMenuItem(value: 1, child: Text("Correct: 2")),
                                  DropdownMenuItem(value: 2, child: Text("Correct: 3")),
                                  DropdownMenuItem(value: 3, child: Text("Correct: 4")),
                                ],
                                onChanged: (val) {
                                  setState(() => correctIndex = val!);
                                },
                              ),

                              ElevatedButton(
                                onPressed: addQuestion,
                                child: const Text("Add Question"),
                              ),

                              const Divider(),

                              // QUESTION LIST
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('questions')
                                      .where('quizId',
                                          isEqualTo: selectedQuizId)
                                      .snapshots(),
                                  builder: (context, snapshot) {

                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }

                                    final questions = snapshot.data!.docs;

                                    return ListView.builder(
                                      itemCount: questions.length,
                                      itemBuilder: (context, index) {
                                        final q = questions[index];
                                        final data =
                                            q.data() as Map<String, dynamic>;

                                        return ListTile(
                                          title: Text(data['question']),
                                          subtitle: Text(
                                              "Correct: ${data['correctAnswer'] + 1}"),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () =>
                                                deleteQuestion(q.id),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}