import 'package:flutter/material.dart';

class BlowIndicator extends StatelessWidget {
  const BlowIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Blow into the mic to put out the candle",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          "No mic? Long‑press the cake to blow it out.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
