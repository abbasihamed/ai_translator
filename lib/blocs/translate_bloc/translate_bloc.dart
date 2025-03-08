import 'package:ai_translator/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';

part './translate_states.dart';
part './translate_events.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final GeminiService _geminiService;

  TranslationBloc(this._geminiService) : super(TranslationInitial()) {
    on<TranslateTextEvent>(_onTranslateText);
    on<ClearTranslationEvent>(_onClearTranslation);
  }

  Future<void> _onTranslateText(
    TranslateTextEvent event,
    Emitter<TranslationState> emit,
  ) async {
    try {
      emit(TranslationLoading());

      if (event.text.trim().isEmpty) {
        throw Exception('Please enter some text to translate');
      }

      final translation = await _geminiService.translateText(
        event.text,
        event.sourceLanguage,
        event.targetLanguage,
      );

      if (translation.trim().isEmpty) {
        throw Exception('Translation failed. Please try again');
      }

      emit(TranslationLoaded(translation));
    } catch (e) {
      emit(TranslationError(e.toString()));
      _showErrorToast(e.toString());
    }
  }

  void _onClearTranslation(
    ClearTranslationEvent event,
    Emitter<TranslationState> emit,
  ) {
    emit(const TranslationLoaded(''));
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFE53935),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 16.0,
    );
  }
}
