import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';

class MyTrucksResult extends StatefulWidget {
  List gpsDataList;
  List deviceList;
  List status;
  List items;

  MyTrucksResult(
      {required this.gpsDataList,
      required this.deviceList,
      required this.status,
      required this.items});

  @override
  _MyTrucksResultState createState() => _MyTrucksResultState();
}

class _MyTrucksResultState extends State<MyTrucksResult> {
  ScrollController scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  var dummySearchList = [];
  var gpsDataList = [];
  // var truckDataList = [];
  var deviceList = [];
  var status = [];
  var items = [];

  @override
  void initState() {
    dummySearchList = widget.items;
    items = widget.items;
    gpsDataList = widget.gpsDataList;
    status = widget.status;
    deviceList = widget.deviceList;
    print("CHECK Init${status}");
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
                              truckno: items[index].truckno,
                              status: status[index],
                              gpsData: gpsDataList[index],
                              device: items[index],
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
    print("LIST IS $deviceList");
    print("$query");

    if (query.isNotEmpty) {
      //print("DUMMYSEARCH${dummySearchList}");
      var dummyListData = [];
      var dummyGpsData = [];
      var dummyStatusData = [];
      for (var i = 0; i < dummySearchList.length; i++) {
        print("FOREACH ${dummySearchList[i].truckno}");
        if ((dummySearchList[i].truckno.replaceAll(' ', '')).contains(query) ||
            (dummySearchList[i].truckno).contains(query)) {
          print("INSIDE IF");
          print("THE SEARCHHH IS ${dummySearchList[i].truckno}");
          dummyListData.add(dummySearchList[i]);
          dummyGpsData.add(widget.gpsDataList[i]);
          dummyStatusData.add(widget.status[i]);
          //print("DATATYPE${dummyListData.runtimeType}");
        }
      }
      setState(() {
        items = [];
        gpsDataList = [];

        status = [];
        items.addAll(dummyListData);
        gpsDataList.addAll(dummyGpsData);
        status.addAll(dummyStatusData);
        //print("THE DUMY $dummyListData");
      });
      return;
    } else {
      print("QUERY EMPTY?");
      setState(() {
        items = [];
        gpsDataList = [];
        status = [];
        items.addAll(widget.deviceList);
        gpsDataList.addAll(widget.gpsDataList);
        status.addAll(widget.status);
        //print("THE ITEMSS ${items}");
      });
    }
  }
}
