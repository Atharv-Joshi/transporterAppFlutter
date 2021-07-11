import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/transporterModel.dart';

class TransporterApiCalls {
  final String transporterApiUrl = FlutterConfig.get("transporterApiUrl");

  Future<TransporterModel> getDataByTransporterId(String? transporterId) async {

    http.Response response =
        await http.get(Uri.parse('$transporterApiUrl/$transporterId'));
    var jsonData = json.decode(response.body);

    TransporterModel transporterModel = TransporterModel();
    transporterModel.transporterLocation =
        jsonData['transporterLocation'] != null
            ? jsonData['transporterLocation']
            : 'Na';

    transporterModel.transporterPhoneNum =
        jsonData['phoneNo'] != null ? jsonData['phoneNo'].toString() : '';

    transporterModel.transporterId =
        jsonData['transporterId'] != null ? jsonData['transporterId'] : 'Na';

    transporterModel.transporterName = jsonData['transporterName'] != null
        ? jsonData['transporterName']
        : 'Na';

    transporterModel.companyName =
        jsonData['companyName'] != null ? jsonData['companyName'] : 'Na';

    transporterModel.transporterApproved = jsonData['transporterApproved'];

    transporterModel.companyApproved = jsonData['companyApproved'];

    transporterModel.accountVerificationInProgress =
        jsonData['accountVerificationInProgress'];


    return transporterModel;
  }
}
