import 'package:async/async.dart';
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
import 'package:liveasy/models/truckModel.dart';
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

class MyTrucksResult extends StatefulWidget {
  List gpsDataList;
  List truckDataList;
  List truckAddressList;
  List status;
  List items;
  // List stoppedGpsList;
  MyTrucksResult(
      {required this.gpsDataList,
      required this.truckDataList,
      required this.truckAddressList,
      required this.status,
      required this.items
      // required this.stoppedGpsList,
      // required this.stoppedList,
      });
  @override
  _MyTrucksResultState createState() => _MyTrucksResultState();
}

class _MyTrucksResultState extends State<MyTrucksResult> {
  ScrollController scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  var dummySearchList = [];
  var gpsDataList = [];
  var truckDataList = [];
  var truckAddressList = [];
  var status = [];
  var items = [];
  @override
  void initState() {
    dummySearchList = widget.items;
    items = widget.items;
    gpsDataList = widget.gpsDataList;
    truckAddressList = widget.truckAddressList;
    status = widget.status;
    truckDataList = widget.truckDataList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            //color: darkBlueColor,
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
                        HeadingTextWidget('searchTrucks'.tr
                            // AppLocalizations.of(context)!.my_truck
                            ),
                      ],
                    ),
                    HelpButtonWidget(),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: space_3),
                  child: Container(
                    height: space_8,
                    decoration: BoxDecoration(
                      color: widgetBackGroundColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 0.8,
                        // color: borderBlueColor,
                      ),
                    ),
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (value) {
                        filterSearchResults(value);
                        print("EnteRRR");
                        print(gpsDataList);
                        print(status);
                        print(truckAddressList);
                        //print("THE ITEMS $items");
                      },
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      controller: editingController,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'search'.tr,
                        icon: Padding(
                          padding: EdgeInsets.only(left: space_2),
                          child: Icon(
                            Icons.search,
                            color: grey,
                          ),
                        ),
                        hintStyle: TextStyle(
                          fontSize: size_8,
                          color: grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(bottom: space_15),
                      itemCount: items.length,
                      itemBuilder: (context, index) => index == items.length
                          ? bottomProgressBarIndicatorWidget()
                          : MyTruckCard(
                              truckData: items[index],
                              truckAddress: truckAddressList[index],
                              status: status[index],
                              gpsData: gpsDataList[index],
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    print("LIST IS $truckDataList");
    print("$query");

    if (query.isNotEmpty) {
      //print("DUMMYSEARCH${dummySearchList}");
      var dummyListData = [];
      var dummyAddressData = [];
      var dummyGpsData = [];
      var dummyStatusData = [];
      for (var i = 0; i < dummySearchList.length; i++) {
        //print("FOREACH");
        if ((dummySearchList[i].truckNo.replaceAll(' ', '')).contains(query) ||
            (dummySearchList[i].truckNo).contains(query)) {
          print("INSIDE IF");
          dummyListData.add(dummySearchList[i]);
          dummyGpsData.add(widget.gpsDataList[i]);
          dummyAddressData.add(widget.truckAddressList[i]);
          dummyStatusData.add(widget.status[i]);
          //print("DATATYPE${dummyListData.runtimeType}");
        }
      }
      setState(() {
        items = [];
        gpsDataList = [];
        truckAddressList = [];
        status = [];
        items.addAll(dummyListData);
        gpsDataList.addAll(dummyGpsData);
        truckAddressList.addAll(dummyAddressData);
        status.addAll(dummyStatusData);
        //print("THE DUMY $dummyListData");
      });
      return;
    } else {
      print("QUERY EMPTY?");
      setState(() {
        items = [];
        gpsDataList = [];
        truckAddressList = [];
        status = [];
        items.addAll(widget.truckDataList);
        gpsDataList.addAll(widget.gpsDataList);
        truckAddressList.addAll(widget.truckAddressList);
        status.addAll(widget.status);
        //print("THE ITEMSS ${items}");
      });
    }
  }
}
