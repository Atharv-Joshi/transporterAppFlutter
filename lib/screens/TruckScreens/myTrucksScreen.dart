//TODO: functionality for track and call button. truckapproved cond for add truck button asnd redirecting to required pages.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

//constants
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/addTruckButton.dart';
import 'package:liveasy/widgets/buttons/addTruckButton.dart';

//widgets
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';

//functions
import 'package:liveasy/functions/truckApiCalls.dart';

class MyTrucks extends StatefulWidget {
  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {
  // truckApiCall instance
  TruckApiCalls truckApiCalls = TruckApiCalls();

  // driverApiCall instance
  DriverApiCalls driverApiCalls = DriverApiCalls();

  //TransporterId controller
  TransporterIdController transporterIdController = TransporterIdController();

  //true if truck list is empty
  bool truckListEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
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
                    onPressed: () {},
                  )),

              //LIST OF TRUCK CARDS---------------------------------------------
              Container(
                height: MediaQuery.of(context).size.height * 0.67,
                child: truckDataList.isEmpty
                    ? Container(
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
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: truckDataList.length,
                        itemBuilder: (context, index) {
                          TruckModel truckModel =
                              TruckModel(truckApproved: false);
                          truckModel.truckId = truckDataList[index].truckId;
                          truckModel.transporterId =
                              truckDataList[index].transporterId;
                          truckModel.truckNo = truckDataList[index].truckNo;
                          truckModel.truckApproved =
                              truckDataList[index].truckApproved;
                          truckModel.imei = truckDataList[index].imei;
                          truckModel.passingWeight =
                              truckDataList[index].passingWeight;
                          truckModel.driverId = truckDataList[index].driverId;
                          truckModel.truckType = truckDataList[index].truckType;
                          truckModel.tyres = truckDataList[index].tyres;

                          return FutureBuilder(
                              future: driverApiCalls.getDriverByDriverId(
                                  truckModel: truckModel),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data == null) {
                                  return LoadingWidget();
                                }
                                return MyTruckCard(
                                  truckApproved: snapshot.data.truckApproved,
                                  truckNo: snapshot.data.truckNo,
                                  truckType: snapshot.data.truckType,
                                  tyres: snapshot.data.tyres,
                                  driverName: snapshot.data.driverName,
                                  phoneNum: snapshot.data.driverNum,
                                  imei: snapshot.data.imei,
                                );
                              } //builder
                              );
                        }),
                //--------------------------------------------------------------
              ),
              Container(child: AddTruckButton()),
            ],
          ),
        ),
      ),
    );
  } //build

  getTruckData(int i) async {
    http.Response response = await http.get(Uri.parse(
        '$truckApiUrl?transporterId=${transporterIdController.transporterId.value}&pageNo=$i'));
    jsonData = json.decode(response.body);
    print(response.body);
    for (var json in jsonData) {
      TruckModel truckModel = TruckModel(truckApproved: false);
      truckModel.truckId = json["truckId"];
      truckModel.transporterId = json["transporterId"];
      truckModel.truckNo = json["truckNo"];
      truckModel.truckApproved = json["truckApproved"];
      truckModel.imei = json["imei"];
      truckModel.passingWeight = json["passingWeight"];
      truckModel.truckType = json["truckType"];
      truckModel.driverId = json["driverId"];
      truckModel.tyres = json["tyres"];
      setState(() {
        truckDataList.add(truckModel);
      });
    }
  } //getTruckData

} //class
