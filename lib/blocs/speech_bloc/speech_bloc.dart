import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_event.dart';
part 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechToText _speechService;
  SpeechBloc(this._speechService) : super(SpeechInitial()) {
    on<InitialSpeechEvent>(_initialSpeech);
    on<StartSpeechEvent>(_onStartSpeech);
    on<_SpeechWordEvent>(_onSpeechWord);
    on<StopSpeechEvent>(_onStopSpeech);
  }

  bool _isInitial = false;
  String _recognizedWords = '';

  Future<void> _initialSpeech(
    SpeechEvent event,
    Emitter<SpeechState> emit,
  ) async {
    _isInitial = await _speechService.initialize(
      finalTimeout: const Duration(seconds: 5),
    );
  }

  Future<void> _onStartSpeech(
    StartSpeechEvent event,
    Emitter<SpeechState> emit,
  ) async {
    if (_isInitial) {
      add(_SpeechWordEvent(recognizedWords: (_recognizedWords)));
      await _speechService.listen(
        onResult: (result) {
          _recognizedWords = result.recognizedWords;
          add(_SpeechWordEvent(recognizedWords: _recognizedWords));
          if (result.finalResult) {
            add(StopSpeechEvent());
          }
        },
      );
    } else {}
  }

  FutureOr<void> _onSpeechWord(
    _SpeechWordEvent event,
    Emitter<SpeechState> emit,
  ) {
    emit(SpeechLoading(event.recognizedWords));
  }

  @override
  Future<void> close() {
    _speechService.stop();
    return super.close();
  }

  FutureOr<void> _onStopSpeech(
    StopSpeechEvent event,
    Emitter<SpeechState> emit,
  ) async {
    emit(SpeechLoaded(_recognizedWords));
  }
}
