part of './translate_bloc.dart';

abstract class TranslationState extends Equatable {
  const TranslationState();
  
  @override
  List<Object> get props => [];
}

class TranslationInitial extends TranslationState {}

class TranslationLoading extends TranslationState {}

class TranslationLoaded extends TranslationState {
  final String translatedText;

  const TranslationLoaded(this.translatedText);

  @override
  List<Object> get props => [translatedText];
}

class TranslationError extends TranslationState {
  final String errorMessage;

  const TranslationError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
