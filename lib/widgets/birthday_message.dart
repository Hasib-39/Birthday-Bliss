import 'package:flutter/material.dart';

class BirthdayMessage extends StatelessWidget {
  final String recipient;
  final String message;

  const BirthdayMessage({
    super.key,
    required this.recipient,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          recipient,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ],
    );
    }
}
