import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Center(
        child: Text(
          "Your Score: $score",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}