import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/buyGPSApiCalls.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/widgets/alertDialog/buyGPSAddTruckDialog.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/alertDialog/sameTruckAlertDialogBox.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingLongWidgets.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/widgets/trucksLongCard.dart';

class MyRadioOption<T> extends StatelessWidget {

  final T value;
  final T duration;
  final T? groupValue;
  final T? groupDurationValue;
  final String text;
  final ValueChanged<T?> onChanged;
  final ValueChanged<T?> onDurationChanged;

  const MyRadioOption({
    required this.groupDurationValue,
    required this.duration,
    required this.value,
    required this.groupValue,
    required this.text,
    required this.onChanged,
    required this.onDurationChanged
  });

  Widget _buildLabel() {
    final bool isSelected = value == groupValue;
    return Container(
      padding: EdgeInsets.only(left: space_2),
      margin: EdgeInsets.fromLTRB(0, (space_3 - 1), 0, 0),
      width: (space_40 + space_18),
      height: (space_18 + 2),
      decoration: BoxDecoration(
          color: isSelected ? bidBackground : white,
          borderRadius: BorderRadius.circular((radius_1 + 2))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: isSelected ? AssetImage(
                'assets/icons/selectedIcon.png'
            ) : AssetImage(
                'assets/icons/blueCircle.png'
            ),
            height: space_4,
            width: space_4,
          ),
          SizedBox(
            width: space_4,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(),
              SizedBox(
                height: space_3,
              ),
              Row(
                children: [
                  Container(
                    child: Image(
                      image: AssetImage(
                          'assets/icons/tickIcon.png'),
                      height: (space_2 - 1),
                      width: (space_2 - 3),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      "Truck location",
                      style: TextStyle(
                          color: isSelected ? white : bidBackground,
                          fontWeight: regularWeight,
                          fontSize: size_6
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: (space_1 - 2),
              ),
              Row(
                children: [
                  Container(
                    child: Image(
                      image: AssetImage(
                          'assets/icons/tickIcon.png'
                      ),
                      height: (space_2 - 1),
                      width: (space_2 - 3),
                    ),
                  ),
                  SizedBox(
                    width: space_1,
                  ),
                  Container(
                    child: Text(
                      "1 year replacement warranty",
                      style: TextStyle(
                          color: isSelected ? white : bidBackground,
                          fontWeight: regularWeight,
                          fontSize: size_6
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildText() {
    final bool isSelected = value == groupValue;
    return Text(
      text,
      style: TextStyle(
          color: isSelected ? white : bidBackground,
          fontWeight: mediumBoldWeight,
          fontSize: size_7
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        onChanged(value),
        onDurationChanged(duration),
      },
        child: Row(
          children: [
            _buildLabel()
          ],
        ),
    );
  }
}

class BuyGpsScreen extends StatefulWidget {
  const BuyGpsScreen({Key? key}) : super(key: key);

  @override
  _BuyGpsScreenState createState() => _BuyGpsScreenState();
}

class _BuyGpsScreenState extends State<BuyGpsScreen> {

  String? _groupValue;
  String? _durationGroupValue;
  TransporterIdController transporterIdController = Get.find<TransporterIdController>();
  TruckModel truckModel = TruckModel();
  ScrollController scrollController = ScrollController();
  String? truckID;
  List truckNUMBERDataList = [];
  List truckIDDataList = [];
  bool loading = false;
  late List jsonData;
  int i = 0;
  final String truckApiUrl = FlutterConfig.get('truckApiUrl');
  final String buyGPSApiUrl = FlutterConfig.get('buyGPSApiUrl');
  BuyGPSApiCalls buyGPSApiCalls = BuyGPSApiCalls();
  int? _selectedIndex;
  bool isDisable = false;
  String? gpsId;
  bool isButtonDisable = false;
  bool isRadioButtonDisable = false;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }
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
  ValueChanged<String?> _ratevalueChangedHandler() {
    return (value) => setState(() => {
      _groupValue = value!,
      isRadioButtonDisable = true,
    if(truckID == null) {
      isButtonDisable = false
    } else {
      isButtonDisable = true
    }
    }
    );
  }
  ValueChanged<String?> _durationvalueChangedHandler() {
    return (duration) => setState(() => _durationGroupValue = duration!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          body: Container(
            margin: EdgeInsets.fromLTRB(space_3, space_4, space_3, 0),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: space_4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Header(
                              reset: false,
                              text: 'Buy GPS',
                              backButton: true),
                          HelpButtonWidget()
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(space_3, 0, space_3, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Plan",
                                  style: TextStyle(
                                    color: veryDarkGrey,
                                    fontSize: size_8,
                                    fontWeight: mediumBoldWeight
                                  ),
                                ),
                                MyRadioOption<String>(
                                  value: '2500',
                                  groupValue: _groupValue,
                                  duration: '1 year',
                                  groupDurationValue: _durationGroupValue,
                                  onDurationChanged: _durationvalueChangedHandler(),
                                  onChanged: _ratevalueChangedHandler(),
                                  text: '₹2500/ year',
                                ),
                                MyRadioOption<String>(
                                  value: '3500',
                                  duration: '2 years',
                                  groupValue: _groupValue,
                                  groupDurationValue: _durationGroupValue,
                                  onDurationChanged: _durationvalueChangedHandler(),
                                  onChanged: _ratevalueChangedHandler(),
                                  text: '₹3500/ 2 years',
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: space_2,
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: space_3),
                        child: SearchLoadWidget(
                          hintText: 'Search truck',
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => NextUpdateAlertDialog());
                          },
                        )
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select Truck",
                            style: TextStyle(
                                color: bidBackground,
                                fontSize: size_9,
                                fontWeight: mediumBoldWeight
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {
                              showDialog(
                                  context: context,
                                  builder: (context) => buyGPSAddTruckDialog()),
                            },
                              child: Row(
                                children: [
                                  Text(
                                    "+",
                                    style: TextStyle(
                                      color: bidBackground,
                                      fontSize: size_9,
                                      fontWeight: mediumBoldWeight
                                    ),
                                  ),
                                  Text(
                                    "Add Truck",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: bidBackground,
                                        fontSize: size_9,
                                        fontWeight: mediumBoldWeight
                                    ),
                                  ),
                                ],
                              )
                          )
                        ]
                    ),
                    Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height - (space_44 * 2),
                            width: double.infinity,
                            child: loading
                                ? TruckLoadingLongWidgets()
                                : truckNUMBERDataList.isEmpty
                                ? Container(
                              // height: MediaQuery.of(context).size.height * 0.27,
                              child: Container(
                                height: space_20,
                                child: Column(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'assets/images/TruckListEmptyImage.png'),
                                      height: (space_25 + 2),
                                      width: (space_25 + 2),
                                    ),
                                    Text(
                                      'Looks like you have not added any Trucks!',
                                      style: TextStyle(
                                          fontSize: size_8, 
                                          color: grey
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : ListView.builder(
                                controller: scrollController,
                                padding: EdgeInsets.only(bottom: space_15),
                                itemCount: truckNUMBERDataList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _onSelected(index);
                                      truckID = truckIDDataList[index];
                                      if(isRadioButtonDisable == false || truckID == null) {
                                        isButtonDisable = false;
                                      } else {
                                        isButtonDisable = true;
                                      }
                                    },
                                    child: TrucksLongCard(
                                      borderCard: _selectedIndex != null && _selectedIndex == index
                                          ? Border.all(color: bidBackground)
                                          : null,
                                      TruckNo: "${truckNUMBERDataList[index]}",
                                    ),
                                  );
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: space_2),
                            child: Container(
                                height: space_8,
                                width: (space_20 + space_40),
                                margin: EdgeInsets.only(bottom: space_2),
                                child:  TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            isDisable
                                                ? bidBackground
                                                : isButtonDisable
                                                ? bidBackground
                                                : solidLineColor
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(radius_6)
                                            )
                                        )
                                    ),
                                    onPressed: isButtonDisable
                                        ? () async {
                                      EasyLoading.instance
                                        ..indicatorType = EasyLoadingIndicatorType.ring
                                        ..indicatorSize = 45.0
                                        ..radius = 10.0
                                        ..maskColor = darkBlueColor
                                        ..userInteractions = false
                                        ..backgroundColor = darkBlueColor
                                        ..dismissOnTap = false;
                                      EasyLoading.show(
                                        status: "Loading...",
                                      );
                                      gpsId = await buyGPSApiCalls.postByGPSData(
                                          rate: _groupValue,
                                          duration: _durationGroupValue,
                                          address: "By App",
                                          truckId: truckID);
                                      if (gpsId != null) {
                                        EasyLoading.dismiss();
                                        Get.snackbar("Successfully Purchased", "$gpsId");
                                      } else {
                                        EasyLoading.dismiss();
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return SameTruckAlertDialogBox();
                                            });
                                      }
                                    }
                                        : null,
                                    child: isButtonDisable
                                    ? Text(
                                      "Pay $_groupValue",
                                      style: TextStyle(
                                        color: greyishWhiteColor,
                                        fontWeight: mediumBoldWeight,
                                        fontSize: size_9,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                        : Text(
                                      "Pay NA",
                                      style: TextStyle(
                                        color: greyishWhiteColor,
                                        fontWeight: mediumBoldWeight,
                                        fontSize: size_9,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                )
                            ),
                          ),
                      ]
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }

  getTruckData(int i) async {
    http.Response response = await http.get(Uri.parse(
        '$truckApiUrl?transporterId=${transporterIdController.transporterId.value}&pageNo=$i'));
    jsonData = json.decode(response.body);
    for (var json in jsonData) {
      truckModel.truckId = json["truckId"] != null ? json["truckId"] : 'NA';
      truckModel.transporterId =
      json["transporterId"] != null ? json["transporterId"] : 'NA';
      truckModel.truckNo = json["truckNo"] != null ? json["truckNo"] : 'NA';
      truckModel.truckApproved =
      json["truckApproved"] != null ? json["truckApproved"] : false;
      truckModel.imei = json["imei"] != null ? json["imei"] : 'NA';
      truckModel.passingWeightString = json["passingWeight"] != null
          ? json["passingWeight"].toString()
          : 'NA';
      truckModel.truckType =
      json["truckType"] != null ? json["truckType"] : 'NA';
      truckModel.driverId = json["driverId"] != null ? json["driverId"] : 'NA';
      truckModel.tyresString =
      json["tyres"] != null ? json["tyres"].toString() : 'NA';
      truckModel.truckLengthString =
      json["truckLength"] != null ? json["truckLength"].toString() : 'NA';
      setState(() {
        truckNUMBERDataList.add(truckModel.truckNo);
        truckIDDataList.add(truckModel.truckId);
      });
    } //for loop
    setState(() {
      loading = false;
    });
  } //getTruckData

}
