import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const LanguageDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Italian',
      'Portuguese',
      'Russian',
      'Chinese',
      'Japanese',
      'Korean',
      'Arabic',
      'Hindi',
      'Persian',
    ];

    return DropdownButton<String>(
      value: value,
      isExpanded: true,
      hint: const Text('Select language'),
      onChanged: onChanged,
      items: languages.map((String language) {
        return DropdownMenuItem<String>(
          value: language,
          child: Text(language),
        );
      }).toList(),
    );
  }
}

