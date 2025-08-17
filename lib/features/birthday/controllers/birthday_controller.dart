import 'package:flutter/material.dart';
import '../../../core/utils/audio_service.dart';
import '../../../core/utils/mic_blow_detector.dart';
import '../../../core/constants/quotes.dart';
import '../models/quote.dart';

class BirthdayController extends ChangeNotifier {
  final AudioService _audio = AudioService();
  MicBlowDetector? _blowDetector;

  bool _isCandleLit = true;
  bool _isSongPlaying = false;
  final List<Quote> _quotes = Quotes.all;

  bool get isCandleLit => _isCandleLit;
  bool get isSongPlaying => _isSongPlaying;
  List<Quote> get quotes => _quotes;

  Future<void> initBlowDetection() async {
    _blowDetector?.dispose();
    _blowDetector = MicBlowDetector(onBlow: handleBlown);
    await _blowDetector?.start();
  }

  Future<void> handleBlown() async {
    if (!_isCandleLit) return;
    _isCandleLit = false;
    notifyListeners();
    await _audio.playSong(loop: true);
    _isSongPlaying = true;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isSongPlaying) {
      await _audio.pause();
    } else {
      await _audio.resume();
    }
    _isSongPlaying = !_isSongPlaying;
    notifyListeners();
  }

  void manualBlow() {
    handleBlown(); // fallback if mic not available
  }

  @override
  void dispose() {
    _blowDetector?.dispose();
    _audio.dispose();
    super.dispose();
  }
}
