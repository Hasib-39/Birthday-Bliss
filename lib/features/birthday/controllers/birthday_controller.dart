import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/audio_service.dart';
import '../../../core/utils/mic_blow_detector.dart';
import '../../../core/constants/quotes.dart';
import '../models/quote.dart';

class BirthdayController extends ChangeNotifier {
  // Audio service
  final AudioService _audio = AudioService();

  // Mic blow detector
  MicBlowDetector? _blowDetector;

  // Candle state notifier
  final ValueNotifier<bool> candleLitNotifier = ValueNotifier(true);
  bool get isCandleLit => candleLitNotifier.value;

  // Song playing notifier
  final ValueNotifier<bool> songPlayingNotifier = ValueNotifier(false);

  // Quotes
  final List<Quote> _quotes = Quotes.all;
  List<Quote> get quotes => _quotes;

  /// Initialize mic blow detection if supported
  Future<void> initBlowDetection() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      debugPrint("Mic blow detection not supported on this platform.");
      return;
    }

    await _blowDetector?.dispose();
    _blowDetector = MicBlowDetector(onBlow: handleBlown);
    await _blowDetector?.start();
  }

  /// Handles candle blow (mic or manual)
  Future<void> handleBlown() async {
    if (!candleLitNotifier.value) return;

    // Update candle instantly
    candleLitNotifier.value = false;

    // Play song
    songPlayingNotifier.value = true;
    try {
      await _audio.playSong(loop: true);
    } catch (e) {
      if (kDebugMode) print('Error playing song: $e');
      songPlayingNotifier.value = false;
      candleLitNotifier.value = true; // revert candle if audio fails
    }
  }

  /// Toggle song playback with instant UI feedback
  Future<void> togglePlayPause() async {
    final currentlyPlaying = songPlayingNotifier.value;

    // Update UI immediately
    songPlayingNotifier.value = !currentlyPlaying;

    try {
      if (currentlyPlaying) {
        await _audio.pause();
      } else {
        await _audio.resume();
      }
    } catch (e) {
      // Revert UI if audio fails
      songPlayingNotifier.value = currentlyPlaying;
      if (kDebugMode) print('Error toggling audio: $e');
    }
  }

  /// Manual blow fallback
  void manualBlow() {
    handleBlown();
  }

  @override
  Future<void> dispose() async {
    await _blowDetector?.dispose();
    await _audio.dispose();
    candleLitNotifier.dispose();
    songPlayingNotifier.dispose();
    super.dispose();
  }
}
