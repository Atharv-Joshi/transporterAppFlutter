// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../../models/sarathiModel.dart';
//
// Future<DLDetails> fetchDrivingLicense(String dlNumber, String dob) async {
//   final Map<String, dynamic> requestBody = {
//     "dlNumber": dlNumber, //will be entered by the user
//     "dob": dob,          //will be entered by the user
//   };
//
//   final response = await http.post(
//     '/sarathi',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(requestBody),
//   );
//
//   if (response.statusCode == 200) {
//     return DLDetails.fromJson(json.decode(response.body)); //response will be stored in DLDetails
//   } else {
//     throw Exception('Failed to load driving license data');
//   }
// }
