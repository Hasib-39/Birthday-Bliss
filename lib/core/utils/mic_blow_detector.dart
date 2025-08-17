import 'dart:async';
import 'package:noise_meter/noise_meter.dart';

typedef BlowCallback = void Function();

class MicBlowDetector {
  final double thresholdDb;   // e.g., 75 dB
  final Duration minDuration; // e.g., 300ms
  final BlowCallback onBlow;

  NoiseMeter? _meter;
  StreamSubscription<NoiseReading>? _sub;
  DateTime? _aboveSince;

  MicBlowDetector({
    required this.onBlow,
    this.thresholdDb = 75.0,
    this.minDuration = const Duration(milliseconds: 300),
  });

  Future<void> start() async {
    _meter ??= NoiseMeter();
    try {
      _sub = _meter!.noise.listen(
            (reading) {
          if (reading.maxDecibel >= thresholdDb) {
            _aboveSince ??= DateTime.now();
            if (DateTime.now().difference(_aboveSince!) >= minDuration) {
              stop();
              onBlow();
            }
          } else {
            _aboveSince = null;
          }
        },
        onError: (error) {
          // Mic might not be available / permission denied
          stop();
        },
      );
    } catch (_) {
      // Unable to start mic – ignore silently; user can use fallback
    }
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    _aboveSince = null;
  }

  Future<void> dispose() async {
    await stop();
    _meter = null;
  }
}
