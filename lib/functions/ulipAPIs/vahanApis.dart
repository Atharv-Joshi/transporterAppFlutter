import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import '../../models/vahanApisModel.dart';

Future<VehicleDetails> fetchVehicleDetails(String vehicleNumber) async {
  final String vahanApiUrl = dotenv.get('vahanApiUrl').toString();

  // Create the request body
  final requestBody = jsonEncode({
    "vehiclenumber": "$vehicleNumber",
  });

  final response = await http.post(
    Uri.parse(vahanApiUrl),
    headers: {
      'accept': 'application/json',
      'content-type': 'application/json',
    },
    body: requestBody,
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);

    // Check if the "response" key exists in the JSON response
    if (jsonResponse.containsKey('response') &&
        jsonResponse['response'] is List) {
      final responseList = jsonResponse['response'];

      if (responseList.isNotEmpty) {
        // Take the first response from the list
        final firstResponse = responseList[0];

        // Extract the XML content
        if (firstResponse.containsKey('response')) {
          final xmlResponse = firstResponse['response'];

          // Parse the XML content
          final documents = XmlDocument.parse(xmlResponse);
          final root = documents.rootElement;

          if (root.name.local == 'VehicleDetails') {
            return VehicleDetails.fromXml(root);
          }
        }
      }
    }

    throw Exception('Invalid response format');
  } else {
    throw Exception('Failed to load vehicle details');
  }
}
