import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/vahanApisModel.dart';
import 'package:xml/xml.dart';

class checkFastTag {
  //Fetch the fastag location of any truck
  getVehicleLocation(String vehicle) async {
    final String url = dotenv.get("fastTag");

    final Map<String, dynamic> params = {"vehiclenumber": vehicle};

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(params),
    );

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    try {
      final String errCode =
          jsonResponse['response'][0]['response']['vehicle']['errCode'];
      //Here we are not directly checking the status code because of the response of the API

      if (errCode == "000") {
        final List<dynamic> txnList = jsonResponse['response'][0]['response']
            ['vehicle']['vehltxnList']['txn'];
        //Reversing the list to get the data sorted according to the location time
        var reversedList = List.from(txnList.reversed);

        for (int i = 0; i < reversedList.length; i++) {
          //Here we are fetching the complete address of the the tollPlazaName with the latitude and longitude
          //Coming in the response.
          String address = await fetchAddressForWeb(
            double.parse(reversedList[i]['tollPlazaGeocode'].split(',')[0]),
            double.parse(reversedList[i]['tollPlazaGeocode'].split(',')[1]),
          );
          reversedList[i]['address'] = address;
        }
        return reversedList.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      print("error message: $e ");
      return [];
    }
  }

//Fetch the address of any location with the latitude and longitude using the Google Place API
//Because the geocoding package doesn't work for the web, it only works for iOS and Android.
  Future<String> fetchAddressForWeb(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${dotenv.get('mapKey')}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final String address = data['results'][0]['formatted_address'];
        return address.toString();
      }
    }
    return 'Address not found';
  }

//Fetch details of any vehicle like driver name, registration number any many more
  Future<VehicleDetails> fetchVehicleDetails(String vehicleNumber) async {
    final String vahanApiUrl = dotenv.get('vahanUrl');

    // Create the request body
    final requestBody = jsonEncode({
      "vehiclenumber": vehicleNumber,
    });

    try {
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
        debugPrint('API Response: $jsonResponse');

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
                final vehicleDetails = VehicleDetails.fromXml(root);
                return vehicleDetails;
              }
            }
          }
        }

        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load vehicle details');
      }
    } catch (e) {
      debugPrint('Error fetching vehicle details: $e');
      throw e;
    }
  }
}
