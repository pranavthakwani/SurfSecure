import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<int> fetchData(String url) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      }, // Set to form data
      body: {'url': url}, // Send URL as form data
    );

    if (response.statusCode == 200) {
      // Assuming the Flask API returns a JSON object
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Check for a specific key in the response
      return responseData['prediction'] ?? 'No classification available';
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }
}
