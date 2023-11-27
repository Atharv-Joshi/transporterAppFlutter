import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/SelectedDriverController.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/responseModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'dart:convert';
import 'package:liveasy/models/driverModel.dart';

//This class should contain all the api calls related to driver api
//This is important so that it's easier to search up the required files
class DriverApiCalls {
  List<DriverModel> driverList = [];

  late List jsonData;

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  SelectedDriverController selectedDriverController =
      Get.put(SelectedDriverController());

  final String driverApiUrl = dotenv.get('driverApiUrl');

  //GET DRIVERS BY TRANSPORTER ID-----------------------------------------------

  //This function gets all the drivers of a particular transporter and returns a list of driver models. The for loop is used to counter pagination implemented in backend.
  Future<List<DriverModel>> getDriversByTransporterId() async {
    driverList = [];
    for (int i = 0;; i++) {
      http.Response response = await http.get(Uri.parse(
          '$driverApiUrl?transporterId=${transporterIdController.transporterId.value}&pageNo=$i'));

      jsonData = json.decode(response.body);
      if (jsonData.isEmpty) {
        break;
      }
      for (var json in jsonData) {
        DriverModel driverModel = DriverModel();
        driverModel.driverId =
            json["driverId"] != null ? json["driverId"] : 'NA';
        driverModel.transporterId =
            json["transporterId"] != null ? json["transporterId"] : 'NA';
        driverModel.phoneNum =
            json["phoneNum"] != null ? json["phoneNum"] : 'NA';
        driverModel.driverName =
            json["driverName"] != null ? json["driverName"] : 'NA';
        driverModel.truckId = json["truckId"] != null ? json["truckId"] : 'NA';
        driverList.add(driverModel);
      }
    }
    return driverList;
  }

