import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckDescriptionScreen.dart';
import 'package:liveasy/screens/myDriversScreen.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/widgets/alertDialog/addDriverAlertDialog.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/buttons/trackButton.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:liveasy/widgets/newRowTemplate.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class MyTruckCard extends StatefulWidget {
  TruckModel truckData;
  var gpsData;
  String truckAddress;
  String status;

  MyTruckCard(
      {
        required this.truckData,
        required this.truckAddress,
        required this.status,
        this.gpsData,
      });

  @override
  _MyTruckCardState createState() => _MyTruckCardState();
}

class _MyTruckCardState extends State<MyTruckCard> {
  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  bool? verified;
  Position? userLocation;
  bool driver = false;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var gpsRoute;
  var totalDistance;
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  late String from = yesterday.toIso8601String();
  late String to= now.toIso8601String();
  @override
  void initState() {
    super.initState();
    if(widget.truckData.deviceId != 0 && widget.truckData.truckApproved == true) {
      print("For ${widget.truckData.deviceId}");
      try {
        initfunction();
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {


    driver = widget.truckData.driverName != 'NA'?true:false;
    String truckType = truckFilterVariables.truckTypeValueList.contains(widget.truckData.truckType)
        ? truckFilterVariables.truckTypeTextList[truckFilterVariables.truckTypeValueList.indexOf(widget.truckData.truckType)]
        : 'NA';

    Map<String, Color> statusColor = {
      'Available': liveasyGreen,
      'Busy': Colors.red,
      'Offline': unselectedGrey,
    };

    verified =  widget.truckData.truckApproved;
    if (driver && widget.truckData.driverName!.length > 15) {
      widget.truckData.driverName = widget.truckData.driverName!.substring(0, 14) + '..';
    }

    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      
      child: GestureDetector(
        onTap: () async{
          // if (loading) {
            EasyLoading.instance
              ..indicatorType = EasyLoadingIndicatorType.ring
              ..indicatorSize = 45.0
              ..radius = 10.0
              ..maskColor = darkBlueColor
              ..userInteractions = false
              ..backgroundColor = darkBlueColor
              ..dismissOnTap = false;
            EasyLoading.show(
              status: "Loading...",
            );
            // getTruckHistory();
            
            print(widget.truckData.deviceId);

            var f =  getDataHistory(widget.truckData.deviceId, from,  to);
            var s = getStoppageHistory(widget.truckData.deviceId, from,  to);
            var t = getRouteStatusList(widget.truckData.deviceId, from,  to);

            gpsDataHistory =  await f;
            gpsStoppageHistory =  await s;
            gpsRoute =  await t;
            
            if (gpsRoute!= null && gpsDataHistory!= null && gpsStoppageHistory!= null && widget.truckData.truckApproved == true) {
              EasyLoading.dismiss();
              Get.to(
                TrackScreen(
                  deviceId:  widget.truckData.deviceId,
                  gpsData: widget.gpsData,
                  // position: position,
                  TruckNo:  widget.truckData.truckNo,
                  driverName: widget.truckData.driverName,
                  driverNum: widget.truckData.driverNum,
                  gpsDataHistory: gpsDataHistory,
                  gpsStoppageHistory: gpsStoppageHistory,
                  routeHistory: gpsRoute,
                  truckId: widget.truckData.truckId,
                ),
              );
            }
            else{
              EasyLoading.dismiss();
              print("gpsData null or truck not approved");
            }
        
        },
        child: Card(
          elevation: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
      
              children: [
                verified!
                    ?
                Container(
                  padding: EdgeInsets.all(space_3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
            ),
                  child: Column(
                    
                    children: [
                  /*    Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, space_2, 0),
                            height: space_2,
                            width: space_2,
                            decoration: BoxDecoration(
                              color: statusColor['Offline'],
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          
                          Text(
                            AppLocalizations.of(context)!.offline,
                            style: TextStyle(
                                fontWeight: mediumBoldWeight, fontSize: size_8),
                          ),
                        ],
                      ), */
                   /*   SizedBox(height: space_2,),
                      NewRowTemplate(label: AppLocalizations.of(context)!.vehicleNumber , value: widget.truckData.truckNo),
                      SizedBox(height: space_2,),*/
                      Row(
                        children: [
                          Image.asset('assets/icons/box-truck.png',
                          width: 29,
                          height: 29,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              Text(
                                '${widget.truckData.truckNo}',
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
                          Container(
                                      child: Column(
                                        children: [
                                          (widget.gpsData.last.speed>2)?
                                          Text("${(widget.gpsData.last.speed).round()} km/h",
                                              style: TextStyle(

                                                  color: liveasyGreen,
                                                  
                                                  fontSize: size_10,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: regularWeight)
                                          ):
                                          Text("${(widget.gpsData.last.speed).round()} km/h",
                                              style: TextStyle(

                                                  color: red,
                                                  
                                                  fontSize: size_10,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: regularWeight)
                                          ),
                                          Text('status'.tr,
                                              // "Status",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: size_6,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: regularWeight)
                                          )
                                        ],
                                      ),
                                    ),
                          
                      ],
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0), 
                        child: Row(
                          
                              mainAxisAlignment: MainAxisAlignment.start ,
                              children:[
                                
                                Icon(
                            
                            Icons.place_outlined ,
                            color:  const Color(0xFFCDCDCD),
                            size: 16,
                          ),
                          SizedBox(
                            width: 8
                        ),
                        Container(
                              width: 200,
                              child: 
                              Text(
                                
                                "${widget.gpsData.last.address}",
                                maxLines: 3,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 12,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: normalWeight
                                ),
                              ),
                            ),
                            ]
                            ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const  EdgeInsets.fromLTRB(25, 0, 0, 0), 
                        child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.info_outline,
                                                                  size: 14,
                                                                  color: const Color(0xFFCDCDCD),
                                                                ),
                                                                SizedBox(
                                                                    width: 8
                                                                ),
                                                                Text('truckTravelled'.tr,
                                                                    // "Truck Travelled : ",
                                                                    softWrap: true,
                                                                    style: TextStyle(
                                                                        color: black,
                                                                        fontSize: size_6,
                                                                        fontStyle: FontStyle.normal,
                                                                        fontWeight: regularWeight)),
                                                                Text("$totalDistance " + 'kmToday'.tr,
                                                                    // "km Today",
                                                                    softWrap: true,
                                                                    style: TextStyle(
                                                                        color: black,
                                                                        fontSize: size_6,
                                                                        fontStyle: FontStyle.normal,
                                                                        fontWeight: regularWeight)),
                                                              ],
                                                            ),
                      ),
                       SizedBox(
                        height: 6,
                      ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(26, 0, 0, 0),
                          child: Row(
                            children: [
                              Image.asset('assets/icons/circle-outline-with-a-central-dot.png',
                                  color: const Color(0xFFCDCDCD),
                                  width: 12,
                                  height: 12,),
                              SizedBox(
                                 width: 8,
                             ),
                
                              Text('ignition'.tr,
                                  // 'Ignition  :',
                              style: TextStyle(
                                color: black,
                                 fontSize: size_6,
                                 fontStyle: FontStyle.normal,
                                 fontWeight: regularWeight)),
                              (widget.gpsData.last.ignition)?
                              Text('on'.tr,
                                  // "ON",
                              style: TextStyle(
                                color: black,
                                 fontSize: size_6,
                                 fontStyle: FontStyle.normal,
                                 fontWeight: regularWeight)):
                                 Text('off'.tr,
                                     // "OFF",
                              style: TextStyle(
                                color: black,
                                 fontSize: size_6,
                                 fontStyle: FontStyle.normal,
                                 fontWeight: regularWeight)),

                             
                            ],
                          ),
                        ),
                                                        
                              /*       SizedBox(height: space_2,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.status}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: veryDarkGrey,
                            fontWeight: mediumBoldWeight,
                            fontSize: size_6,
                          ),
                        ),
                      ),
                      SizedBox(height: space_2,),
                      // NewRowTemplate(label: AppLocalizations.of(context)!.tyre, value: widget.truckData.tyres.toString()  , width: 98,),
                      // NewRowTemplate(label: AppLocalizations.of(context)!.driver, value: widget.truckData.driverName , width: 98,),
                      Container(
                        margin: EdgeInsets.only(top: space_2),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: space_2),
                                child: TrackButton(
                                  truckApproved: widget.truckData.truckApproved!,
                                  phoneNo: widget.truckData.driverNum,
                                  TruckNo: widget.truckData.truckNo,
                                  imei: widget.truckData.imei,
                                  DriverName: widget.truckData.driverName,
                                  gpsData: widget.gpsData,
                                  truckId: widget.truckData.truckId,
                                )
                            ),
                            CallButton(directCall: true , phoneNum: widget.truckData.driverNum,)
                          ],
                        ),
                      ),
                      */
                    ],
                  ),
                )
      
      
                    :   Container(
                      padding: EdgeInsets.all(space_3),
                      decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
            ),
                      child: Column(
                  children: [
                      Row(
                        children: [
                          Image.asset('assets/icons/box-truck.png',
                          width: 29,
                          height: 29,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              Text(
                                '${widget.truckData.truckNo}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                  
                                  ),
                              ),
                              Text(
                                "timedate".tr,
                                // 'time date ',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: black,
                                  ),
      
                              ),
                          ],
                          ),
                          SizedBox(
                            width: 23,
                          ),
                          
                      ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(27.00,20.00,20.00,0.00),
                        child: Row(
                          children: [
                            Image.asset('assets/icons/circle-outline-with-a-central-dot.png',
                                    color: const Color(0xFFCDCDCD),
                                    width: 12,
                                    height: 12,),
                            SizedBox(
                                   width: 8
                               ),
                            Text(
                              'buyGPS'.tr,
                              // 'Buy GPS to access live tracking',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF152968),
                                fontSize: 12,
                              ),
                              
                            ),


                          ],
                        ),
                      ),
        /*            Row(
                        children: [
                          Image(
                              height: 16 ,
                              width: 18,
                              image: AssetImage('assets/icons/errorIcon.png')
                          ),
                          Container(
                            margin: EdgeInsets.only(left: space_1),
                            child: Text(
                               AppLocalizations.of(context)!.verificationFailed,
                              style: TextStyle(
                                  fontWeight: mediumBoldWeight,
                                  fontSize: size_8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: space_3),
                          child: NewRowTemplate(label: AppLocalizations.of(context)!.vehicleNumber, value: widget.truckData.truckNo)
                      ),
                      Container(
                        child: Text(
                          AppLocalizations.of(context)!.truckDetailsArePending,
                          style: TextStyle(
                              fontWeight: mediumBoldWeight,
                              color: Colors.red
                          ),
                        ),
                      ),
      
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: space_5),
                          height: 32,
                          width: 201,
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(darkBlueColor),
                            ),
                            onPressed: () {
                              providerData.updateIsAddTruckSrcDropDown(true);
                              Get.to( () => TruckDescriptionScreen(truckId : widget.truckData.truckId! , truckNumber: widget.truckData.truckNo! ,)
                              );
                              providerData.resetTruckFilters();
                            },
                            child: Container(
                              child: Text(
                                AppLocalizations.of(context)!.uploadTruckDetails,
                                style: TextStyle(
                                  letterSpacing: 0.7,
                                  fontWeight: normalWeight,
                                  color: white,
                                  fontSize: size_7,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
      
      
                */  ],
                ),
                    ),
      
                driver
                ?
                Container(
                  padding: EdgeInsets.fromLTRB(23,0,7,0),
                  child: Row(
                    children: [
                      Image.asset('assets/icons/11 1.png',
                      width: 22,
                      height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,10,0,10),
                        child: Text(
                          widget.truckData.driverName!,
                          style: TextStyle(
                            fontSize: 12,
                            color: black,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CallButton(directCall: false,driverName: widget.truckData.driverName,driverPhoneNum: widget.truckData.driverNum,),
                      )
              
                    ],),
                )
                :
                Container(
                  padding: EdgeInsets.fromLTRB(23,0,0,0),
                  child: Row(
                    children: [
                      Image.asset('assets/icons/images 1.png',
                      width: 24,
                      height: 22,
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,10,0,10),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
              context: context,
              builder: (context) => AddDriverAlertDialog(notifyParent: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyDrivers()));
              },));
                        },
                        child: Container(
                          
                          child: Text('addDriver'.tr,
                            // 'Add Driver',
                          style: TextStyle(
                                fontSize: 12,
                                color: black,
                              ),),
                        ),
                      )
                      
                    ),
                  ],),
                  
                ),
              ],
            
            ),
          ),
        ),
      ),
    );
  }
  initfunction() async {
    var gpsRoute1 = await getRouteStatusList(widget.truckData.deviceId,from, to);
    setState(() {
      gpsRoute = gpsRoute1;
      totalDistance =  getTotalDistance(gpsRoute);
    });
    
  }
}