import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  bool _isInitialized = false;

  Future<void> _initialize() async {
    if (_isInitialized) return;

    final apiKey = "AIzaSyBvg2mVwlYdumXIWV966xo3GSyrnVqrkDo";

    if (apiKey.isEmpty) {
      throw Exception(
        'Gemini API key not found. Please set the GEMINI_API_KEY in .env file.',
      );
    }

    _model = GenerativeModel(model: 'gemini-2.0-flash-lite', apiKey: apiKey);

    _isInitialized = true;
  }

  Future<String> translateText(
    String text,
    String sourceLanguage,
    String targetLanguage,
  ) async {
    await _initialize();

    try {
      final prompt = '''
        Translate the following text from $sourceLanguage to $targetLanguage.
        Be accurate and preserve the meaning and tone of the original text.
        Only return the translated text, without any additional commentary.
        
        Text to translate: "$text"
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      return response.text!;
    } catch (e) {
      throw Exception('Translation error: ${e.toString()}');
    }
  }
}
