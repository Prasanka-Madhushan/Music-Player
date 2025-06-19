// lib/services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyAXhybvLn_zhxcRjYM_Eg17fvlL2EWqY4k';
  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: _apiKey,
  );

  Future<String> getChatResponse(String prompt) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Could not generate response';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> getMusicRecommendation(String input) async {
    const systemPrompt = '''
    Act as a music recommendation expert. Analyze the user's input and suggest: 
    1. Music vibe/mood keywords (max 3)
    2. Short explanation
    3. Emoji representing the vibe
    Format: [VIBES|explanation text here|emoji]
    
    Example: [CHILL,RELAXED|Perfect for winding down after a long day|🌙]
    ''';

    final response = await getChatResponse('$systemPrompt\nUser: $input');
    return response;
  }
}