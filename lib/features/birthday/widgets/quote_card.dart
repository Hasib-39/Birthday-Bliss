import 'package:flutter/material.dart';
import '../../birthday/models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final Color? backgroundColor;
  final Color? textColor;

  const QuoteCard({
    super.key,
    required this.quote,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.pinkAccent.withValues(alpha: 0.4),
      color: backgroundColor ?? Colors.white.withValues(alpha: 0.85),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            quote.text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.pinkAccent.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
