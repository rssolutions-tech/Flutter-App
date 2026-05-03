import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  final String url;

  const ContentPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Content")),
      body: Center(
        child: Text(
          url.isEmpty ? "No Content Available" : url,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}