import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_notifier.dart';
import 'language.dart'; // Import enum Language

class LanguagePopupMenu extends StatelessWidget {
  const LanguagePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final languageNotifier = context.watch<LanguageNotifier>();
    final currentLanguage = languageNotifier.currentLanguage;

    return PopupMenuButton<Language>(
      onSelected: (value) => languageNotifier.updateLanguage(value),
      itemBuilder: (context) => [
        for (var language in Language.values)
          PopupMenuItem(
            value: language,
            child: Row(
              children: [
                Image.asset(language.flag, width: 24, height: 24),
                const SizedBox(width: 8),
                Text(language.name),
              ],
            ),
          ),
      ],
      child: Row(
        children: [
          Image.asset(currentLanguage.flag, width: 24, height: 24),
          const SizedBox(width: 8),
          Text('Language: ${currentLanguage.name}'),
        ],
      ),
    );
  }
}
