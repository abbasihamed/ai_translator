part of './translate_bloc.dart';

abstract class TranslationEvent extends Equatable {
  const TranslationEvent();

  @override
  List<Object> get props => [];
}

class TranslateTextEvent extends TranslationEvent {
  final String text;
  final String sourceLanguage;
  final String targetLanguage;

  const TranslateTextEvent({
    required this.text,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  @override
  List<Object> get props => [text, sourceLanguage, targetLanguage];
}

class ClearTranslationEvent extends TranslationEvent {}
