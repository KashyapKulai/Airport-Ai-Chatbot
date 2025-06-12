import 'dart:convert';
import 'package:http/http.dart' as http;

class AviationStackService {
  final String apiKey = 'e34551519613bca116750b306a6c2dcc';

  Future<String> getFlightStatus(String flightNumber) async {
    final response = await http.get(
      Uri.parse('http://api.aviationstack.com/v1/flights?access_key=$apiKey&flight_iata=$flightNumber'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'].isNotEmpty) {
        var flight = data['data'][0];
        return "Flight ${flight['flight']['iata']} is currently ${flight['flight_status']}.";
      }
    }
    return "Flight status not found.";
  }
}
