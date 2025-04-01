part of 'speech_bloc.dart';

sealed class SpeechEvent extends Equatable {
  const SpeechEvent();

  @override
  List<Object> get props => [];
}

final class InitialSpeechEvent extends SpeechEvent {}

final class StartSpeechEvent extends SpeechEvent {}

final class _SpeechWordEvent extends SpeechEvent {
  final String recognizedWords;
  const _SpeechWordEvent({required this.recognizedWords});
  @override
  List<Object> get props => [recognizedWords];
}

final class StopSpeechEvent extends SpeechEvent {}
