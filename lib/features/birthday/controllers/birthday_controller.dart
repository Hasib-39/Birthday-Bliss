import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import '../../../core/utils/audio_service.dart';
import '../../../core/utils/mic_blow_detector.dart';
import '../../../core/constants/quotes.dart';
import '../models/quote.dart';

class BirthdayController extends ChangeNotifier {
  // Audio service
  final AudioService _audio = AudioService();

  // Mic blow detector
  MicBlowDetector? _blowDetector;

  // Candle state
  bool _isCandleLit = true;
  bool get isCandleLit => _isCandleLit;

  // Quotes
  final List<Quote> _quotes = Quotes.all;
  List<Quote> get quotes => _quotes;

  // Song playing notifier for instant UI update
  final ValueNotifier<bool> songPlayingNotifier = ValueNotifier(false);

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
    if (!_isCandleLit) return;

    _isCandleLit = false;
    notifyListeners();

    // Play birthday song
    songPlayingNotifier.value = true; // update UI instantly
    try {
      await _audio.playSong(loop: true);
    } catch (e) {
      if (kDebugMode) print('Error playing song: $e');
      songPlayingNotifier.value = false;
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
    songPlayingNotifier.dispose();
    super.dispose();
  }
}
