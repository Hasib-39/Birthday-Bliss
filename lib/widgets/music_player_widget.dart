import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/scheduler.dart';

class MusicPlayer {
  final AudioPlayer _player = AudioPlayer();
  final String source;
  final bool isAsset; // true = asset file, false = URL

  MusicPlayer({required this.source, this.isAsset = true});

  /// Play the audio safely on the main thread
  Future<void> play() async {
    // Ensure this runs after current frame
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _player.stop();
      if (isAsset) {
        await _player.play(AssetSource(source));
      } else {
        await _player.play(UrlSource(source));
      }
    });
  }

  /// Pause audio
  Future<void> pause() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _player.pause();
    });
  }

  /// Stop audio
  Future<void> stop() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _player.stop();
    });
  }
}
