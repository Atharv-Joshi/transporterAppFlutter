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
                                  // truckId: .truckId,
                                  // truckApproved:
                                  //     truckDataList[index].truckApproved,
                                  // truckNo: truckDataList[index].truckNo,
                                  // truckType: truckDataList[index].truckType,
                                  // tyres: truckDataList[index].tyresString,
                                  // driverName: truckDataList[index].driverName,
                                  // phoneNum: truckDataList[index].driverNum,
                                  // imei: truckDataList[index].imei,
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
    var logger = Logger();
    logger.i("in truck address function");
    var truckDataList = await truckApiCalls.getTruckData();

    for (var truckData in truckDataList) {
      print("IMEI is ${truckData.imei}");
      if (truckData.imei!= null) {
        var gpsData =
        await mapUtil.getLocationByImei(imei: truckData.imei);
        gpsDataList.add(gpsData);
        getStoppedSince(gpsData);
        print("$gpsData");
        placemarks =
            await placemarkFromCoordinates(gpsData.last.lat, gpsData.last.lng);
        var first = placemarks.first;
        print(
            "${first.subLocality},${first.locality},${first.administrativeArea}\n${first.postalCode},${first.country}");
        if(first.subLocality == "")
          truckAddress = "${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
        else if(first.locality == "")
          truckAddress = "${first.subLocality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
        else if(first.administrativeArea == "")
          truckAddress = "${first.subLocality}, ${first.locality}, ${first.postalCode}, ${first.country}";
        else
          truckAddress = "${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
        print("truck add is $truckAddress");
        truckAddressList.add(truckAddress);
      } else {
        gpsDataList.add([]);
        truckAddressList.add("--");
        status.add("--");
      }
    }
    print("ALL $status");
    print("ALL $truckAddressList");
    print("ALL $gpsDataList");
    print("type ${gpsDataList.runtimeType}");
    setState(() {
      loading = false;
    });
  }

  getStoppedSince(var gpsData) async {
    var logger = Logger();
    logger.i("in stopped since function");
      var time = gpsData.last.gpsTime;
      var timestamp1 = time.toString();

      DateTime truckTime =
          new DateFormat("dd-MM-yyyy hh:mm:ss").parse(timestamp1);
      DateTime now = DateTime.now();
      Duration constraint = Duration(hours: 0, minutes: 0, seconds: 15);

      print("One is $truckTime");
      print("two is $now");

      var diff = now.difference(truckTime).toString();
      var diff2 = now.difference(truckTime);
      print("diff is $diff");
      double speed = double.parse(gpsData.last.speed);
      var v = diff.toString().split(":");
      if (speed<=2 && diff2.compareTo(constraint)>0) {
        if(v[0]=="0")
          status.add("Stopped since ${v[1]} min");
        else
          status.add("Stopped since ${v[0]} hrs : ${v[1]} min");
      } else {
       print("Running : ${gpsData.last.speed} km/h");
        status.add("Running : ${gpsData.last.speed} km/h");
      }
  }


} //class
