import 'package:flutter/material.dart';

class Failure {
  final String message;

  Failure({required this.message});
}

class FailureBody extends StatelessWidget {
  const FailureBody({
    super.key,
    required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
