import 'package:flutter/material.dart';
import 'language.dart'; // Import enum Language

class LanguageNotifier extends ChangeNotifier {
  Language _currentLanguage = Language.english;

  Language get currentLanguage => _currentLanguage;

  void updateLanguage(Language newLanguage) {
    _currentLanguage = newLanguage;
    notifyListeners();
  }
}
