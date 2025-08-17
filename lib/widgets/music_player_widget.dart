import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class MusicPlayer {
  final AudioPlayer _player = AudioPlayer();
  final String source;
  final bool isAsset; // true = asset file, false = URL

  MusicPlayer({required this.source, this.isAsset = true});

  /// Preload asset audio to avoid blocking UI
  Future<void> preload() async {
    if (isAsset) {
      try {
        await _player.setSource(AssetSource(source));
      } catch (e) {
        debugPrint('Error preloading audio: $e');
      }
    }
  }

  /// Play the audio (resumes preloaded asset or plays URL)
  Future<void> play() async {
    try {
      if (isAsset) {
        await _player.resume(); // fast, no skipped frames
      } else {
        await _player.play(UrlSource(source));
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  /// Pause audio
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  /// Stop audio
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }
}
