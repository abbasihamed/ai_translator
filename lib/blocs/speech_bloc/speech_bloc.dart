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
  }

  bool _isInitial = false;

  Future<void> _initialSpeech(
    SpeechEvent event,
    Emitter<SpeechState> emit,
  ) async {
    _isInitial = await _speechService.initialize(
      finalTimeout: const Duration(seconds: 3),
    );
  }

  Future<void> _onStartSpeech(
    StartSpeechEvent event,
    Emitter<SpeechState> emit,
  ) async {
    if (_isInitial) {
      await _speechService.listen(
        onResult: (result) {
          add(_SpeechWordEvent(recognizedWords: result.recognizedWords));
        },
      );
    } else {
      print('Speech service is not initialized');
    }
  }

  FutureOr<void> _onSpeechWord(
    _SpeechWordEvent event,
    Emitter<SpeechState> emit,
  ) {
    emit(SpeechLoaded(event.recognizedWords));
  }

  @override
  Future<void> close() {
    _speechService.stop();
    return super.close();
  }
}
