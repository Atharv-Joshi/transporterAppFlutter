import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchBookingData(
      transporterId) async {
    try {
      final String bookingApiUrl = dotenv.get('bookingApiUrl');
      final response = await http.get(Uri.parse(
          '$bookingApiUrl?transporterId=$transporterId&completed=false&cancel=false'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load invoice data');
      }
    } catch (e) {
      print('Error fetching invoice data: $e');
      return [];
    }
  }
}
