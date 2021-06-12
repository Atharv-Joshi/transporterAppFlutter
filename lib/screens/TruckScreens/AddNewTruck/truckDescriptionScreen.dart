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
  const TruckDescriptionScreen({Key? key}) : super(key: key);

  @override
  _TruckDescriptionScreenState createState() => _TruckDescriptionScreenState();
}

class _TruckDescriptionScreenState extends State<TruckDescriptionScreen> {

  List truckTypeList = ['Open Half Body', 'Flatbed', 'Open Full Body',
    'Full Body Trailer', 'Half Body Trailer', 'Standard Container',
    'High-Cube Container', 'Tanker'];

  Map<String, List<int>> passingWeightList = {
    'Open Half Body': [6, 8, 12],
    'Flatbed': [12, 16, 30],
    'Open Full Body': [26, 28, 6, 24, 8],
    'Full Body Trailer': [8, 12],
    'Half Body Trailer': [16, 8, 28],
    'Standard Container': [28, 30, 8, 16],
    'High-Cube Container': [6, 8, 12, 26, 28],
    'Tanker': [6, 8, 12, 16, 18, 24, 26, 28, 30],
  };

  Map<String, List<int>> totalTyresList = {
    'Open Half Body': [26, 28, 12],
    'Flatbed': [6, 30, 10],
    'Open Full Body': [10, 24, 16],
    'Full Body Trailer': [18],
    'Half Body Trailer': [16, 8, 6, 28, 30],
    'Standard Container': [8, 10],
    'High-Cube Container': [28, 30, 8, 16],
    'Tanker': [6, 8, 12],
  };

  Map<String, List<int>> truckLengthList = {
    'Open Half Body': [40, 10],
    'Flatbed': [10, 20, 50],
    'Open Full Body': [60],
    'Full Body Trailer': [20, 40],
    'Half Body Trailer': [20, 40, 50],
    'Standard Container': [10, 60],
    'High-Cube Container': [40, 50, 60],
    'Tanker': [10, 20, 40, 50, 60]
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
                    children: truckTypeList.map((e) =>
                        AddTruckRectangularButtonTemplate(value: e, text: e))
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
                              child: Text('$e')
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
                          Get.to(() => ReviewTruckDetails());
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
