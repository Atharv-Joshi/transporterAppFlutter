import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/reviewTruckDetailsScreen.dart';
import 'package:liveasy/widgets/addTruckCircularButtonTemplate.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/addTruckRectangularButtontemplate.dart';
import 'package:liveasy/widgets/buttons/applyButton.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';

class TruckDescriptionScreen extends StatefulWidget {
  String truckId;

  TruckDescriptionScreen(this.truckId);

  @override
  _TruckDescriptionScreenState createState() => _TruckDescriptionScreenState();
}

class _TruckDescriptionScreenState extends State<TruckDescriptionScreen> {

  List truckTypeTextList = ['Open Half Body', 'Flatbed', 'Open Full Body',
    'Full Body Trailer', 'Half Body Trailer', 'Standard Container',
    'High-Cube Container'];

  List truckTypeValueList = ['OPEN_HALF_BODY' , 'FLATBED' , 'OPEN_FULL_BODY' , 'FULL_BODY_TRAILER' , 'HALF_BODY_TRAILER' , 'STANDARD_CONTAINER' , 'HIGH_CUBE_CONTAINER'];

  Map<String, List<int>> passingWeightList = {
    'OPEN_HALF_BODY': [6, 8, 12],
    'FLATBED': [12, 16, 30],
    'OPEN_FULL_BODY': [26, 28, 6, 24, 8],
    'FULL_BODY_TRAILER': [8, 12],
    'HALF_BODY_TRAILER': [16, 8, 28],
    'STANDARD_CONTAINER': [28, 30, 8, 16],
    'HIGH_CUBE_CONTAINER': [6, 8, 12, 26, 28],

  };

  Map<String, List<int>> totalTyresList = {
    'OPEN_HALF_BODY': [26, 28, 12],
    'FLATBED': [6, 30, 10],
    'OPEN_FULL_BODY': [10, 24, 16],
    'FULL_BODY_TRAILER': [18],
    'HALF_BODY_TRAILER': [16, 8, 6, 28, 30],
    'STANDARD_CONTAINER': [8, 10],
    'HIGH_CUBE_CONTAINER': [28, 30, 8, 16],

  };

  Map<String, List<int>> truckLengthList = {
    'OPEN_HALF_BODY': [40, 10],
    'FLATBED': [10, 20, 50],
    'OPEN_FULL_BODY': [60],
    'FULL_BODY_TRAILER': [20, 40],
    'HALF_BODY_TRAILER': [20, 40, 50],
    'STANDARD_CONTAINER': [10, 60],
    'HIGH_CUBE_CONTAINER': [40, 50, 60],
  };

  dynamic dropDownValue;



  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              color: backgroundColor,
              padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AddTrucksHeader(resetFunction: (){
                    providerData.updateTruckTypeValue('');
                    providerData.resetTruckFilters();
                  }),
                  AddTruckSubtitleText(text: 'Truck Type'),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 4,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 10,
                    padding: EdgeInsets.all(10.0),
                    crossAxisCount: 2,
                    children: truckTypeValueList.map((e) =>
                        AddTruckRectangularButtonTemplate(value: e, text: truckTypeTextList[truckTypeValueList.indexOf(e)]))
                        .toList(),
                  ),

                  providerData.truckTypeValue == ''
                      ? SizedBox()
                      : Container(
                      margin: EdgeInsets.symmetric(vertical: space_2),
                      child: AddTruckSubtitleText(
                          text: 'Passing Weight (in tons.)')
                  ),

                  providerData.truckTypeValue == ''
                      ? SizedBox()
                      : GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: space_5,
                    mainAxisSpacing: space_2,
                    crossAxisCount: 6,
                    children: passingWeightList[providerData.truckTypeValue]!
                        .map((e) =>
                        AddTruckCircularButtonTemplate(
                          value: e, text: e, category: 'weight',)).toList(),
                  ),

                  providerData.truckTypeValue == ''
                      ? SizedBox()
                      : Container(
                      margin: EdgeInsets.symmetric(vertical: space_2),
                      child: AddTruckSubtitleText(
                          text: 'Total Tyres (front & rear)')
                  ),

                  providerData.truckTypeValue == ''
                      ? SizedBox()
                      : GridView.count(
                      shrinkWrap: true,
                      crossAxisSpacing: space_5,
                      mainAxisSpacing: space_2,
                      crossAxisCount: 6,
                      children: totalTyresList[providerData.truckTypeValue]!
                          .map((e) =>
                          AddTruckCircularButtonTemplate(
                            value: e, text: e, category: 'tyres',)).toList()

                  ),

                  providerData.truckTypeValue == ''
                      ? SizedBox()
                      : Container(
                      margin: EdgeInsets.symmetric(vertical: space_2),
                      child: AddTruckSubtitleText(text: 'Truck Length (in ft)')
                  ),

                  providerData.truckTypeValue == ''
                      ? SizedBox()
                      : GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: space_5,
                    mainAxisSpacing: space_2,
                    crossAxisCount: 6,
                    children: truckLengthList[providerData.truckTypeValue]!
                        .map((e) =>
                        AddTruckCircularButtonTemplate(
                          value: e, text: e, category: 'length',)).toList(),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: space_2),
                    child: AddTruckSubtitleText(text: 'Select A Driver'),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: space_1),
                      width: 279,
                      padding: EdgeInsets.all(space_2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                            top: BorderSide(width: 1, color: grey),
                            right: BorderSide(width: 1, color: grey),
                            left: BorderSide(width: 1, color: grey),
                            bottom: BorderSide(width: 1, color: grey)
                        ),
                      ),

                      child: DropdownButton<String>(
                        underline: SizedBox(),
                        isDense: true,
                        isExpanded: true,
                        focusColor: Colors.blue,
                        hint: Text('Driver-Number'),
                        value: dropDownValue,
                        icon: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: darkBlueColor,
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              color: white,)),
                        onChanged: (String? newValue) {
                          providerData.updateDriverDetailsValue(newValue);
                          setState(() {
                            dropDownValue = newValue!;
                          });
                        },
                        items: <String>['Ramesh-6666666', 'Suresh-789456'].map<
                            DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                              value: e,
                              child: Row(
                                  children: [
                                    Text('$e'),
                                    Icon(Icons.add),
                                  ])
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: space_2),
                      child: ApplyButton(
                        onPressedFunction: () {
                          Get.to(() => ReviewTruckDetails(widget.truckId));
                        },
                        text: 'Save',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )

    );
  }
}
