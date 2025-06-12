import 'dart:convert';
import 'package:http/http.dart' as http;

class CohereService {
  final String apiKey = '1xILMQTvjN2rIMjNS2tV4RJsoSDaEKp2rDxancDF';

  Future<String> getChatResponse(String message) async {
    final response = await http.post(
      Uri.parse('https://api.cohere.ai/generate'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "command",
        "prompt": "User: $message\nAI:",
        "max_tokens": 100,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['generations'][0]['text'];
    } else {
      return "Error: Unable to fetch response";
    }
  }
}
