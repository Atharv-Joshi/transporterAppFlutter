import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EwayBill {
  Future<List<Map<String, dynamic>>> getAllEwayBills(
      String gstNo, String from, String to) async {
    final String url = dotenv.get("ewayBill");

    try {
      http.Response response = await http.get(
          Uri.parse('$url?fromGstin=$gstNo&fromDate=$from&toDate=$to'),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<Map<String, dynamic>> EwayBills =
            jsonResponse.cast<Map<String, dynamic>>();
        return EwayBills;
      } else {
        return [];
      }
    } catch (e) {
      print("Error : $e");
      return [];
    }
  }
}
