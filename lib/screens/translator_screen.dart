import 'package:extension_test/blocs/theme_bloc/theme_bloc.dart';
import 'package:extension_test/blocs/translate_bloc/translate_bloc.dart';
import 'package:extension_test/widgets/language_dropdown.dart';
import 'package:extension_test/widgets/translated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _textController = TextEditingController();
  String sourceLanguage = 'English';
  String targetLanguage = 'Spanish';

  Future<void> _launchEmail() async {
    final Uri gmailUrl = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&to=hamed137881@gmail.com',
    );

    if (!await launchUrl(
      gmailUrl,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Gmail'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('AI Translator'),
        leading: GestureDetector(
          onTap: _launchEmail,
          child: const Center(
            child: Text(
              "Contact",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed:
                    () => context.read<ThemeBloc>().add(ToggleThemeEvent()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 500,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: LanguageDropdown(
                      value: sourceLanguage,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            sourceLanguage = value;
                          });
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () {
                      setState(() {
                        final temp = sourceLanguage;
                        sourceLanguage = targetLanguage;
                        targetLanguage = temp;

                        // If there's text already translated, swap the results too
                        final translationState =
                            context.read<TranslationBloc>().state;
                        if (translationState is TranslationLoaded &&
                            translationState.translatedText.isNotEmpty) {
                          _textController.text =
                              translationState.translatedText;
                          context.read<TranslationBloc>().add(
                            ClearTranslationEvent(),
                          );
                        }
                      });
                    },
                  ),
                  Expanded(
                    child: LanguageDropdown(
                      value: targetLanguage,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            targetLanguage = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter text to translate',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<TranslationBloc, TranslationState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        state is TranslationLoading
                            ? null
                            : () {
                              if (_textController.text.isNotEmpty) {
                                context.read<TranslationBloc>().add(
                                  TranslateTextEvent(
                                    text: _textController.text,
                                    sourceLanguage: sourceLanguage,
                                    targetLanguage: targetLanguage,
                                  ),
                                );
                              }
                            },
                    child: const Text('Translate'),
                  );
                },
              ),
              const SizedBox(height: 16),
              TranslatedText(),
            ],
          ),
        ),
      ),
    );
  }
}
