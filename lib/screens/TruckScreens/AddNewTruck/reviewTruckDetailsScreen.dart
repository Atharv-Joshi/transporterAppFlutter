import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/mediumSizedButton.dart';
import 'package:liveasy/widgets/truckReviewDetailsRow.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/controller/truckIdController.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';

class ReviewTruckDetails extends StatefulWidget {
  final String truckId;

  final String driverId;

  ReviewTruckDetails(this.truckId, this.driverId);

  @override
  _ReviewTruckDetailsState createState() => _ReviewTruckDetailsState();
}

class _ReviewTruckDetailsState extends State<ReviewTruckDetails> {
  TruckApiCalls truckApiCalls = TruckApiCalls();

  DriverApiCalls driverApiCalls = DriverApiCalls();

  TruckIdController truckIdController = TruckIdController();

  String truckTypeText = '';

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  DriverModel driverModel = DriverModel();

  String? truckIdForCrossVerification;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriverDetails();
  }

  void getDriverDetails() async {
    if (widget.driverId != '') {
      var temp =
          await driverApiCalls.getDriverByDriverId(driverId: widget.driverId);
      setState(() {
        driverModel = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    if (providerData.truckTypeValue == '') {
      truckTypeText = '---';
    } else {
      truckTypeText = truckFilterVariables.truckTypeTextList[
          truckFilterVariables.truckTypeValueList
              .indexOf(providerData.truckTypeValue)];
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(space_5),
          child: Column(
            children: [
              Header(
                backButton: true,
                  text: 'Add Truck',
                  reset: false,
                  resetFunction: () {
                    providerData.resetTruckFilters();
                    Get.back();
                  }),
              Container(
                margin: EdgeInsets.only(top: space_2),
                child: Row(
                  children: [
                    Text(
                      'Review Details For ',
                      style: TextStyle(
                          fontSize: size_9, fontWeight: mediumBoldWeight),
                    ),
                    Text(
                      '${providerData.truckNumberValue}',
                      style: TextStyle(
                          fontSize: size_9,
                          color: Color(0xff152968),
                          fontWeight: mediumBoldWeight),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(space_2),
                      child: Column(
                        children: [
                          TruckReviewDetailsRow(
                              value: truckTypeText, label: 'Truck Type'),
                          TruckReviewDetailsRow(
                              value: providerData.totalTyresValue,
                              label: 'Total Tyres'),
                          TruckReviewDetailsRow(
                              value: providerData.passingWeightValue,
                              label: 'Passing Weight'),
                          TruckReviewDetailsRow(
                              value: providerData.truckLengthValue,
                              label: 'Truck Length'),
                          TruckReviewDetailsRow(
                              value: widget.driverId != ''
                                  ? '${driverModel.driverName}-${driverModel.phoneNum}'
                                  : '---',
                              label: 'Driver Details'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      space_2,
                      MediaQuery.of(context).size.height * 0.38,
                      space_2,
                      0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MediumSizedButton(
                            onPressedFunction: () {
                              Get.back();
                            },
                            optional: true,
                            text: 'Edit'),
                        MediumSizedButton(
                            onPressedFunction: () async {
                              print(
                                  'driverId in review page : ${widget.driverId}');
                              truckIdForCrossVerification =
                                  await truckApiCalls.putTruckData(
                                truckType: providerData.truckTypeValue,
                                totalTyres: providerData.totalTyresValue,
                                truckLength: providerData.truckLengthValue,
                                passingWeight: providerData.passingWeightValue,
                                driverID: widget.driverId,
                                truckID: widget.truckId,
                              );

                              if (truckIdForCrossVerification != null) {
                                providerData.updateIndex(1);
                                Get.offAll(() => NavigationScreen());
                                providerData.resetTruckFilters();
                              } else {
                                Get.snackbar('Failed to update Details', '');
                              }
                            },
                            optional: true,
                            text: 'Submit')
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
