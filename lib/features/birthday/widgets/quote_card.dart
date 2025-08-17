import 'package:flutter/material.dart';
import '../../birthday/models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            "“${quote.text}”",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
