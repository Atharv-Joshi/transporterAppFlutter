import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/transporterModel.dart';

class TransporterApiCalls {
  final String transporterApiUrl = FlutterConfig.get("transporterApiUrl");

  Future<TransporterModel> getDataByTransporterId(String? transporterId) async {
    print('in getDataByTransporterId');
    http.Response response =
        await http.get(Uri.parse('$transporterApiUrl/$transporterId'));
    var jsonData = json.decode(response.body);
    print('transporter json data ; $jsonData');
    TransporterModel transporterModel = TransporterModel();
    transporterModel.transporterLocation =
        jsonData['transporterLocation'] != null
            ? jsonData['transporterLocation']
            : 'Na';
    print(' location ${transporterModel.transporterLocation}');
    transporterModel.transporterPhoneNum =
        jsonData['phoneNo'] != null ? jsonData['phoneNo'].toString() : '';
    print(' number ${transporterModel.transporterPhoneNum}');
    transporterModel.transporterId =
        jsonData['transporterId'] != null ? jsonData['transporterId'] : 'Na';
    print(' id ${transporterModel.transporterId}');
    transporterModel.transporterName = jsonData['transporterName'] != null
        ? jsonData['transporterName']
        : 'Na';
    print(' transporterName ${transporterModel.transporterName}');
    transporterModel.companyName =
        jsonData['companyName'] != null ? jsonData['companyName'] : 'Na';
    print(' companyName ${transporterModel.companyName}');
    transporterModel.transporterApproved = jsonData['transporterApproved'];
    print(' transporterApproved ${transporterModel.transporterApproved}');
    transporterModel.companyApproved = jsonData['companyApproved'];
    print(' companyApproved ${transporterModel.companyApproved}');
    transporterModel.accountVerificationInProgress =
        jsonData['accountVerificationInProgress'];
    print(' accountVerificationInProgress ${transporterModel.accountVerificationInProgress}');

    return transporterModel;
  }
}
