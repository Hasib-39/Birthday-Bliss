import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../assets.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  /// Play birthday song with optional looping
  Future<void> playSong({bool loop = true}) async {
    try {
      // Stop any previous playback
      await _player.stop();

      if (kIsWeb) {
        // Web: just_audio cannot use AssetSource, so use relative URL
        await _player.setAsset(AppAssets.birthdaySongWeb); // provide web-compatible path
      } else {
        // Mobile: Android/iOS
        await _player.setAsset(AppAssets.birthdaySong);
      }

      // Set loop mode
      await _player.setLoopMode(loop ? LoopMode.one : LoopMode.off);

      // Start playback
      await _player.play();
    } catch (e) {
      if (kDebugMode) {
        print("Error playing song: $e");
      }
    }
  }

  Future<void> pause() async => await _player.pause();
  Future<void> resume() async => await _player.play();
  Future<void> stop() async => await _player.stop();

  Future<void> dispose() async {
    await _player.stop();
    await _player.dispose();
  }
}
