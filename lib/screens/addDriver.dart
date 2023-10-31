import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/postDriverTraccarApi.dart';
import 'package:liveasy/screens/updateBookingDetails.dart';
import 'package:liveasy/widgets/HeadingTextWidgetBlue.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/elevatedButtonforAddNewDriver.dart';

import '../models/onGoingCardModel.dart';

//You can add Driver using this screen from the documentUploadScreen
class AddDriver extends StatefulWidget {
  String? selectedTruck;
  int? selectedDeviceId;
  OngoingCardModel loadAllDataModel;
  AddDriver(
      {this.selectedTruck,
      this.selectedDeviceId,
      required this.loadAllDataModel});

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  bool btnActive = false;
  String? transporterId;
  String? mobileno;
  TransporterIdController transporterIdController = TransporterIdController();
  GetStorage tidstorage = GetStorage('TransporterIDStorage');

  GlobalKey<FormState> _key = new GlobalKey();
  bool _autovalidate = false;
  String? name, phoneno;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: statusBarColor,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Form(
                    key: _key,
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.symmetric(horizontal: space_2),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BackButtonWidget(),
                              SizedBox(
                                width: space_3,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    HeadingTextWidgetBlue("Add New Driver"),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 15, right: 17),
                                      child: Text(
                                        "Enter Driver Details",
                                        style: TextStyle(
                                          color: Colors.orange[900],
                                          fontSize: size_7,
                                        ),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4.0,
                                height: size_1,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 35),
                                child: Image(
                                  height: 55,
                                  width: 55,
                                  image:
                                      AssetImage("assets/icons/person_ic.png"),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Divider(
                            height: 7,
                            color: black,
                          ),
                          SizedBox(
                            height: space_2 + 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: space_4,
                                    right: space_4,
                                    bottom: space_2),
                                child: Text(
                                  "1.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: size_12),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: space_2),
                                child: Text(
                                  "Driver Name",
                                  style: TextStyle(
                                      fontSize: size_9,
                                      fontWeight: mediumBoldWeight,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: space_10,
                                right: space_7,
                                bottom: space_2),
                            height: space_9 + 2,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(radius_1 + 2),
                                border: Border.all(color: darkGreyColor)),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: space_2 - 2,
                                  right: space_2 - 2,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: white,
                                  ),
                                  child: TextFormField(
                                      validator: (input) {
                                        if (input!.isEmpty) {
                                          return "";
                                        }
                                      },
                                      onChanged: (input) {
                                        validatebtn();
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      onSaved: (input) => name = input!),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: space_2 + 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: space_4,
                                    right: space_3,
                                    bottom: space_2),
                                child: Text(
                                  "2.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: size_12),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: space_2),
                                child: Text(
                                  "Driver Number",
                                  style: TextStyle(
                                      fontSize: size_9,
                                      fontWeight: mediumBoldWeight,
                                      color: black),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: space_10,
                                right: space_7,
                                bottom: space_2),
                            height: space_9 + 2,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(radius_1 + 2),
                                border: Border.all(color: darkGreyColor)),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: space_2 - 2,
                                  right: space_2 - 2,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: white,
                                  ),
                                  child: TextFormField(
                                    validator: (input) {
                                      if (input!.length < 10) {
                                        return "";
                                      }
                                    },
                                    onChanged: (input) {
                                      validatebtn();
                                    },
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(-5),
                                      border: InputBorder.none,
                                    ),
                                    onSaved: (input) => phoneno = input!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButtonWidgetTwo(
                              condition: btnActive,
                              text: "Add".tr,
                              onPressedConditionTrue: () {
                                tidstorage.read("transporterId");

                                _sendToPreviousScreen();
                              }),
                        ]))))));
  }

  void validatebtn() {
    if (_key.currentState!.validate()) {
      setState(() {
        btnActive = true;
      });
    } else {
      setState(() {
        btnActive = false;
      });
    }
  }

  Future<void> _sendToPreviousScreen() async {
    if (_key.currentState!.validate()) {
      // saves to global key.
      _key.currentState!.save();
      String responseStatus;
      responseStatus = await postDriverTraccarApi(name, phoneno, transporterId);
      // send to next screen.
      if (responseStatus == 'successful') {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => UpdateBookingDetails(
              selectedTruck: widget.selectedTruck,
              selectedDeviceId: widget.selectedDeviceId,
              driverName:
                  name, // 1st one will be available on the next screen and the 2nd one is the string that we are passing.
              mobileNo: phoneno,
              loadAllDataModel: widget.loadAllDataModel,
            ),
          ),
        );
      }
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
