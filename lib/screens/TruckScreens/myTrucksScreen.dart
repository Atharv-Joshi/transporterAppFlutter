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
                child: FutureBuilder(
                  //getTruckData returns list of truck Model
                  future: truckApiCalls.getTruckData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return LoadingWidget();
                    }
                    print('snapshot length :' +
                        '${snapshot.data.length}'); //number of cards

                    if (snapshot.data.length == 0) {
                      return Container(
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
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            TruckModel truckModel =
                                TruckModel(truckApproved: false);

                            truckModel.truckId = snapshot.data[index].truckId;
                            truckModel.transporterId =
                                snapshot.data[index].transporterId;
                            truckModel.truckNo = snapshot.data[index].vehicleNo;
                            truckModel.truckApproved =
                                snapshot.data[index].truckApproved;
                            truckModel.imei = snapshot.data[index].imei;
                            truckModel.passingWeight =
                                snapshot.data[index].passingWeight;
                            truckModel.driverId = snapshot.data[index].driverId;
                            truckModel.truckType =
                                snapshot.data[index].truckType;
                            truckModel.tyres = snapshot.data[index].tyres;

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
                                    truckNo: snapshot.data.vehicleNo,
                                    truckType: snapshot.data.truckType,
                                    tyres: snapshot.data.tyres,
                                    driverName: snapshot.data.driverName,
                                    phoneNum: snapshot.data.driverNum,
                                  );
                                } //builder
                                );
                          });
                    } //else
                  },
                ),
                //--------------------------------------------------------------
              ),
              Container(child: AddTruckButton()),
            ],
          ),
        ),
      ),
    );
  }
}
