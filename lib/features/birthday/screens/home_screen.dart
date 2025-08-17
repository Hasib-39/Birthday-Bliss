import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../screens/wish_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1B1B2F), Theme.of(context).colorScheme.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Birthday Bliss", style: buildTheme().textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const Text("Blow the candle and let the song begin 🎂💖", textAlign: TextAlign.center),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WishScreen()));
                  },
                  child: const Text("Start"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
