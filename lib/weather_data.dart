import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  var status = await Permission.location.status;

  if (status.isDenied) {
    // Request permission
    status = await Permission.location.request();
  }

  if (status.isGranted) {
    print("Location permission granted");
  } else {
    print("Location permission denied");
  }
}

class WeatherService {
  final String apiKey = 'OPENAI';

  Future<String> getWeatherCondition(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['weather'][0]['main']; // e.g., "Rain", "Clear", "Snow"
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}

String getTimeOfDay() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return "morning"; // Morning: 5 AM to 12 PM
  } else if (hour >= 12 && hour < 18) {
    return "afternoon"; // Afternoon: 12 PM to 6 PM
  } else if (hour >= 18 && hour < 21) {
    return "evening"; // Evening: 6 PM to 9 PM
  } else {
    return "night"; // Night: 9 PM to 5 AM
  }
}

class AIImageService {
  final String apiKey =
      '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';

  Future<String> generateImage(
      String weatherCondition, String timeOfDay) async {
    final url = 'https://api.openai.com/v1/images/generations';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "prompt":
          "A gradient photo depicting $weatherCondition weather during $timeOfDay having no light colours, high resolution, photorealistic",
      "n": 1,
      "size": "1024x1024"
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'][0]['url']; // Get the URL of the generated image
    } else {
      throw Exception('Failed to generate AI image');
    }
  }
}
