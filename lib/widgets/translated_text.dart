import 'package:ai_translator/blocs/translate_bloc/translate_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TranslatedText extends StatelessWidget {
  const TranslatedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: BlocBuilder<TranslationBloc, TranslationState>(
                builder: (context, state) {
                  if (state is TranslationLoading) {
                    return const Center(child: Text('Translating...'));
                  } else if (state is TranslationLoaded) {
                    return SelectableText(
                      state.translatedText.isNotEmpty
                          ? state.translatedText
                          : 'Translation will appear here',
                    );
                  } else {
                    return const Text('Translation will appear here');
                  }
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: BlocBuilder<TranslationBloc, TranslationState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if (state is TranslationLoaded &&
                          state.translatedText.isNotEmpty) {
                        Clipboard.setData(
                          ClipboardData(text: state.translatedText),
                        );
                        Fluttertoast.showToast(
                          msg: "Text copied to clipboard",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          webBgColor: '#444444',
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: const Icon(Icons.copy_rounded),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
