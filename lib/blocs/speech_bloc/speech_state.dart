part of 'speech_bloc.dart';

sealed class SpeechState extends Equatable {
  const SpeechState();

  @override
  List<Object> get props => [];
}

final class SpeechInitial extends SpeechState {}

final class SpeechLoading extends SpeechState {
  final String recognizedWords;
  const SpeechLoading(this.recognizedWords);
  @override
  List<Object> get props => [recognizedWords];
}

final class SpeechLoaded extends SpeechState {
  final String recognizedWords;
  const SpeechLoaded(this.recognizedWords);
  @override
  List<Object> get props => [recognizedWords];
}
