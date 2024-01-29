import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InvoiceApiService {
  static Future<List<dynamic>> getInvoiceData(
      String transporterId, String fromTimestamp, String toTimestamp) async {
    final String invoiceApi = dotenv.get('invoiceApiUrl');
    final response = await http.get(Uri.parse(
        '$invoiceApi?fromTimestamp=$fromTimestamp&toTimestamp=$toTimestamp&transporterId=$transporterId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      debugPrint('Error Status Code: ${response.statusCode}');
      debugPrint('Error Response Body: ${response.body}');
      throw Exception('Failed to load invoice');
    }
  }

// post invoice data
  static Future<String?> postInvoiceData(
    String transporterId,
    String? transportername,
    String? partyName,
    String? invoiceNumber,
    String? invoiceDate,
    String? invoiceAmount,
    List<String>? selectedBookingIds,
  ) async {
    final Map<String, dynamic> data = {
      'transporterId': transporterId,
      'transporterName': transportername,
      'partyName': partyName,
      'invoiceNo': invoiceNumber,
      'invoiceDate': invoiceDate,
      'invoiceAmount': invoiceAmount,
      'bookingId': selectedBookingIds,
    };

    final String invoiceApi = dotenv.get('invoiceApiUrl');
    final response = await http.post(
      Uri.parse('$invoiceApi'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Successfully created invoice
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('invoiceId')) {
        String invoiceId = responseData['invoiceId'].toString();
        print('Invoice created successfully! Invoice ID: $invoiceId');
        return invoiceId;
      } else {
        print(
            'Invoice created, but unable to retrieve invoiceId from the response.');
        return null;
      }
    } else {
      // Handle API error
      print('Failed to create invoice. Status code: ${response.statusCode}');
      return null;
    }
  }
}
