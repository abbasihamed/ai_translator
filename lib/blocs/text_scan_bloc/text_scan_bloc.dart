import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// Events
abstract class TextScanEvent extends Equatable {
  const TextScanEvent();

  @override
  List<Object> get props => [];
}

class InitializeTextScannerEvent extends TextScanEvent {}

class ProcessImageEvent extends TextScanEvent {
  final String imagePath;

  const ProcessImageEvent(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class UpdateScannedTextEvent extends TextScanEvent {
  final String text;

  const UpdateScannedTextEvent(this.text);

  @override
  List<Object> get props => [text];
}

// States
abstract class TextScanState extends Equatable {
  const TextScanState();

  @override
  List<Object> get props => [];
}

class TextScanInitial extends TextScanState {}

class TextScanLoading extends TextScanState {}

class TextScanLoaded extends TextScanState {
  final String scannedText;

  const TextScanLoaded(this.scannedText);

  @override
  List<Object> get props => [scannedText];
}

class TextScanError extends TextScanState {
  final String message;

  const TextScanError(this.message);

  @override
  List<Object> get props => [message];
}

class TextScanBloc extends Bloc<TextScanEvent, TextScanState> {
  final TextRecognizer _textRecognizer = TextRecognizer();

  TextScanBloc() : super(TextScanInitial()) {
    on<InitializeTextScannerEvent>((event, emit) {
      emit(TextScanInitial());
    });

    on<ProcessImageEvent>((event, emit) async {
      emit(TextScanLoading());
      try {
        final inputImage = InputImage.fromFilePath(event.imagePath);
        final recognizedText = await _textRecognizer.processImage(inputImage);
        emit(TextScanLoaded(recognizedText.text));
      } catch (e) {
        emit(TextScanError(e.toString()));
      }
    });

    on<UpdateScannedTextEvent>((event, emit) {
      emit(TextScanLoaded(event.text));
    });
  }

  @override
  Future<void> close() {
    _textRecognizer.close();
    return super.close();
  }
}
