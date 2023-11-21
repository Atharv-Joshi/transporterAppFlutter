import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/fastagModel.dart';

Future<List<TollPlazaData>> fetchTollPlazaData(String vehicleNumber) async {
  try {
    final String fastagApiUrl = dotenv.get('fastagApiUrl').toString();
    final response = await http.post(
      Uri.parse(fastagApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'vehiclenumber': vehicleNumber}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final List<dynamic> txnList = jsonResponse['response'][0]['response']
          ['vehicle']['vehltxnList']['txn'];

      final List<TollPlazaData> tollPlazaDataList =
          txnList.map((data) => TollPlazaData.fromJson(data)).toList();

      return tollPlazaDataList;
    } else {
      throw Exception('Failed to load toll plaza data');
    }
  } catch (e) {
    return [];
  }
}
