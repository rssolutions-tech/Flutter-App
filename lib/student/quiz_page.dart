import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  int score = 0;
  int? selectedOption;

  List docs = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('questions').get();

    setState(() {
      docs = snapshot.docs;
    });
  }

  void nextQuestion() {
    if (selectedOption == null) return;

    final data = docs[currentIndex].data() as Map<String, dynamic>;

    if (selectedOption == data['correctAnswer']) {
      score++;
    }

    if (currentIndex < docs.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
      });
    } else {
      showResult();
    }
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Completed"),
        content: Text("Score: $score / ${docs.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = docs[currentIndex].data() as Map<String, dynamic>;
    final question = data['question'];
    final options = List<String>.from(data['options']);

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Text(
              "Q${currentIndex + 1}. $question",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            ...List.generate(options.length, (index) {
              return RadioListTile<int>(
                value: index,
                groupValue: selectedOption,
                title: Text(options[index]),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              );
            }),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: nextQuestion,
              child: const Text("Next"),
            )
          ],
        ),
      ),
    );
  }
}