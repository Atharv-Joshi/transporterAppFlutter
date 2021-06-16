import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/reviewTruckDetailsScreen.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:liveasy/widgets/addTruckCircularButtonTemplate.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/addTruckRectangularButtontemplate.dart';
import 'package:liveasy/widgets/buttons/mediumSizedButton.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';

class TruckDescriptionScreen extends StatefulWidget {
  String truckId;

  TruckDescriptionScreen(this.truckId);

  @override
  _TruckDescriptionScreenState createState() => _TruckDescriptionScreenState();
}

class _TruckDescriptionScreenState extends State<TruckDescriptionScreen> {

  dynamic dropDownValue;

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  DriverApiCalls driverApiCalls = DriverApiCalls();

  late List driverList = [];

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getDriverList();
  }

  void getDriverList() async {

    List temp ;
    temp = await driverApiCalls.getDriversByTransporterId();
    setState(() {
      driverList = temp;
    });

  }

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
              padding: EdgeInsets.fromLTRB(space_3, space_4, space_3, space_4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AddTrucksHeader(
                      reset: true,
                      resetFunction: (){
                    providerData.resetTruckFilters();
                    providerData.updateResetActive(false);

                  }),
                  AddTruckSubtitleText(text: 'Truck Type'),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: EdgeInsets.all(10.0),
                    crossAxisCount: 2,
                    children: truckFilterVariables.truckTypeValueList.map((e) =>
                        AddTruckRectangularButtonTemplate(value: e, text: truckFilterVariables.truckTypeTextList[truckFilterVariables.truckTypeValueList.indexOf(e)]))
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
                      : Container(
                        height: 50,
                        child: GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: space_5,
                    mainAxisSpacing: space_2,
                    crossAxisCount: 6,
                    children: truckFilterVariables.passingWeightList[providerData.truckTypeValue]!
                          .map((e) =>
                          AddTruckCircularButtonTemplate(
                            value: e, text: e, category: 'weight',)).toList(),
                  ),
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
                      : Container(
                        height: 50,
                        child: GridView.count(
                        shrinkWrap: true,
                        crossAxisSpacing: space_5,
                        mainAxisSpacing: space_2,
                        crossAxisCount: 6,
                        children: truckFilterVariables.totalTyresList[providerData.truckTypeValue]!
                            .map((e) =>
                            AddTruckCircularButtonTemplate(
                              value: e, text: e, category: 'tyres',)).toList()

                  ),
                      ),

                  providerData.truckTypeValue == ''
                      ? SizedBox()
                      : Container(
                      margin: EdgeInsets.symmetric(vertical: space_2),
                      child: AddTruckSubtitleText(text: 'Truck Length (in ft)')
                  ),

                  providerData.truckTypeValue == ''
                      ? SizedBox()
                      : Container(
                        height: 50,
                        child: GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: space_5,
                    mainAxisSpacing: space_2,
                    crossAxisCount: 6,
                    children: truckFilterVariables.truckLengthList[providerData.truckTypeValue]!
                          .map((e) =>
                          AddTruckCircularButtonTemplate(
                            value: e, text: e, category: 'length',)).toList(),
                  ),
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
                        hint: Text('Driver Name -Number'),
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
                        // items: <String>['Ramesh-6666666', 'Suresh-789456'].map<
                        //     DropdownMenuItem<String>>((e) {
                        //   return DropdownMenuItem<String>(
                        //       value: e,
                        //       child: Row(
                        //           children: [
                        //             Text('$e'),
                        //             Icon(Icons.add),
                        //           ])
                        //   );
                        // }).toList(),

                        items: driverList.map<
                            DropdownMenuItem<String>>((instance) {
                          return DropdownMenuItem<String>(
                              value: instance.driverId ,
                              child: Row(
                                  children: [
                                    Text('${instance.driverName}-${instance.phoneNum}'),
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
                      child: MediumSizedButton(
                        onPressedFunction: () {
                          providerData.updateResetActive(true);
                          Get.to(() => ReviewTruckDetails(widget.truckId , providerData.driverIdValue));
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
