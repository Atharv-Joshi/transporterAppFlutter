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
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/addTruckButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingWidgets.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

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

  int i = 0;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getTruckAddress();
    setState(() {
      loading = true;
    });

    getTruckData(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getTruckData(i);
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
                    SizedBox(
                      width: space_3,
                    ),
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
            Expanded(
              child: Stack(
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
                          : ListView.builder(
                              padding: EdgeInsets.only(bottom: space_15),
                              controller: scrollController,
                              itemCount: truckDataList.length,
                              itemBuilder: (context, index) {
                                return MyTruckCard(
                                  truckData: truckDataList[index],
                                  truckAddress: truckAddressList[index],
                                  status: status[index],
                                  gpsData: gpsDataList[index],
                                );
                              }),
                  Padding(
                    padding: EdgeInsets.only(bottom: space_2),
                    child: Container(
                        margin: EdgeInsets.only(bottom: space_2),
                        child: AddTruckButton()),
                  ),
                ],
              ),
            ),

            //--------------------------------------------------------------
          ],
        ),
      )),
    );
  } //build

  getTruckData(int i) async {
    var truckDataListForPagei = await getTruckDataWithPageNo(i);
    for (var truckData in truckDataListForPagei) {
      setState(() {
        truckDataList.add(truckData);
      });
    }
  } //getTruckData

  getTruckAddress() async {
    var truckDataList = await truckApiCalls.getTruckData();
    for (var truckData in truckDataList) {
      print("DeviceId is ${truckData.deviceId}");
      if (truckData.deviceId!= 0) {
        //Call Traccar position API to get current details of truck
        var gpsData = await mapUtil.getTraccarPosition(deviceId : truckData.deviceId);
        gpsDataList.add(gpsData);
        getStoppedSince(gpsData);
        truckAddressList.add("${gpsData.last.address}");
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

  getStoppedSince(var gpsData) async {
    if(gpsData.last.motion == false)
      status.add("Stopped");
    else
      status.add("Running");
    print("STATUS : $status");
  }
} //class
