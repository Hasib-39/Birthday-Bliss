import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/cake_widget.dart';
import '../widgets/birthday_message.dart';
import '../widgets/heart_animation.dart';
import 'settings_screen.dart';
import '../widgets/music_player_widget.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  bool _candlesBlown = false;

  void _blowCandles() {
    setState(() {
      _candlesBlown = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Birthday Cake"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Happy Birthday 🎉",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 20),
                CakeWidget(
                  candlesBlown: _candlesBlown,
                  cakeColor: settings.cakeColor,
                ),
                const SizedBox(height: 20),
                !_candlesBlown
                    ? ElevatedButton(
                  onPressed: _blowCandles,
                  child: const Text("Blow Candles"),
                )
                    : BirthdayMessage(
                  recipient: settings.recipientName,
                  message: settings.customMessage,
                ),
              ],
            ),
            if (_candlesBlown) const HeartAnimation(),
            if (settings.musicUrl != null)
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: MusicPlayerWidget(url: settings.musicUrl!),
              ),
          ],
        ),
      ),
    );
  }
}
