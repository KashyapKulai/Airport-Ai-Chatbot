import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final GenerativeModel _model;

  AIService(String apiKey)
      : _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

  Future<String> getAIResponse(String query) async {
    final content = [Content.text(query)];
    final response = await _model.generateContent(content);
    return response.text ?? "I couldn't generate a response.";
  }
}
