import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Function to fetch invoice document links based on invoice ID and document type
Future<List<String>> getInvoiceDocApiCall(
    String invoiceId, String docType) async {
  try {
    final String documentApiUrl = dotenv.get('documentApiUrl');
    final response = await http.get(Uri.parse("$documentApiUrl$invoiceId"));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonData = json.decode(response.body);
      var invoiceDocLinks = <String>[];

      for (var jsondata in jsonData["documents"]) {
        if (jsondata["documentType"] == 'invoiceBill') {
          // URL decode the documentLink before adding to the list
          String decodedLink = Uri.decodeFull(jsondata["documentLink"]);
          invoiceDocLinks.add(decodedLink);
        }
      }

      return invoiceDocLinks;
    } else {
      print(response.statusCode);
      print('could not fetch');
      return [];
    }
  } catch (e) {
    debugPrint("Error fetching document links: $e");
    return [];
  }
}
