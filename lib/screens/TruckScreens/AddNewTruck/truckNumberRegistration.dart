import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckDescriptionScreen.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/uploadRC.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/buttons/applyButton.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';

class AddNewTruck extends StatefulWidget {
  const AddNewTruck({Key? key}) : super(key: key);

  @override
  _AddNewTruckState createState() => _AddNewTruckState();
}

class _AddNewTruckState extends State<AddNewTruck> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  TextEditingController _controller = TextEditingController();
  TruckApiCalls truckApiCalls = TruckApiCalls();

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_4),
            color: backgroundColor,
            child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddTrucksHeader(
                      resetFunction: () {
                        _controller.text = '';
                        providerData.resetTruckNumber();
                      },),
                    AddTruckSubtitleText(text: 'Add Truck Number'),

                    //TODO: center the hintext and apply shadows to textformfield
                    Container(
                      margin: EdgeInsets.symmetric(vertical: space_4),
                      width: 179,
                      height: 38,
                      child: TextFormField(
                        // key: _formKey,
                        controller: _controller,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: whiteBackgroundColor,
                          hintText: 'Eg: UP 22 GK 2222',
                          hintStyle: TextStyle(
                            fontWeight: boldWeight,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: unselectedGrey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: unselectedGrey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //this button should only be active if validator check passes
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ApplyButton(
                            text: 'Apply',
                            onPressedFunction:
                                () {
                              providerData.updateTruckNumberValue(
                                  _controller.text);
                              truckApiCalls.postTruckData(
                                  truckNo: _controller.text);
                              Get.to(() => TruckDescriptionScreen());
                            }
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}
