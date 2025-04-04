import 'package:ai_translator/blocs/speech_bloc/speech_bloc.dart';
import 'package:ai_translator/blocs/theme_bloc/theme_bloc.dart';
import 'package:ai_translator/blocs/translate_bloc/translate_bloc.dart';
import 'package:ai_translator/screens/translator_screen.dart';
import 'package:ai_translator/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()..add(LoadThemeEvent())),
        BlocProvider(create: (context) => TranslationBloc(GeminiService())),
        BlocProvider(
          create:
              (context) =>
                  SpeechBloc(SpeechToText())..add(InitialSpeechEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'AI Translator',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: state.themeMode,
            home: const TranslatorScreen(),
          );
        },
      ),
    );
  }
}
