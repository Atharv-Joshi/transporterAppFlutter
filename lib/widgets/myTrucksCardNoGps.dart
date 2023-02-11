import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (context){
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)
              ),
              backgroundColor: Colors.grey[300],
              elevation: 20,
              child:
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("Buy GPS"),
                      ),
                    )
            );
          });
          
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
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0, 5, 5, 5),
                              child: Icon(
                                Icons.circle,
                                color: const Color(0xffFF4D55),
                                size: 6,
                              ),
                            ),
                            Text(
                              "Buy Gps for this truck",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
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
