import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ai_service.dart';

void main() {
  runApp(AILayoverAssistantApp());
}

class AILayoverAssistantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Layover Assistant',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white))

      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ChatScreen(),
        '/layover': (context) => LayoverServicesPage(),
        '/nearest': (context) => LayoverServicesPage(),
        '/near': (context) => LayoverServicesPage(),
        '/flightStatus': (context) => FlightStatusPage(),
        '/faq': (context) => FAQPage(),
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [];
  TextEditingController controller = TextEditingController();
  final AIService aiService = AIService('AIzaSyD3myGLKZGVlQOFCWlWxpete4-uodAZ03E');

  void processMessage(String text) {
    addMessage(text, true);

    String lowerText = text.toLowerCase();
    if (lowerText.contains("status")) {
      Navigator.pushNamed(context, '/flightStatus');
      return;
    } else if (lowerText.contains("faq")) {
      Navigator.pushNamed(context, '/faq');
      return;
    } else if (lowerText.contains("layover")) {
      Navigator.pushNamed(context, '/layover');
      return;
    }else if (lowerText.contains("nearest")) {
      Navigator.pushNamed(context, '/nearest');
      return;
    }else if (lowerText.contains("near")) {
      Navigator.pushNamed(context, '/near');
      return;
    }

    aiService.getAIResponse(text).then((response) {
      addMessage(response, false);
    }).catchError((error) {
      addMessage("⚠️ Error fetching AI recommendation.", false);
    });

    controller.clear();
  }

  void addMessage(String text, bool isUser) {
    setState(() {
      messages.add(ChatMessage(text: text, isUser: isUser));
    });
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('💬 AI Layover Chatbot', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
    ),
    backgroundColor: Colors.grey[900],
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true, // Scroll to latest message
            padding: EdgeInsets.all(8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              ChatMessage message = messages[messages.length - 1 - index]; // Reverse message order
              return Align(
                alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: EdgeInsets.all(12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75, // Limit width for better readability
                  ),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.grey[850] : Colors.grey[700],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: message.isUser ? Radius.circular(12) : Radius.zero,
                      bottomRight: message.isUser ? Radius.zero : Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!message.isUser) ...[
                        Icon(Icons.smart_toy, color: Colors.white, size: 20),
                        SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          message.text,
                          style: TextStyle(color: Colors.white),
                          softWrap: true,
                        ),
                      ),
                      if (message.isUser) ...[
                        SizedBox(width: 6),
                        Icon(Icons.person, color: Colors.white, size: 20),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Divider(height: 1, color: Colors.white),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.black),
                  onPressed: () {
                    String text = controller.text.trim();
                    if (text.isNotEmpty) {
                      processMessage(text);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📌 FAQs')),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white),
            title: Text('How to claim flight delay compensation?', style: TextStyle(color: Colors.white)),
            subtitle: Text('Contact your airline or use compensation services.', style: TextStyle(color: Colors.white70)),
          ),
          Divider(color: Colors.white30),
          ListTile(
            leading: Icon(Icons.airplane_ticket, color: Colors.white),
            title: Text('What to do during a layover?', style: TextStyle(color: Colors.white)),
            subtitle: Text('Visit lounges, book hotels, explore duty-free shops.', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}


class FlightStatusPage extends StatefulWidget {
  @override
  _FlightStatusPageState createState() => _FlightStatusPageState();
}

class _FlightStatusPageState extends State<FlightStatusPage> {
  List<ChatMessage> messages = [];
  TextEditingController controller = TextEditingController();

  Future<void> fetchFlightStatus(String flightNumber) async {
    final response = await http.get(Uri.parse('https://api.aviationstack.com/v1/flights?access_key=e34551519613bca116750b306a6c2dcc&flight_iata=$flightNumber'));
    
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['data'].isNotEmpty) {
        var flight = data['data'][0];
        String status = flight['flight_status'] ?? 'Unknown';
        String departure = flight['departure']['airport'] ?? 'Unknown';
        String arrival = flight['arrival']['airport'] ?? 'Unknown';
        
        addMessage("Flight Status: $status", false);
        addMessage("Departure: $departure", false);
        addMessage("Arrival: $arrival", false);
      } else {
        addMessage("No flight information found.", false);
      }
    } else {
      addMessage("Failed to load flight status.", false);
    }
  }

  void processMessage(String text) {
    addMessage(text, true);
    fetchFlightStatus(text);
    controller.clear();
  }

  void addMessage(String text, bool isUser) {
    setState(() {
      messages.add(ChatMessage(text: text, isUser: isUser));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flight Status Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                ChatMessage message = messages[index];
                return Container(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.blueAccent : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message.text, style: TextStyle(color: message.isUser ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller, decoration: InputDecoration(hintText: "Enter Flight Number..."))),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String text = controller.text.trim();
                    if (text.isNotEmpty) {
                      processMessage(text);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LayoverServicesPage extends StatefulWidget {
  @override
  _LayoverServicesPageState createState() => _LayoverServicesPageState();
}

class _LayoverServicesPageState extends State<LayoverServicesPage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng _currentLocation = LatLng(40.6413, -73.7781); // Default JFK Airport
  String googlePlacesApiKey = 'AIzaSyDWQRP58C4WZN2U_A7cjBmfn_AdkzYLvlk';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNearbyPlaces();
  }

  /// Fetch nearby places dynamically from Google Places API
  Future<void> _fetchNearbyPlaces() async {
    List<String> placeTypes = ['hotel', 'restaurant', 'park', 'lodging'];
    for (String type in placeTypes) {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation.latitude},${_currentLocation.longitude}&radius=2000&type=$type&key=$googlePlacesApiKey');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          _addPlacesToMap(data['results'], type);
        }
      }
    }
  }

  /// Add fetched places to the map
  void _addPlacesToMap(List<dynamic> places, String type) {
    BitmapDescriptor markerColor;
    switch (type) {
      case 'hotel':
        markerColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        break;
      case 'restaurant':
        markerColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        break;
      case 'park':
        markerColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        break;
      case 'lodging':
        markerColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
        break;
      default:
        markerColor = BitmapDescriptor.defaultMarker;
    }

    setState(() {
      for (var place in places) {
        final LatLng position = LatLng(
            place['geometry']['location']['lat'], place['geometry']['location']['lng']);

        markers.add(Marker(
          markerId: MarkerId(place['place_id']),
          position: position,
          icon: markerColor,
          infoWindow: InfoWindow(title: place['name']),
        ));
      }
    });
  }

  /// Search for an airport and update the map location
  Future<void> _searchAirport(String query) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$query%20Airport&inputtype=textquery&fields=geometry,name&key=$googlePlacesApiKey');
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final LatLng newLocation = LatLng(
          data['candidates'][0]['geometry']['location']['lat'],
          data['candidates'][0]['geometry']['location']['lng'],
        );

        setState(() {
          _currentLocation = newLocation;
          markers.clear(); // Clear existing markers
          markers.add(Marker(
            markerId: MarkerId('airport'),
            position: newLocation,
            infoWindow: InfoWindow(title: data['candidates'][0]['name']),
          ));
        });

        mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 14));
        _fetchNearbyPlaces();
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Layover Services')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for an airport...',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          String query = searchController.text.trim();
                          if (query.isNotEmpty) {
                            _searchAirport(query);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              markers: markers,
              initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 14),
            ),
          ),
        ],
      ),
    );
  }
}

