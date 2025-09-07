// Performance: Create a singleton audio manager
import 'package:audioplayers/audioplayers.dart';

class _AudioManager {
  static final _instance = _AudioManager._internal();
  factory _AudioManager() => _instance;
  _AudioManager._internal();

  final AudioPlayer _sfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  Future<void> playSfx(String assetPath, bool isMuted) async {
    if (isMuted) return;
    try {
      await _sfx.stop();
      await _sfx.play(AssetSource(assetPath));
    } catch (_) {
      // Swallow errors; non-critical UX feature
    }
  }

  void dispose() {
    _sfx.dispose();
  }
}

final audioManager = _AudioManager();
