import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/addTruckButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

class MyTrucks extends StatefulWidget {

  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {



  // driverApiCall instance
  DriverApiCalls driverApiCalls = DriverApiCalls();

  //TransporterId controller
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  // //true if truck list is empty
  // bool truckListEmpty = false;

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  // retrieving TRUCKAPIURL  from env file
  final String truckApiUrl = FlutterConfig.get('truckApiUrl');

  //json data list
  late List jsonData;

  // Truck Model List used to  create cards
  List truckDataList = [];

  // List<DriverModel> driverModelGlobalList = [];

  int i = 0;

 bool loading = false;
  @override
  void initState() {

    super.initState();

    setState(() {
      loading = true;
    });

    getTruckData(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // LoadingWidget();
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child:Container(
           padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
           height:  MediaQuery.of(context).size.height -  kBottomNavigationBarHeight - space_4,
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
                      HeadingTextWidget("My Trucks"),
                      // HelpButtonWidget(),
                    ],
                  ),
                  HelpButtonWidget(),
                ],
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: space_3),
                  child: SearchLoadWidget(
                    hintText: 'Search',
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
                      ? LoadingWidget()
                      :
                      truckDataList.isEmpty
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
                              style: TextStyle(fontSize: size_8, color: grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                          :
                      ListView.builder(
                          controller: scrollController,
                          itemCount: truckDataList.length,
                          itemBuilder: (context, index)  {
                            return MyTruckCard(
                              truckId : truckDataList[index].truckId,
                              truckApproved: truckDataList[index].truckApproved,
                              truckNo: truckDataList[index].truckNo,
                              truckType: truckDataList[index].truckType,
                              tyres: truckDataList[index].tyresString,
                              driverName:truckDataList[index].driverName,
                              phoneNum: truckDataList[index].driverNum,
                              imei:truckDataList[index].imei,
                            );
                          }
                          ),
                      Container(
                        margin: EdgeInsets.only(bottom: space_2),
                          child: AddTruckButton()
                      ),
                    ],
                  ),
                ),



              //--------------------------------------------------------------
            ],
          ),
        )
      ),

    );
  } //build

  getTruckData(int i) async {
    http.Response response = await http.get(Uri.parse( '$truckApiUrl?transporterId=${transporterIdController.transporterId.value}&pageNo=$i'));
    jsonData = json.decode(response.body);
    for (var json in jsonData) {
      TruckModel truckModel = TruckModel();
      truckModel.truckId = json["truckId"] != null ? json["truckId"] : 'NA' ;
      truckModel.transporterId = json["transporterId"] != null ? json["transporterId"] : 'NA' ;
      truckModel.truckNo = json["truckNo"] != null ? json["truckNo"] : 'NA' ;
      truckModel.truckApproved = json["truckApproved"] != null ? json["truckApproved"] : false ;
      truckModel.imei = json["imei"] != null ? json["imei"] : 'NA' ;
      truckModel.passingWeightString = json["passingWeight"] != null ? json["passingWeight"].toString() : 'NA' ;
      truckModel.truckType = json["truckType"]  != null ? json["truckType"] : 'NA' ;
      truckModel.driverId = json["driverId"] != null ? json["driverId"] : 'NA' ;
      truckModel.tyresString = json["tyres"] != null ? json["tyres"].toString() : 'NA' ;
      truckModel.truckLengthString = json["truckLength"] != null ? json["truckLength"].toString() : 'NA' ;
      //driver data
      DriverModel driverModel = await  driverApiCalls.getDriverByDriverId(driverId: truckModel.driverId);
      truckModel.driverName = driverModel.driverName;
      truckModel.driverNum = driverModel.phoneNum;
      setState(() {
        truckDataList.add(truckModel);
      });
    }//for loop
    setState(() {
      loading = false;
    });
  } //getTruckData

} //class
