import 'package:audioplayers/audioplayers.dart';
import '../assets.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSong({bool loop = true}) async {
    await _player.stop();
    await _player.play(AssetSource(AppAssets.birthdaySong));
    if (loop) {
      await _player.setReleaseMode(ReleaseMode.loop);
    }
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.resume();
  Future<void> stop()   => _player.stop();

  Future<void> dispose() => _player.dispose();
}
