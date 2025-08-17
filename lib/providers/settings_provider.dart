import 'package:flutter/material.dart';
import '../models/settings_model.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsModel _settings = SettingsModel(
    recipientName: "My Love ❤️",
    customMessage: "You’re the sweetest gift in my life.\nHappy Birthday, Princess! 🎂",
    cakeColor: Colors.pink,
    musicUrl: null,
  );

  SettingsModel get settings => _settings;

  void updateRecipient(String name) {
    _settings = _settings.copyWith(recipientName: name);
    notifyListeners();
  }

  void updateMessage(String message) {
    _settings = _settings.copyWith(customMessage: message);
    notifyListeners();
  }

  void updateCakeColor(Color color) {
    _settings = _settings.copyWith(cakeColor: color);
    notifyListeners();
  }

  void updateMusicUrl(String url) {
    _settings = _settings.copyWith(musicUrl: url);
    notifyListeners();
  }
}