  Future<List<DriverModel>> getDriverData() async {
    driverList = [];
    String? traccarUser = transporterIdController.mobileNum.value;
    String traccarPass = dotenv.get("traccarPass");
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
    http.Response response = await http.get(
      Uri.parse("$driverApiUrl/api/drivers"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
    );
    jsonData = await jsonDecode(response.body);
    for (var json in jsonData) {
      DriverModel driverModel = DriverModel();
      driverModel.id = json["id"];
      driverModel.driverName = json["name"];
      driverModel.phoneNum = json["uniqueId"];
      print("---------------------------->$json");
      driverList.add(driverModel);
    }
    print("${driverList.length}-----------DRIVER LIST LENGTH----");
    return driverList;
  }

  //----------------------------------------------------------------------------

  //This function gets the details of a single driver by using the  driverId
  //IT takes two parameters from which only one needs to be provided during function call.
  Future<dynamic> getDriverByDriverId(
      {String? driverId, TruckModel? truckModel}) async {
    String? id = driverId;
    if (id != 'NA') {
      http.Response response =
          await http.get(Uri.parse('$driverApiUrl/api/drivers/$id'));
      print(response.body);
      if (response.statusCode == 200) {
        Map jsonData = json.decode(response.body);
        DriverModel driverModel = DriverModel();
        driverModel.driverId = jsonData["id"] != null ? jsonData["id"] : 'NA';
        driverModel.phoneNum =
            jsonData["att"] != null ? jsonData["phoneNum"] : 'NA';
        driverModel.driverName =
            jsonData["name"] != null ? jsonData["name"] : 'NA';
        driverModel.truckId =
            jsonData["truckId"] != null ? jsonData["truckId"] : 'NA';
        return driverModel;
      } else {
        //case when server returns status code like 404, driver not found
        DriverModel driverModel = DriverModel();
        driverModel.driverId = 'NA';
        driverModel.transporterId = 'NA';
        driverModel.phoneNum = 'NA';
        driverModel.driverName = 'NA';
        driverModel.truckId = 'NA';
      }
    } else {
      DriverModel driverModel = DriverModel();
      driverModel.driverId = 'NA';
      driverModel.transporterId = 'NA';
      driverModel.phoneNum = 'NA';
      driverModel.driverName = 'NA';
      driverModel.truckId = 'NA';
      return driverModel;
    }
  }

  //POST DRIVER-----------------------------------------------------------------

  postDriverApi(driverName, phoneNum, transporterId) async {
    try {
      Map data = {
        "driverName": driverName,
        "phoneNum": phoneNum,
        "transporterId": transporterId
      };
      String body = json.encode(data);

      final response = await http.post(Uri.parse("$driverApiUrl"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      print("driver Api response : ${response.body}");
      var decodedData = json.decode(response.body);
      ResponseModel returnResponse = ResponseModel();
      if (decodedData["driverId"] != null) {
        returnResponse.statusCode = response.statusCode;
        returnResponse.id = decodedData["driverId"];

        returnResponse.message = decodedData["status"];

        print(
            "driverApiCalls.api${selectedDriverController.newDriverAddedBook.value}");
        print(
            "driverApiCalls.api TRuck ${selectedDriverController.newDriverAddedTruck.value}");
        print(
            "driverApiCalls.api FRomTRuck ${selectedDriverController.fromTruck.value}");

        if (selectedDriverController.fromBook.value) {
          selectedDriverController.updateNewDriverAddedBookController(true);
          selectedDriverController
              .updateSelectedDriverBookController('${returnResponse.id}');
        } else if (selectedDriverController.fromTruck.value) {
          selectedDriverController.updateNewDriverAddedTruckController(true);
          selectedDriverController
              .updateSelectedDriverTruckController('${returnResponse.id}');
        }
        return returnResponse;
      } else {
        returnResponse.statusCode = response.statusCode;
        returnResponse.message = decodedData["apierror"]["debugMessage"];
        return returnResponse;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> editDriver(
      {DriverModel? driverData, String? driverId, String? driverName}) async {
    String? traccarUser = transporterIdController.mobileNum.value;
    String traccarPass = dotenv.get("traccarPass");
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

    Map data = {
      "id": driverData?.id,
      "attributes": {"phone": driverData?.phoneNum},
      "name": driverName,
      "uniqueId": driverData?.phoneNum
    };
    String body = json.encode(data);

    final String driverApiUrl = dotenv.get("driverApiUrl").toString();

    final response = await http.put(
        Uri.parse("$driverApiUrl" + "/api/drivers/" + "$driverId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': basicAuth,
        },
        body: body);

    ResponseModel returnResponse = ResponseModel();
    var decodedData = json.decode(response.body);

    returnResponse.statusCode = response.statusCode;
    returnResponse.message = decodedData['message'];

    print("${returnResponse.message}--------message----");
    print("${returnResponse.statusCode}-----STATUS CODE-----");

    return returnResponse;
  }
}

//This function gets the details of a single driver by using the  driverId
//IT takes two parameters from which only one needs to be provided during function call.
Future<DriverModel> getDriverByDriverId(
    {String? driverId, TruckModel? truckModel}) async {
  final String driverApiUrl = dotenv.get('driverApiUrl');
  if (driverId != 'NA') {
    http.Response response =
        await http.get(Uri.parse('$driverApiUrl/$driverId'));
    print(response.body);
    if (response.statusCode == 200) {
      Map jsonData = json.decode(response.body);
      DriverModel driverModel = DriverModel();
      driverModel.driverId =
          jsonData["driverId"] != null ? jsonData["driverId"] : 'NA';
      driverModel.transporterId =
          jsonData["transporterId"] != null ? jsonData["transporterId"] : 'NA';
      driverModel.phoneNum =
          jsonData["phoneNum"] != null ? jsonData["phoneNum"] : 'NA';
      driverModel.driverName =
          jsonData["driverName"] != null ? jsonData["driverName"] : 'NA';
      driverModel.truckId =
          jsonData["truckId"] != null ? jsonData["truckId"] : 'NA';
      return driverModel;
    } else {
      //case when server returns status code like 404, driver not found
      DriverModel driverModel = DriverModel();
      driverModel.driverId = 'NA';
      driverModel.transporterId = 'NA';
      driverModel.phoneNum = 'NA';
      driverModel.driverName = 'NA';
      driverModel.truckId = 'NA';
      return driverModel;
    }
  } else {
    DriverModel driverModel = DriverModel();
    driverModel.driverId = 'NA';
    driverModel.transporterId = 'NA';
    driverModel.phoneNum = 'NA';
    driverModel.driverName = 'NA';
    driverModel.truckId = 'NA';
    return driverModel;
  }
}

Future<void> disableActionOnDriver({String? driverId}) async {
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  final String driverApiUrl = dotenv.get("driverApiUrl");

  String? traccarUser = transporterIdController.mobileNum.value;
  String traccarPass = dotenv.get("traccarPass");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

  final response = await http.delete(
    Uri.parse("$driverApiUrl/api/drivers/$driverId"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': basicAuth,
    },
  );

  print("driverId ====== $driverApiUrl/$driverId ");
  print("Response of disable data ${response.statusCode}");
} //class end
