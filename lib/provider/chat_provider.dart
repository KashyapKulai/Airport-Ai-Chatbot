import 'package:flutter/material.dart';
import '../services/cohere_service.dart';
import '../services/aviation_stack_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  final CohereService _cohereService = CohereService();
  final AviationStackService _aviationService = AviationStackService();
  bool _isLoading = false;

  List<Map<String, String>> get messages => _messages;
  bool get isLoading => _isLoading;

  void addMessage(String message, String sender) {
    _messages.add({"text": message, "sender": sender});
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    addMessage(message, "user");

    // Show loading bubble
    _isLoading = true;
    notifyListeners();

    String response;
    if (message.toLowerCase().contains("flight")) {
      var flightNumber = message.split(" ").last; // Extract flight number
      response = await _aviationService.getFlightStatus(flightNumber);
    } else {
      response = await _cohereService.getChatResponse(message);
    }

    // Hide loading bubble
    _isLoading = false;
    addMessage(response, "bot");
    notifyListeners();
  }
}
