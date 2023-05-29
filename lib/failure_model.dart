import 'package:flutter/material.dart';

class Failure {
  final String message;

  Failure({required this.message});
}

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    super.key,
    required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
      ),
      body: Text(message),
    );
  }
}
