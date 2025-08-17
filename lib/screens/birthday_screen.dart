import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/cake_widget.dart';
import '../widgets/birthday_message.dart';
import '../widgets/heart_animation.dart';
import '../widgets/music_player_widget.dart';
import 'settings_screen.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  bool _candlesBlown = false;
  late MusicPlayer _musicPlayer;

  @override
  void initState() {
    super.initState();
    _initMusic();
  }

  /// Initialize and preload the music
  Future<void> _initMusic() async {
    final settings = context.read<SettingsProvider>().settings;
    final musicPath = (settings.musicUrl != null && settings.musicUrl!.isNotEmpty)
        ? settings.musicUrl!
        : 'assets/sounds/birthday_song.mp3';

    _musicPlayer = MusicPlayer(
      source: musicPath,
      isAsset: settings.musicUrl == null || settings.musicUrl!.isEmpty,
    );

    if (_musicPlayer.isAsset) {
      await _musicPlayer.preload();
    }
  }

  /// Blow candles and play music asynchronously
  Future<void> _blowCandles() async {
    setState(() {
      _candlesBlown = true;
    });

    // Play music asynchronously to avoid blocking UI
    unawaited(_musicPlayer.play());
  }

  /// Reset the app to original state
  void _resetApp() {
    setState(() {
      _candlesBlown = false;
    });
    _musicPlayer.stop();
  }

  @override
  void dispose() {
    _musicPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Birthday Bliss",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetApp,
        backgroundColor: Colors.pinkAccent,
        tooltip: "Reset Birthday",
        child: const Icon(Icons.refresh),
      ),
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Happy Birthday 🎉",
                    style: TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}
