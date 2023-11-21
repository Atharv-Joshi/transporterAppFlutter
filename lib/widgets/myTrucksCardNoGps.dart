import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/models/deviceModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../controller/transporterIdController.dart';
import '../functions/deviceApiCalls.dart';
class myTrucksCardNoGps extends StatefulWidget {
  var truckno;
  DeviceModel device;
  myTrucksCardNoGps(
      this.truckno,
      this.device
      );

  @override
  State<myTrucksCardNoGps> createState() => _myTrucksCardNoGpsState();
}

class _myTrucksCardNoGpsState extends State<myTrucksCardNoGps> {
  TruckFilterVariables truckFilterVariables = TruckFilterVariables();
  DeviceApiCalls deviceApiCalls= DeviceApiCalls();
  TransporterIdController transporterIdController =
  Get.find<TransporterIdController>();
  bool expired = true;
  Razorpay razorpay = new Razorpay();
  String key = dotenv.get("paymentkey");
  String keysecret = dotenv.get("paymentkeysecret");
  String orderapi = dotenv.get("razorpayorder");
  int amount = 100;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      DateTime today = DateTime.now();
      DateTime sub = DateTime.parse(widget.device.expire!);
      print(sub);
      if (today.compareTo(sub) < 0) {
        expired = false;
      }
    }catch(e){
      print("SUB EXCEPTION");
    }
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, eventpaymentsuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,eventpaymentfailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,externalwallet);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }
  void eventpaymentsuccess(PaymentSuccessResponse r){
    print(widget.device.deviceId);
    print(widget.device.imei);
    print(widget.device.truckno);
    var r = deviceApiCalls.UpdateSubsription(truckId: widget.device.deviceId.toString(), uniqueId: widget.device.imei.toString(), truckName: widget.device.truckno!);
    print("PAYMENT  SUCCESS ");
    print(r);
  }
  void eventpaymentfailure(PaymentFailureResponse r){
    print("Payment Failure");
  }
  void externalwallet(ExternalWalletResponse r){
    print("External wallet");
  }
  void checkout() async{
    String mob_no = transporterIdController.mobileNum.value;
    var orderoptions = {
      "amount": amount,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    final client = HttpClient();
    final request =
    await client.postUrl(Uri.parse('$orderapi'));
    request.headers.set(
        HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode(
            '${key}:${keysecret}'));
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    request.add(utf8.encode(json.encode(orderoptions)));
    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      print('ORDERID'+contents);
      String orderId = contents.split(',')[0].split(":")[1];
      orderId = orderId.substring(1, orderId.length - 1);
      var options = {
        'key': '${key}',
        'amount': amount, //in the smallest currency sub-unit.
        'name': 'Liveasy',
        'order_id': '$orderId', // in seconds
        'prefill': {
          'contact': '$mob_no',
          'email': 'cj1412@example.com'
        },
        'external':{
          'wallets':['paytm']
        },
      };
      try{

        razorpay.open(options);
      }
      catch(e){
        print(e.toString());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print("${widget.device.truckno} + ${widget.device.expire}");
    return expired == true? Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: GestureDetector(
        onTap: () {
        },
        child: Card(
          elevation: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(space_3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/box-truck.png',
                            width: 29,
                            height: 29,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              Text(
                                '${widget.truckno}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                ),
                              ),
                              /*   Text(
                                'time date ',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: black,
                                  ),

                              ),*/
                            ],
                          ),
                          Spacer(),
                          /*Container(
                            child: Column(
                              children: [
                                Text("0 km/h",
                                    style: TextStyle(
                                        color: red,
                                        fontSize: size_10,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight)),
                                Text('stopped'.tr,
                                    // "Status",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: size_6,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight))
                              ],
                            ),
                          )*/
                        ],
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Subcribe for this truck'.tr,
                              style: TextStyle(
                                fontWeight: mediumBoldWeight,
                                fontSize: 20,
                                color: black,
                              ),
                            ),

                          )
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text("2000 / year",
                            style: TextStyle(
                              fontWeight: mediumBoldWeight,
                              fontSize: 20,
                              color: black,
                            ),)
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                            width: space_24,
                            height: space_8,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                backgroundColor: MaterialStateProperty.all<Color>(truckGreen),
                              ),
                              onPressed: ()async{
                                checkout();
                              },
                              child: Text(
                                'Buy Now',
                                style: TextStyle(
                                  fontWeight: mediumBoldWeight,
                                  fontSize: size_9,
                                  color: white,
                                ),
                              ),
                            ),
                          )
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ):
    Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: GestureDetector(
        onTap: () {
        },
        child: Card(
          elevation: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(space_3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/box-truck.png',
                            width: 29,
                            height: 29,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              Text(
                                '${widget.truckno}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                ),
                              ),
                              /*   Text(
                                'time date ',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: black,
                                  ),

                              ),*/
                            ],
                          ),
                          Spacer(),
                          /*Container(
                            child: Column(
                              children: [
                                Text("0 km/h",
                                    style: TextStyle(
                                        color: red,
                                        fontSize: size_10,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight)),
                                Text('stopped'.tr,
                                    // "Status",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: size_6,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight))
                              ],
                            ),
                          )*/
                        ],
                      ),
                      SizedBox(
                        height: 11,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
