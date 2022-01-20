import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/functions/truckApis/getTruckDataWithPageNo.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/mapAllTrucks.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/addTruckButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingWidgets.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:liveasy/widgets/truckScreenBarButton.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MyTrucks extends StatefulWidget {
  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {
  //TransporterId controller
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  TruckApiCalls truckApiCalls = TruckApiCalls();

  // Truck Model List used to  create cards
  var truckDataList = [];
  var truckAddressList = [];
  var status = [];
  var gpsDataList= [];
  var gpsStoppageHistory= [];
  MapUtil mapUtil = MapUtil();
  late List<Placemark> placemarks;
  String? truckAddress;
  late String date;

  var gpsData;
  bool loading = false;
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  var runningList = [];
  var runningAddressList = [];
  var runningStatus = [];
  var runningGpsData = [];
  int i = 0;
  var StoppedList = [];
  var StoppedAddressList = [];
  var StoppedStatus = [];
  var StoppedGpsData = [];
  var truckDataListForPage = [];
  @override
  void initState() {
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    super.initState();
    
    
    setState(() {
      loading = true;
    });

 //   getTruckData(i);
    getTruckAddress(i);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getTruckAddress(i);
      }
    });
    
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ProviderData providerData = Provider.of<ProviderData>(context);
    // providerData.resetTruckFilters();
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
        PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            space_4,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  /*  SizedBox(
                      width: space_3,
                    ),*/
                    HeadingTextWidget(AppLocalizations.of(context)!.my_truck),
                    // HelpButtonWidget(),
                  ],
                ),
                HelpButtonWidget(),
              ],
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: space_3),
                child: SearchLoadWidget(
                  hintText: AppLocalizations.of(context)!.search,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => NextUpdateAlertDialog());
                  },
                )),

            //LIST OF TRUCK CARDS---------------------------------------------
            Container(
          //    height: 26,
          //    width: 200,
                  padding: EdgeInsets.fromLTRB(10,2,10,2),
             
              //    margin: EdgeInsets.symmetric(horizontal: space_2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFEFEFEF),
                      blurRadius: 9,
                      offset: Offset(0, 2),),
                    ],
                    
            ),
            
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
               
                  TruckScreenBarButton(
                    text: 'All', value: 0, pageController: pageController),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 1,
                    height: 15,
                    color: const Color(0xFFC2C2C2),
                  ),
                  TruckScreenBarButton(
                    text: 'Running', value: 1, pageController: pageController),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 1,
                    height: 15,
                    color: const Color(0xFFC2C2C2),
                  ),
                  TruckScreenBarButton(
                    text: 'Stopped', value: 2, pageController: pageController),
                ],
              ),

            ),
            SizedBox(
              height: 9,
            ),
            GestureDetector (
              onTap: (){
                Get.to(MapAllTrucks(gpsDataList: gpsDataList, truckDataList: truckDataList,runningDataList: runningList,runningGpsDataList: runningGpsData,stoppedList: StoppedList,stoppedGpsList: StoppedGpsData,));
              },
              child: Container(
                
           //     margin: EdgeInsets.fromLTRB(space_2, 0, space_2, 0),
                padding: EdgeInsets.fromLTRB(space_5, space_2, space_2, space_2),
                decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    boxShadow: [
                      
                      BoxShadow(color: const Color(0xFFEFEFEF),
                      blurRadius: 9,
                      offset: Offset(0, 2),),
                    ],
                ),
                child:Row(
                  children: [
                    Image.asset('assets/icons/Vector (1).png',
                          width: 17,
                          height: 16,
                          ),
                          SizedBox(
                            width:18,
                          ),
                    Text(
                      'See All Trucks on Map',
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Image.asset('assets/icons/Vector (2).png',
                          width: 7,
                          height: 15,
                          ),
                          SizedBox(
                            width: 10,
                          )
                  ],
                )
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                //    margin: EdgeInsets.fromLTRB(space_2, 0, space_2, 0),
                  height: MediaQuery.of(context).size.height -kBottomNavigationBarHeight-230-space_4,
                  child: PageView(
                    controller: pageController,
                            onPageChanged: (value) {
                              setState(() {
                                providerData.updateUpperNavigatorIndex(value);
                              });
                            },
                    children: [
                  
                      Stack(
                        alignment: Alignment.bottomCenter,
                        
                        children: [
                          loading
                              ? TruckLoadingWidgets()
                              : truckDataList.isEmpty
                                  ? Container(
                                      // height: MediaQuery.of(context).size.height * 0.27,
                                      margin: EdgeInsets.only(top: 153),
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/TruckListEmptyImage.png'),
                                            height: 127,
                                            width: 127,
                                          ),
                                          Text(
                                            'Looks like you have not added any Trucks!',
                                            style: TextStyle(
                                                fontSize: size_8, color: grey),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : RefreshIndicator(
                                    color: lightNavyBlue,
                                    onRefresh: () {
                                      setState(() {
                                        runningList.clear();
                                        runningAddressList.clear();
                                        runningGpsData.clear();
                                        runningStatus.clear();
                                        truckDataList.clear();
                                        truckAddressList.clear();
                                        gpsDataList.clear();
                                        status.clear();
                                        StoppedStatus.clear();
                                        StoppedAddressList.clear();
                                        StoppedGpsData.clear();
                                        StoppedList.clear();
                                        loading = true;
                                      });
                                      return getTruckAddress(0);
                                    },
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        controller: scrollController,
                                        scrollDirection: Axis.vertical,
                                        padding: EdgeInsets.only(bottom: space_15),
                                        
                                        itemCount: truckDataList.length,
                                        itemBuilder: (context, index)=> index == truckDataList.length? 
                                            bottomProgressBarIndicatorWidget():
                                             MyTruckCard(
                                            truckData: truckDataList[index],
                                            truckAddress: truckAddressList[index],
                                            status: status[index],
                                            gpsData: gpsDataList[index],
                                            // truckId: .truckId,
                                            // truckApproved:
                                            //     truckDataList[index].truckApproved,
                                            // truckNo: truckDataList[index].truckNo,
                                            // truckType: truckDataList[index].truckType,
                                            // tyres: truckDataList[index].tyresString,
                                            // driverName: truckDataList[index].driverName,
                                            // phoneNum: truckDataList[index].driverNum,
                                            // imei: truckDataList[index].imei,
                                          )
                                        ),
                                  ),
                            ],
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        
                        children: [
                          loading
                              ? TruckLoadingWidgets()
                              : runningList.isEmpty
                                  ? Container(
                                      // height: MediaQuery.of(context).size.height * 0.27,
                                      margin: EdgeInsets.only(top: 153),
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/TruckListEmptyImage.png'),
                                            height: 127,
                                            width: 127,
                                          ),
                                          Text(
                                            'Looks like none of your trucks are running!',
                                            style: TextStyle(
                                                fontSize: size_8, color: grey),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : 
                                  
                                  RefreshIndicator(
                                    color: lightNavyBlue,
                                    onRefresh: () {
                                      setState(() {
                                        runningList.clear();
                                        runningAddressList.clear();
                                        runningGpsData.clear();
                                        runningStatus.clear();
                                        truckDataList.clear();
                                        truckAddressList.clear();
                                        gpsDataList.clear();
                                        status.clear();
                                        StoppedStatus.clear();
                                        StoppedAddressList.clear();
                                        StoppedGpsData.clear();
                                        StoppedList.clear();
                                        loading = true;
                                      });
                                      return getTruckAddress(0);
                                    },
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(bottom: space_15),
                                        physics: BouncingScrollPhysics(),
                                        controller: scrollController,
                                        scrollDirection: Axis.vertical,
                                        itemCount: runningList.length,
                                        itemBuilder: (context, index) => index == runningList.length
                  ? bottomProgressBarIndicatorWidget() : 
                                           MyTruckCard(
                                            truckData: runningList[index],
                                            truckAddress: runningAddressList[index],
                                            status: runningStatus[index],
                                            gpsData: runningGpsData[index],
                                            // truckId: .truckId,
                                            // truckApproved:
                                            //     truckDataList[index].truckApproved,
                                            // truckNo: truckDataList[index].truckNo,
                                            // truckType: truckDataList[index].truckType,
                                            // tyres: truckDataList[index].tyresString,
                                            // driverName: truckDataList[index].driverName,
                                            // phoneNum: truckDataList[index].driverNum,
                                            // imei: truckDataList[index].imei,
                                          ),
                                        ),
                                  ),
                            ],
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        
                        children: [
                          loading
                              ? TruckLoadingWidgets()
                              : StoppedList.isEmpty
                                  ? Container(
                                      // height: MediaQuery.of(context).size.height * 0.27,
                                      margin: EdgeInsets.only(top: 153),
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/TruckListEmptyImage.png'),
                                            height: 127,
                                            width: 127,
                                          ),
                                          Text(
                                            'Looks like none of your trucks are stopped!',
                                            style: TextStyle(
                                                fontSize: size_8, color: grey),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : RefreshIndicator(
                                    color: lightNavyBlue,
                                    onRefresh: () {
                                      setState(() {
                                        runningList.clear();
                                        runningAddressList.clear();
                                        runningGpsData.clear();
                                        runningStatus.clear();
                                        truckDataList.clear();
                                        truckAddressList.clear();
                                        gpsDataList.clear();
                                        status.clear();
                                        StoppedStatus.clear();
                                        StoppedAddressList.clear();
                                        StoppedGpsData.clear();
                                        StoppedList.clear();
                                        loading = true;
                                      });
                                      return getTruckAddress(0);
                                    },
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(bottom: space_15),
                                        physics: BouncingScrollPhysics(),
                                        controller: scrollController,
                                        scrollDirection: Axis.vertical,
                                        itemCount: StoppedList.length ,
                                        itemBuilder: (context, index) => index == StoppedList.length
                  ? bottomProgressBarIndicatorWidget():
                                           MyTruckCard(
                                            truckData: StoppedList[index],
                                            truckAddress: StoppedAddressList[index],
                                            status: StoppedStatus[index],
                                            gpsData: StoppedGpsData[index],
                                            // truckId: .truckId,
                                            // truckApproved:
                                            //     truckDataList[index].truckApproved,
                                            // truckNo: truckDataList[index].truckNo,
                                            // truckType: truckDataList[index].truckType,
                                            // tyres: truckDataList[index].tyresString,
                                            // driverName: truckDataList[index].driverName,
                                            // phoneNum: truckDataList[index].driverNum,
                                            // imei: truckDataList[index].imei,
                                          ),
                                        ),
                                  ),
                            ],
                      ),
                    
                    ]
                  ),
                ),
                  Positioned(
                    top: MediaQuery.of(context).size.height -kBottomNavigationBarHeight-230-2*space_4-30,
                    left: (MediaQuery.of(context).size.width- 2*space_6)/2-60,
                    child: Container(
                   //     margin: EdgeInsets.only(bottom: space_2),
                        child: AddTruckButton()),
                  ),
                ]
              ),
            ),

            //--------------------------------------------------------------
       /*   Padding(
                        padding: EdgeInsets.only(bottom: space_2),
                        child: Container(
                            margin: EdgeInsets.only(bottom: space_2),
                            child: AddTruckButton()),
                      ),*/
          ],
        ),
      )),
    );
   } //build


  getTruckAddress(int i) async {
    var truckDataListForPagevar = await getTruckDataWithPageNo(i);

    setState(() {
      truckDataListForPage = truckDataListForPagevar;
    });
    for (var truckData in truckDataListForPage) {
      print("hello DeviceId is ${truckData.deviceId}");

      setState(() {
        truckDataList.add(truckData);                               //Add data for ALL trucks
      });

      if (truckData.deviceId != 0 ) {
        //Call Traccar position API to get current details of truck

        gpsData = await mapUtil.getTraccarPosition(deviceId : truckData.deviceId);
        getStoppedSince(gpsData);

        if(truckData.truckApproved == true && gpsData.last.speed >= 2)          //For RUNNING Section
        {
          setState(() {
            runningList.add(truckData);
            runningAddressList.add("${gpsData.last.address}");
            runningGpsData.add(gpsData);
          });

        }
        else if (truckData.truckApproved == true && gpsData.last.speed < 2){     //For STOPPED section
       setState(() {
          StoppedList.add(truckData);
          StoppedAddressList.add("${gpsData.last.address}");
          StoppedGpsData.add(gpsData);
       });

        }
        setState(() {
          gpsDataList.add(gpsData);
          truckAddressList.add("${gpsData.last.address}");
        });

      } else {

        gpsDataList.add([]);
        truckAddressList.add("--");
        status.add("--");
      }
    }
    print("ALL $status");
    print("ALL $truckAddressList");
    print("ALL $gpsDataList");
    print("--TRUCK SCREEN DONE--");
    setState(() {
      loading = false;
    });
  }
  refreshData(int i) async{
     {
 //   truckDataListForPage = await getTruckDataWithPageNo(i);
    
    for (var truckData in truckDataListForPage) {
      print("hello DeviceId is ${truckData.deviceId}");
    /*  setState(() {
        truckDataList.add(truckData);
      });*/
      if (truckData.deviceId != 0 ) {
        //Call Traccar position API to get current details of truck
        var vgpsData = await mapUtil.getTraccarPosition(deviceId : truckData.deviceId);
        
        setState(() {
          gpsData = vgpsData;
        });
        getStoppedSince(gpsData);
        if(truckData.truckApproved == true && gpsData.last.speed >= 2)
        {
       //   print("more");
          setState(() {
       //     runningList.add(truckData);
          runningAddressList.add("${gpsData.last.address}");
          
          runningGpsData.add(gpsData);
          });
          
        }
        else if (truckData.truckApproved == true && gpsData.last.speed < 2){
       //   print("kess");
       setState(() {
     //    StoppedList.add(truckData);
          StoppedAddressList.add("${gpsData.last.address}");
          
          StoppedGpsData.add(gpsData);
       });
          
        }
        setState(() {
          gpsDataList.add(gpsData);
          truckAddressList.add("${gpsData.last.address}");
        });
        
      } else {

        gpsDataList.add([]);
        truckAddressList.add("--");
        status.add("--");
      }
    }
    print("ALL $status");
    print("ALL $truckAddressList");
    print("ALL $gpsDataList");
    print("--TRUCK SCREEN DONE--");
    setState(() {
      loading = false;
    });
  }
  
  }
  getStoppedSince(var gpsData) async {
    if( gpsData.last.motion == false)
    {
      StoppedStatus.add("Stopped");
      status.add("Stopped");
    }
    else
    {
      runningStatus.add("Running");
      status.add("Running");
    }
    print("STATUS : $status");
  }
  
}

//class
